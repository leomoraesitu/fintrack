import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_form_event.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionFormBloc
    extends Bloc<TransactionFormEvent, TransactionFormState> {
  TransactionFormBloc({required TransactionRepository repository})
    : _repository = repository,
      super(const TransactionFormInitial()) {
    on<TransactionFormSubmitted>(_onTransactionFormSubmitted);
  }

  final TransactionRepository _repository;

  void _onTransactionFormSubmitted(
    TransactionFormSubmitted event,
    Emitter<TransactionFormState> emit,
  ) {
    emit(const TransactionFormSubmitting());

    try {
      _repository.addTransaction(event.transaction);
      emit(const TransactionFormSuccess());
    } catch (error) {
      emit(TransactionFormError(message: error.toString()));
    }
  }
}
