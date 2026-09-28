enum Status { pending, approved, rejected }

String getStatusText(Status status) {
  return switch (status) {
    Status.pending => 'Pending',
    Status.approved => 'Approved',
    Status.rejected => 'Rejected',
  };
}

void main() {
  Status currentStatus = Status.approved;

  print(getStatusText(currentStatus));
}
