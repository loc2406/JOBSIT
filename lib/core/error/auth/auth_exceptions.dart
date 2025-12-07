// lib/core/error/exceptions.dart

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

// LOGIN

class AccountNotFoundException implements Exception {}

class IncorrectPasswordException implements Exception {}

class AccountNotActiveException implements Exception {}

// REGISTER

class InvalidInfoException implements Exception {}

class EmailIsUsedException implements Exception {}

class PhoneIsUsedException implements Exception {}

// GET DETAIL

class CandidateNotFoundException implements Exception{}
