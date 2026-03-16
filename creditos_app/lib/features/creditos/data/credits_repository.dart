import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/credit_models.dart';

/// Repository for credit-related API calls.
class CreditsRepository {
  final ApiClient _api = ApiClient();

  Future<List<CreditType>> getCreditTypes() async {
    final response = await _api.dio.get(ApiEndpoints.creditTypes);
    return (response.data as List)
        .map((json) => CreditType.fromJson(json))
        .toList();
  }

  Future<Map<String, dynamic>> simulate({
    required int creditTypeId,
    required double amount,
    required int termMonths,
  }) async {
    final response = await _api.dio.post(ApiEndpoints.simulate, data: {
      'creditTypeId': creditTypeId,
      'amount': amount,
      'termMonths': termMonths,
    });
    return response.data;
  }

  Future<CreditRequest> submitRequest({
    required int applicantUserId,
    required int creditTypeId,
    required double amount,
    required int termMonths,
    required String purpose,
    required DebtorInfo debtorInfo,
    required List<Reference> references,
    required List<CoDebtor> coDebtors,
    required List<PreviousCredit> previousCredits,
  }) async {
    final response = await _api.dio.post(ApiEndpoints.submitCredit, data: {
      'applicantUserId': applicantUserId,
      'creditTypeId': creditTypeId,
      'amount': amount,
      'termMonths': termMonths,
      'purpose': purpose,
      'debtorAdditionalInfo': jsonEncode(debtorInfo.toJson()),
      'debtorReferences': references.map((r) => r.toJson()).toList(),
      'coDebtors': coDebtors.map((c) => c.toJson()).toList(),
      'previousCredits': previousCredits.map((p) => p.toJson()).toList(),
    });
    return CreditRequest.fromJson(response.data);
  }

  Future<CreditRequest> updateRequest({
    required int requestId,
    required double amount,
    required int termMonths,
    required String purpose,
    required DebtorInfo debtorInfo,
    required List<Reference> references,
    required List<CoDebtor> coDebtors,
    required List<PreviousCredit> previousCredits,
  }) async {
    final response = await _api.dio.put('${ApiEndpoints.creditRequests}/$requestId', data: {
      'amount': amount,
      'termMonths': termMonths,
      'purpose': purpose,
      'debtorAdditionalInfo': jsonEncode(debtorInfo.toJson()),
      'debtorReferences': references.map((r) => r.toJson()).toList(),
      'coDebtors': coDebtors.map((c) => c.toJson()).toList(),
      'previousCredits': previousCredits.map((p) => p.toJson()).toList(),
    });
    return CreditRequest.fromJson(response.data);
  }

  Future<List<CreditRequest>> getMyCredits(int userId) async {
    final response = await _api.dio.get(ApiEndpoints.myCredits(userId));
    return (response.data as List)
        .map((json) => CreditRequest.fromJson(json))
        .toList();
  }

  Future<CreditRequest> getCreditDetail(int id) async {
    final response = await _api.dio.get(ApiEndpoints.creditDetail(id));
    return CreditRequest.fromJson(response.data);
  }

  Future<List<Map<String, dynamic>>> getAmortization(int requestId) async {
    final response = await _api.dio.get(ApiEndpoints.amortization(requestId));
    return List<Map<String, dynamic>>.from(response.data);
  }
}

// Provider
final creditsRepositoryProvider = Provider<CreditsRepository>((ref) {
  return CreditsRepository();
});

final creditTypesProvider = FutureProvider<List<CreditType>>((ref) async {
  return ref.watch(creditsRepositoryProvider).getCreditTypes();
});
