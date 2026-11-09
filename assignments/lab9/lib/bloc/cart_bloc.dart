import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart.dart';
import '../services/checkout_api.dart';
import 'cart_event.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._api) : super(const CartState()) {
    on<CartProductAdded>(
      (e, emit) => _commit(
        e,
        state.copyWith(lines: state.lines.withProduct(e.product)),
        emit,
      ),
    );
    on<CartQtyChanged>(
      (e, emit) => _commit(
        e,
        state.copyWith(lines: state.lines.changeQty(e.productId, e.delta)),
        emit,
      ),
    );
    on<CartCouponApplied>(
      (e, emit) => _commit(e, state.withCoupon(e.code), emit),
    );
    on<CartUndone>((e, emit) => emit(state.undo()));
    // T4: while a checkout is running, further CartCheckoutRequested events are dropped
    on<CartCheckoutRequested>(_onCheckout, transformer: droppable());
  }

  final CheckoutApi _api;

  // T5: which events are undoable — exhaustive switch over the sealed class
  static bool _undoable(CartEvent e) => switch (e) {
    CartProductAdded() || CartQtyChanged() || CartCouponApplied() => true,
    CartCheckoutRequested() || CartUndone() => false,
  };

  void _commit(CartEvent e, CartState next, Emitter<CartState> emit) =>
      emit(_undoable(e) && next != state ? state.commit(next) : next);

  Future<void> _onCheckout(
    CartCheckoutRequested e,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CheckoutStatus.submitting));
    try {
      final id = await _api.submit(state.total);
      if (emit.isDone)
        return; // bloc closed / handler cancelled during the await
      emit(CartState(status: CheckoutStatus.success, orderId: id));
    } on CheckoutException catch (err) {
      if (emit.isDone) return;
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          checkoutError: err.message,
        ),
      );
    }
  }
}
