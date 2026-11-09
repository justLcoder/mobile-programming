import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart.dart';
import '../services/checkout_api.dart';
import '../widgets/cart_body.dart';
import '../widgets/cart_extras.dart';
import 'cart_bloc.dart';
import 'cart_event.dart';

class BlocCartPage extends StatelessWidget {
  const BlocCartPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => CartBloc(CheckoutApi()),
    child: const _BlocCartView(),
  );
}

class _BlocCartView extends StatelessWidget {
  const _BlocCartView();

  @override
  Widget build(BuildContext context) => BlocListener<CartBloc, CartState>(
    listenWhen: (p, c) => p.status != c.status,
    listener: (context, state) {
      if (state.status == CheckoutStatus.submitting) {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      } else {
        showCheckoutResult(context, state);
      }
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Cart · Bloc'),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            buildWhen: (p, c) => p.canUndo != c.canUndo,
            builder: (context, state) => IconButton(
              icon: const Icon(Icons.undo),
              tooltip: 'Undo',
              onPressed: state.canUndo
                  ? () => context.read<CartBloc>().add(const CartUndone())
                  : null,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) => Column(
                children: [
                  Expanded(
                    child: CartBody(
                      lines: state.lines,
                      onAdd: (p) =>
                          context.read<CartBloc>().add(CartProductAdded(p)),
                      onQtyChanged: (id, d) =>
                          context.read<CartBloc>().add(CartQtyChanged(id, d)),
                    ),
                  ),
                  CouponField(
                    error: state.couponError,
                    onApply: (code) =>
                        context.read<CartBloc>().add(CartCouponApplied(code)),
                  ),
                ],
              ),
            ),
          ),
          // T3: same BlocSelector as Part 4, parameterised on CartBloc
          BlocSelector<CartBloc, CartState, (int, double, double, double)>(
            selector: (s) => (s.itemCount, s.subtotal, s.discount, s.total),
            builder: (context, n) => SummaryCard(
              items: n.$1,
              subtotal: n.$2,
              discount: n.$3,
              total: n.$4,
            ),
          ),
          BlocBuilder<CartBloc, CartState>(
            buildWhen: (p, c) =>
                p.status != c.status || p.lines.isEmpty != c.lines.isEmpty,
            builder: (context, state) => CheckoutButton(
              submitting: state.status == CheckoutStatus.submitting,
              lockWhileSubmitting:
                  false, // let taps through; droppable() handles them
              onPressed: state.lines.isEmpty
                  ? null
                  : () => context.read<CartBloc>().add(
                      const CartCheckoutRequested(),
                    ),
            ),
          ),
        ],
      ),
    ),
  );
}
