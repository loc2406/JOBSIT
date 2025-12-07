import 'package:equatable/equatable.dart';
import 'package:jobsit_mobile/features/auth/domain/entities/candidate.dart';

class CandidateState extends Equatable {
  const CandidateState();

  factory CandidateState.loading() => AuthLoadingState();

  factory CandidateState.registerSuccess(String email) =>
      AuthRegisterSuccessState(email);

  factory CandidateState.sendOtpSuccess() => AuthSendOtpSuccessState();

  factory CandidateState.activeSuccess() => AuthActiveSuccessState();

  factory CandidateState.active() => AuthActiveState();

  factory CandidateState.loginSuccess(String token, Candidate candidate) =>
      AuthLoginSuccessState(token, candidate);

  factory CandidateState.error(String errorMessage) =>
      AuthErrorState(errorMessage);

  factory CandidateState.noLoggedIn() => AuthNoLoggedInState();

  factory CandidateState.getDetailSuccess(Candidate candidate) =>
      AuthGetDetailSuccessState(candidate);

  factory CandidateState.editSuccess() => AuthEditSuccessState();

  @override
  List<Object?> get props => [];
}

class AuthNoLoggedInState extends CandidateState {}

class AuthActiveState extends CandidateState {}

class AuthActiveSuccessState extends CandidateState {}

class AuthSendOtpSuccessState extends CandidateState {}

class AuthLoadingState extends CandidateState {}

class AuthLoginSuccessState extends CandidateState {
  final String token;
  final Candidate candidate;

  const AuthLoginSuccessState(this.token, this.candidate);
}

class AuthRegisterSuccessState extends CandidateState {
  final String email;

  const AuthRegisterSuccessState(this.email);
}

class AuthErrorState extends CandidateState {
  final String errMessage;

  const AuthErrorState(this.errMessage);
}

class AuthGetDetailSuccessState extends CandidateState {
  final Candidate candidate;
  
  const AuthGetDetailSuccessState(this.candidate);
}

class AuthEditSuccessState extends CandidateState {}
