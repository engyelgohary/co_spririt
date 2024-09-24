part of 'OA_cubit.dart';

@immutable
sealed class OpportunityAnalyzerState {}

final class OpportunityAnalyzerInitial extends OpportunityAnalyzerState {}
final class OpportunityAnalyzerLoading extends OpportunityAnalyzerState {}
final class OpportunityAnalyzerError extends OpportunityAnalyzerState {
  final String? errorMessage;
  OpportunityAnalyzerError({required this.errorMessage});
}
final class OpportunityAnalyzerSuccess extends OpportunityAnalyzerState {
  final OA? opportunityAnalyzerData;
  final List<OA>? getOAs;
  OpportunityAnalyzerSuccess({this.getOAs, this.opportunityAnalyzerData});
}
class OpportunityAnalyzerImageSelected extends OpportunityAnalyzerState {
  final XFile image;
  OpportunityAnalyzerImageSelected(this.image);
}
final class OpportunityAnalyzerDetailsSuccess extends OpportunityAnalyzerState {
  final OA opportunityAnalyzerData;
  OpportunityAnalyzerDetailsSuccess({required this.opportunityAnalyzerData});
}