import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../services/checkout_api.dart';
import '../widgets/cart_body.dart';
import '../widgets/cart_extras.dart';

class SetStateCartPage extends StatefulWidget {
  const SetStateCartPage({super.key});
  @override
  State<SetStateCartPage> createState() => _SetStateCartPageState();
}

class _SetStateCartPageState extends State<SetStateCartPage> {
  final _api = CheckoutApi();
  CartState _state = const CartState(); // state lives on the State object
  final List<CartState> _history = []; // T5

  // every user mutation goes through here so undo works
  void _commit(CartState next) => setState(() {
    _history.add(_state);
    _state = next;
  });

  void _add(Product p) =>
      _commit(_state.copyWith(lines: _state.lines.withProduct(p)));
  void _changeQty(String id, int delta) =>
      _commit(_state.copyWith(lines: _state.lines.changeQty(id, delta)));
  void _applyCoupon(String code) => _commit(_state.withCoupon(code));
  void _undo() => setState(() => _state = _history.removeLast());

  Future<void> _checkout() async {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    setState(
      () => _state = _state.copyWith(status: CheckoutStatus.submitting),
    ); // not in history
    try {
      final id = await _api.submit(_state.total);
      if (!mounted) return; // page may have been popped during the await
      setState(() {
        _state = CartState(
          status: CheckoutStatus.success,
          orderId: id,
        ); // clear cart
        _history.clear();
      });
      showCheckoutResult(context, _state);
    } on CheckoutException catch (e) {
      if (!mounted) return;
      setState(
        () => _state = _state.copyWith(
          status: CheckoutStatus.failure,
          checkoutError: e.message,
        ),
      );
      showCheckoutResult(context, _state); // cart is kept
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Cart · setState'),
      actions: [
        IconButton(
          icon: const Icon(Icons.undo),
          tooltip: 'Undo',
          onPressed: _history.isEmpty ? null : _undo,
        ),
      ],
    ),
    body: Column(
      children: [
        Expanded(
          child: CartBody(
            lines: _state.lines,
            onAdd: _add,
            onQtyChanged: _changeQty,
          ),
        ),
        CouponField(error: _state.couponError, onApply: _applyCoupon),
        SummaryCard.of(_state),
        CheckoutButton(
          submitting: _state.status == CheckoutStatus.submitting,
          onPressed: _state.lines.isEmpty ? null : _checkout,
        ),
      ],
    ),
  );
}
