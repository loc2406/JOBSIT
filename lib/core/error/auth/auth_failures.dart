import 'package:easy_localization/easy_localization.dart';
import 'package:jobsit_mobile/core/error/failures.dart';

class AccountNotFoundFailure extends Failure {
  AccountNotFoundFailure() : super('error.auth.account_not_found'.tr());
}

class IncorrectPasswordFailure extends Failure {
  IncorrectPasswordFailure() : super('error.auth.incorrect_password'.tr());
}

class AccountNotActiveFailure extends Failure {
  AccountNotActiveFailure() : super('error.auth.account_not_active'.tr());
}

