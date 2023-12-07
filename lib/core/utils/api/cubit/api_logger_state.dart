part of 'api_logger_cubit.dart';

abstract class ApiLoggerState extends Equatable {
  const ApiLoggerState();

  @override
  List<Object> get props => [];
}

class ApiLoggerInitial extends ApiLoggerState {}

class ApiLoggerData extends ApiLoggerState {}
