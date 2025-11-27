import 'package:easy_localization/easy_localization.dart';
import 'package:jobsit_mobile/core/error/failures.dart';

class NoInternetFailure extends Failure {
  NoInternetFailure() : super('error.no_internet'.tr());
}

class NetworkFailure extends Failure {
  NetworkFailure() : super('error.weak_internet'.tr());
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

