part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class SurveyFormLoading extends HomeState {}

final class SurveyFormData extends HomeState {
  final SurveyForm surveyFormData;
  const SurveyFormData({required this.surveyFormData});

  @override
  List<Object> get props => [surveyFormData];
}

final class SurveyFormError extends HomeState {
  final Map<String, dynamic> storedData;
  final bool isValidated;
  const SurveyFormError({required this.storedData, required this.isValidated});

  @override
  List<Object> get props => [storedData, isValidated];
}

final class SurveyFormUploadLoading extends HomeState {}

final class SurveyFormUploadSuccess extends HomeState {
  final DateTime id;
  const SurveyFormUploadSuccess({required this.id});

  @override
  List<Object> get props => [id];
}
