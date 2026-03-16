import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/credits_repository.dart';
import '../../domain/models/credit_models.dart';

/// Provider that fetches the most recent credit request for the current user.
final lastCreditProvider = FutureProvider<CreditRequest?>((ref) async {
  final authState = ref.watch(authStateProvider);
  if (authState.customer == null) return null;

  try {
    final credits = await ref.read(creditsRepositoryProvider).getMyCredits(authState.customer!.id);
    if (credits.isEmpty) return null;

    // Filter for requests that have debtor info and return the most recent one
    final historical = credits.where((c) => c.debtorAdditionalInfo != null).toList();
    if (historical.isEmpty) return null;

    // getMyCredits should already be sorted by date descending, but let's be safe
    return historical.first;
  } catch (e) {
    return null;
  }
});
