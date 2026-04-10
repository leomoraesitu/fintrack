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

class TransactionFormError extends TransactionFormState {
  final String message;

  const TransactionFormError({required this.message});
}