import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart.dart';
import '../widgets/cart_body.dart';
import '../widgets/cart_extras.dart';
import 'cart_notifier.dart';

class RiverpodCartPage extends ConsumerWidget {
  const RiverpodCartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // T4: side effects belong in listen, never in build
    ref.listen(cartProvider.select((s) => s.status), (prev, next) {
      if (next == CheckoutStatus.submitting) {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      } else if (next == CheckoutStatus.success ||
          next == CheckoutStatus.failure) {
        showCheckoutResult(context, ref.read(cartProvider));
      }
    });

    // T2: logs every notification — apply SAVE10 twice and compare
    ref.listen(
      cartProvider,
      (prev, next) => debugPrint(
        'cartProvider notified: coupon=${next.coupon} error=${next.couponError}',
      ),
    );

    final state = ref.watch(cartProvider); // subscribe: rebuild on change
    final cart = ref.read(
      cartProvider.notifier,
    ); // method handles, no subscription
    final canUndo = ref.watch(canUndoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart · Riverpod'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: 'Undo',
            onPressed: canUndo ? cart.undo : null,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CartBody(
              lines: state.lines,
              onAdd: cart.add,
              onQtyChanged: cart.changeQty,
            ),
          ),
          CouponField(error: state.couponError, onApply: cart.applyCoupon),
          const RiverpodSummaryCard(), // const: parent rebuilds don't rebuild it
          CheckoutButton(
            submitting: state.status == CheckoutStatus.submitting,
            onPressed: state.lines.isEmpty ? null : cart.checkout,
          ),
        ],
      ),
    );
  }
}

/// T3: rebuilds only when the selected numbers change.
class RiverpodSummaryCard extends ConsumerWidget {
  const RiverpodSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // A record has value equality, so this rebuilds only when one of the numbers changes.
    final (items, subtotal, discount, total) = ref.watch(
      cartProvider.select(
        (s) => (s.itemCount, s.subtotal, s.discount, s.total),
      ),
    );
    return SummaryCard(
      items: items,
      subtotal: subtotal,
      discount: discount,
      total: total,
    );
  }
}
