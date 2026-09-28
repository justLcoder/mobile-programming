enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered;

  bool canMoveTo(OrderStatus next) {
    return switch (this) {
      OrderStatus.pending => next == OrderStatus.processing,

      OrderStatus.processing => next == OrderStatus.shipped,

      OrderStatus.shipped => next == OrderStatus.delivered,

      OrderStatus.delivered => false,
    };
  }
}

void main() {
  OrderStatus current = OrderStatus.pending;

  if (current.canMoveTo(OrderStatus.processing)) {
    current = OrderStatus.processing;
  }

  print(current);
}
