import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class UnknownFailure extends Failure {
  UnknownFailure() : super('error.something_went_wrong'.tr());
}