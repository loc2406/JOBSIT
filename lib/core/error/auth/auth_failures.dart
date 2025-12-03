import 'package:easy_localization/easy_localization.dart';
import 'package:jobsit_mobile/core/error/failures.dart';

// LOGIN

class AccountNotFoundFailure extends Failure {
  AccountNotFoundFailure() : super('error.auth.account_not_found'.tr());
}

class IncorrectPasswordFailure extends Failure {
  IncorrectPasswordFailure() : super('error.auth.incorrect_password'.tr());
}

class AccountNotActiveFailure extends Failure {
  AccountNotActiveFailure() : super('error.auth.account_not_active'.tr());
}

// REGISTER

class InvalidInfoFailure extends Failure {
  InvalidInfoFailure() : super('error.auth.invalid_info'.tr());
}

class EmailIsUsedFailure extends Failure {
  EmailIsUsedFailure() : super('error.auth.email_is_used'.tr());
}

class PhoneIsUsedFailure extends Failure {
  PhoneIsUsedFailure() : super('error.auth.phone_is_used'.tr());
}
