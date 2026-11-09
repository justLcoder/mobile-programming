import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart.dart';
import '../services/checkout_api.dart';

// T4: the API is a provider, so tests can override it
final checkoutApiProvider = Provider<CheckoutApi>((ref) => CheckoutApi());

class CartNotifier extends Notifier<CartState> {
  final _history = <CartState>[]; // T5: private field, NOT part of state

  @override
  CartState build() => const CartState();

  bool get canUndo => _history.isNotEmpty;

  void _commit(CartState next) {
    if (next == state)
      return; // nothing changed: no history entry, no notification
    _history.add(state);
    state = next; // assignment notifies listeners (if != old state)
  }

  void add(Product p) =>
      _commit(state.copyWith(lines: state.lines.withProduct(p)));
  void changeQty(String id, int delta) =>
      _commit(state.copyWith(lines: state.lines.changeQty(id, delta)));
  void applyCoupon(String code) => _commit(state.withCoupon(code));

  void undo() {
    if (_history.isEmpty) return;
    state = _history.removeLast();
  }

  Future<void> checkout() async {
    state = state.copyWith(status: CheckoutStatus.submitting);
    try {
      final id = await ref.read(checkoutApiProvider).submit(state.total);
      if (!ref.mounted)
        return; // only needed because the provider is autoDispose (see notes)
      _history.clear();
      state = CartState(status: CheckoutStatus.success, orderId: id);
    } on CheckoutException catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: CheckoutStatus.failure,
        checkoutError: e.message,
      );
    }
  }
}

// T5: autoDispose — remove `.autoDispose` to compare (cart then survives popping the page)
final cartProvider = NotifierProvider.autoDispose<CartNotifier, CartState>(
  CartNotifier.new,
);

// T5: derived provider. It must WATCH cartProvider, because _history isn't state:
// every state change re-runs this and re-reads canUndo from the notifier.
final canUndoProvider = Provider.autoDispose<bool>((ref) {
  ref.watch(cartProvider);
  return ref.read(cartProvider.notifier).canUndo;
});
