import 'package:bloc_test/bloc_test.dart';
import 'package:cart_four_ways/cubit/cart_cubit.dart';
import 'package:cart_four_ways/models/cart.dart';
import 'package:cart_four_ways/services/checkout_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckoutApi extends Mock implements CheckoutApi {}

void main() {
  late MockCheckoutApi api;
  final keyboard = catalog[0];

  setUp(() => api = MockCheckoutApi());

  blocTest<CartCubit, CartState>(
    'Keyboard x2 + SAVE10 emits three states ending at 88.20',
    build: () => CartCubit(api),
    act: (c) {
      c.add(keyboard);
      c.add(keyboard);
      c.applyCoupon('SAVE10');
    },
    expect: () => [
      isA<CartState>().having((s) => s.itemCount, 'items', 1),
      isA<CartState>().having((s) => s.itemCount, 'items', 2),
      isA<CartState>()
          .having((s) => s.coupon, 'coupon', 'SAVE10')
          .having((s) => s.total, 'total', closeTo(88.2, 1e-9)),
    ],
  );

  blocTest<CartCubit, CartState>(
    'failed checkout emits submitting then failure and keeps lines',
    setUp: () =>
        when(() => api.submit(any()))
            .thenThrow(const CheckoutException('Card declined')),
    build: () => CartCubit(api),
    act: (c) async {
      c.add(keyboard);
      await c.checkout();
    },
    expect: () => [
      isA<CartState>().having((s) => s.itemCount, 'items', 1),
      isA<CartState>().having(
        (s) => s.status,
        'status',
        CheckoutStatus.submitting,
      ),
      isA<CartState>()
          .having((s) => s.status, 'status', CheckoutStatus.failure)
          .having((s) => s.lines, 'lines', isNotEmpty),
    ],
  );
}
