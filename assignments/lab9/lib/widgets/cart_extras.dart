import 'package:flutter/material.dart';

import '../models/cart.dart';

/// T2: coupon input. Owns only its text controller; the coupon itself lives in the state holder.
class CouponField extends StatefulWidget {
  const CouponField({super.key, required this.error, required this.onApply});
  final String? error;
  final void Function(String code) onApply;

  @override
  State<CouponField> createState() => _CouponFieldState();
}

class _CouponFieldState extends State<CouponField> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: _ctrl,
            decoration: InputDecoration(
              labelText: 'Coupon',
              errorText: widget.error,
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.tonal(
          onPressed: () => widget.onApply(_ctrl.text),
          child: const Text('Apply'),
        ),
      ],
    ),
  );
}

/// T3: summary card. The debugPrint shows when it rebuilds.
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.total,
  });

  SummaryCard.of(CartState s, {Key? key})
    : this(
        key: key,
        items: s.itemCount,
        subtotal: s.subtotal,
        discount: s.discount,
        total: s.total,
      );

  final int items;
  final double subtotal;
  final double discount;
  final double total;

  @override
  Widget build(BuildContext context) {
    debugPrint('SummaryCard build (total ${total.toStringAsFixed(2)})');
    Widget row(String label, String value, {bool bold = false}) => Row(
      children: [
        Text(label),
        const Spacer(),
        Text(
          value,
          style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null,
        ),
      ],
    );
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            row('Items', '$items'),
            row('Subtotal', subtotal.toStringAsFixed(2)),
            row('Discount', '-${discount.toStringAsFixed(2)}'),
            row('Total', total.toStringAsFixed(2), bold: true),
          ],
        ),
      ),
    );
  }
}

/// T4: checkout button with spinner.
class CheckoutButton extends StatelessWidget {
  const CheckoutButton({
    super.key,
    required this.submitting,
    required this.onPressed,
  });
  final bool submitting;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(12),
    child: SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: submitting ? null : onPressed,
        icon: submitting
            ? const SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.shopping_cart_checkout),
        label: Text(submitting ? 'Submitting…' : 'Checkout'),
      ),
    ),
  );
}

/// T4: side effect — SnackBar on success, MaterialBanner on failure.
void showCheckoutResult(BuildContext context, CartState s) {
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentMaterialBanner();
  if (s.status == CheckoutStatus.success) {
    m.showSnackBar(SnackBar(content: Text('Order ${s.orderId} placed')));
  } else if (s.status == CheckoutStatus.failure) {
    m.showMaterialBanner(
      MaterialBanner(
        content: Text('Checkout failed: ${s.checkoutError}'),
        actions: [
          TextButton(
            onPressed: m.hideCurrentMaterialBanner,
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }
}
