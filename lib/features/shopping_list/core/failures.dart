import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
/// 
/// Uses [Equatable] for value comparison in tests.
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Failure related to local storage operations
class StorageFailure extends Failure {
  const StorageFailure({
    super.message = 'An error occurred while accessing local storage',
    super.code = 'STORAGE_ERROR',
  });
}

/// Failure when an item is not found
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'The requested item was not found',
    super.code = 'NOT_FOUND',
  });
}

/// Failure for validation errors
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_ERROR',
  });
}

/// Generic unexpected failure
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred',
    super.code = 'UNEXPECTED_ERROR',
  });
}
