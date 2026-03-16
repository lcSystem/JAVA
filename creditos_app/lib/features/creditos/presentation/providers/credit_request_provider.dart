import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/credit_models.dart';

class CreditRequestState {
  final DebtorInfo? debtorInfo;
  final List<Reference> references;
  final List<PreviousCredit> previousCredits;
  final List<CoDebtor> coDebtors;

  const CreditRequestState({
    this.debtorInfo,
    this.references = const [],
    this.previousCredits = const [],
    this.coDebtors = const [],
  });

  CreditRequestState copyWith({
    DebtorInfo? debtorInfo,
    List<Reference>? references,
    List<PreviousCredit>? previousCredits,
    List<CoDebtor>? coDebtors,
  }) {
    return CreditRequestState(
      debtorInfo: debtorInfo ?? this.debtorInfo,
      references: references ?? this.references,
      previousCredits: previousCredits ?? this.previousCredits,
      coDebtors: coDebtors ?? this.coDebtors,
    );
  }
}

class CreditRequestNotifier extends StateNotifier<CreditRequestState> {
  CreditRequestNotifier() : super(const CreditRequestState(
    references: [],
    previousCredits: [],
    coDebtors: [],
  ));

  void updateDebtorInfo(DebtorInfo info) {
    state = state.copyWith(debtorInfo: info);
  }

  void setReferences(List<Reference> references) {
    state = state.copyWith(references: references);
  }

  void setPreviousCredits(List<PreviousCredit> credits) {
    state = state.copyWith(previousCredits: credits);
  }

  void setCoDebtors(List<CoDebtor> coDebtors) {
    state = state.copyWith(coDebtors: coDebtors);
  }

  void reset() {
    state = const CreditRequestState();
  }
}

final creditRequestProvider = StateNotifierProvider<CreditRequestNotifier, CreditRequestState>((ref) {
  return CreditRequestNotifier();
});
