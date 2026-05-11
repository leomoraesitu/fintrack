abstract class TransactionFormState {
  const TransactionFormState();
}

class TransactionFormInitial extends TransactionFormState {
  const TransactionFormInitial();
}

class TransactionFormSubmitting extends TransactionFormState {
  const TransactionFormSubmitting();
}

class TransactionFormSuccess extends TransactionFormState {
  const TransactionFormSuccess();
}

class TransactionFormConflict extends TransactionFormState {
  const TransactionFormConflict({required this.message});

  final String message;
}

class TransactionFormError extends TransactionFormState {
  final String message;

  const TransactionFormError({required this.message});
}