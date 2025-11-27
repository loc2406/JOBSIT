import 'package:easy_localization/easy_localization.dart';
import 'package:jobsit_mobile/core/error/failures.dart';

class AccountNotFoundFailure extends Failure {
  AccountNotFoundFailure() : super('error.account_not_found'.tr());
}

class IncorrectPasswordFailure extends Failure {
  IncorrectPasswordFailure() : super('error.incorrect_password'.tr());
}
