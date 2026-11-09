import 'package:bloc_test/bloc_test.dart';
import 'package:cart_four_ways/bloc/cart_bloc.dart';
import 'package:cart_four_ways/bloc/cart_event.dart';
import 'package:cart_four_ways/models/cart.dart';
import 'package:cart_four_ways/services/checkout_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckoutApi extends Mock implements CheckoutApi {}

void main() {
  late MockCheckoutApi api;
  final keyboard = catalog[0];

  setUp(() => api = MockCheckoutApi());

  blocTest<CartBloc, CartState>(
    'Keyboard x2 + SAVE10 emits three states ending at 88.20',
    build: () => CartBloc(api),
    act: (b) => b
      ..add(CartProductAdded(keyboard))
      ..add(CartProductAdded(keyboard))
      ..add(const CartCouponApplied('SAVE10')),
    expect: () => [
      isA<CartState>().having((s) => s.itemCount, 'items', 1),
      isA<CartState>().having((s) => s.itemCount, 'items', 2),
      isA<CartState>()
          .having((s) => s.coupon, 'coupon', 'SAVE10')
          .having((s) => s.total, 'total', closeTo(88.2, 1e-9)),
    ],
  );

  blocTest<CartBloc, CartState>(
    'failed checkout emits submitting then failure and keeps lines',
    setUp: () =>
        when(() => api.submit(any()))
            .thenThrow(const CheckoutException('Card declined')),
    build: () => CartBloc(api),
    act: (b) => b
      ..add(CartProductAdded(keyboard))
      ..add(const CartCheckoutRequested()),
    wait: const Duration(milliseconds: 100),
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

  blocTest<CartBloc, CartState>(
    'droppable: two checkout requests emit only one submitting',
    setUp: () => when(() => api.submit(any())).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return 'ORD-1';
    }),
    build: () => CartBloc(api),
    act: (b) => b
      ..add(CartProductAdded(keyboard))
      ..add(const CartCheckoutRequested())
      ..add(const CartCheckoutRequested()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      isA<CartState>().having((s) => s.itemCount, 'items', 1),
      isA<CartState>().having(
        (s) => s.status,
        'status',
        CheckoutStatus.submitting,
      ),
      isA<CartState>().having(
        (s) => s.status,
        'status',
        CheckoutStatus.success,
      ),
    ],
    verify: (_) => verify(() => api.submit(any())).called(1),
  );
}
