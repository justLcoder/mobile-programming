import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart.dart';
import '../services/checkout_api.dart';
import '../widgets/cart_body.dart';
import '../widgets/cart_extras.dart';
import 'cart_cubit.dart';

class CubitCartPage extends StatelessWidget {
  const CubitCartPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) =>
        CartCubit(CheckoutApi()), // scoped to this page, closed on dispose
    child: const _CubitCartView(),
  );
}

// Separate widget so its `context` is BELOW the BlocProvider.
class _CubitCartView extends StatelessWidget {
  const _CubitCartView();

  @override
  Widget build(BuildContext context) => BlocListener<CartCubit, CartState>(
    // T4: side effects only when status changes
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
        title: const Text('Cart · Cubit'),
        actions: [
          // T5: canUndo is part of state, so BlocBuilder sees it change
          BlocBuilder<CartCubit, CartState>(
            buildWhen: (p, c) => p.canUndo != c.canUndo,
            builder: (context, state) => IconButton(
              icon: const Icon(Icons.undo),
              tooltip: 'Undo',
              onPressed: state.canUndo
                  ? () => context.read<CartCubit>().undo()
                  : null,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<CartCubit, CartState>(
              builder: (context, state) => Column(
                children: [
                  Expanded(
                    child: CartBody(
                      lines: state.lines,
                      onAdd: (p) => context.read<CartCubit>().add(p),
                      onQtyChanged: (id, d) =>
                          context.read<CartCubit>().changeQty(id, d),
                    ),
                  ),
                  CouponField(
                    error: state.couponError,
                    onApply: (code) =>
                        context.read<CartCubit>().applyCoupon(code),
                  ),
                ],
              ),
            ),
          ),
          // T3: rebuilds only when the selected numbers change (record = value equality)
          BlocSelector<CartCubit, CartState, (int, double, double, double)>(
            selector: (s) => (s.itemCount, s.subtotal, s.discount, s.total),
            builder: (context, n) => SummaryCard(
              items: n.$1,
              subtotal: n.$2,
              discount: n.$3,
              total: n.$4,
            ),
          ),
          BlocBuilder<CartCubit, CartState>(
            buildWhen: (p, c) =>
                p.status != c.status || p.lines.isEmpty != c.lines.isEmpty,
            builder: (context, state) => CheckoutButton(
              submitting: state.status == CheckoutStatus.submitting,
              onPressed: state.lines.isEmpty
                  ? null
                  : () => context.read<CartCubit>().checkout(),
            ),
          ),
        ],
      ),
    ),
  );
}
