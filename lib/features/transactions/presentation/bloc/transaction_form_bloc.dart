import 'package:fintrack/features/transactions/domain/exceptions/transaction_conflict_exception.dart';
import 'package:fintrack/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_form_event.dart';
import 'package:fintrack/features/transactions/presentation/bloc/transaction_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionFormBloc
    extends Bloc<TransactionFormEvent, TransactionFormState> {
  TransactionFormBloc({required TransactionRepository repository})
    : _repository = repository,
      super(const TransactionFormInitial()) {
    on<TransactionCreated>(_onTransactionCreated);
    on<TransactionUpdated>(_onTransactionUpdated);
    on<TransactionDeleted>(_onTransactionDeleted);
  }

  final TransactionRepository _repository;

  Future<void> _onTransactionCreated(
    TransactionCreated event,
    Emitter<TransactionFormState> emit,
  ) async {
    emit(const TransactionFormSubmitting());

    try {
      await _repository.addTransaction(event.transaction);
      emit(const TransactionFormSuccess());
    } catch (error) {
      emit(TransactionFormError(message: error.toString()));
    }
  }

  Future<void> _onTransactionUpdated(
    TransactionUpdated event,
    Emitter<TransactionFormState> emit,
  ) async {
    emit(const TransactionFormSubmitting());

    try {
      await _repository.updateTransaction(event.transaction);
      emit(const TransactionFormSuccess());
    } on TransactionConflictException catch (error) {
      emit(TransactionFormConflict(message: error.message));
    } catch (error) {
      emit(TransactionFormError(message: error.toString()));
    }
  }

  Future<void> _onTransactionDeleted(
    TransactionDeleted event,
    Emitter<TransactionFormState> emit,
  ) async {
    emit(const TransactionFormSubmitting());

    try {
      await _repository.deleteTransaction(event.id);
      emit(const TransactionFormSuccess());
    } catch (error) {
      emit(TransactionFormError(message: error.toString()));
    }
  }
}
