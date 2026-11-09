import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart.dart';
import '../services/checkout_api.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._api)
    : super(const CartState()); // T4: API injected via constructor
  final CheckoutApi _api;

  // T2: an equal state is still emitted so you can SEE bloc drop it (no onChange log line)
  void _commit(CartState next) =>
      emit(next == state ? next : state.commit(next));

  void add(Product p) =>
      _commit(state.copyWith(lines: state.lines.withProduct(p)));
  void changeQty(String id, int delta) =>
      _commit(state.copyWith(lines: state.lines.changeQty(id, delta)));
  void applyCoupon(String code) => _commit(state.withCoupon(code));
  void undo() => emit(state.undo());

  Future<void> checkout() async {
    emit(state.copyWith(status: CheckoutStatus.submitting));
    try {
      final id = await _api.submit(state.total);
      if (isClosed)
        return; // page popped during the await: emit after close() throws
      emit(CartState(status: CheckoutStatus.success, orderId: id));
    } on CheckoutException catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          checkoutError: e.message,
        ),
      );
    }
  }

  @override
  void onChange(Change<CartState> change) {
    super.onChange(change);
    debugPrint(
      'CartCubit onChange: ${change.currentState} -> ${change.nextState}',
    );
  }
}
