part of 'calculate_cubit.dart';

@immutable
sealed class CalculateState {}

final class CalculateInitial extends CalculateState {}
final class InputError extends CalculateState{
  final String error;

  InputError({required this.error});
}
final class CalculateSuccess extends CalculateState{
  final String result;

  CalculateSuccess({required this.result});
}
