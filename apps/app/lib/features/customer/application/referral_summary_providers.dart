import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/referral_summary_service.dart';
import '../domain/referral_summary_models.dart';

export '../data/referral_summary_service.dart';
export '../domain/referral_summary_models.dart';

final referralSummaryServiceProvider = Provider<ReferralSummaryService>((ref) {
  final dio = ref.watch(dioProvider);
  return ReferralSummaryService(dio: dio);
});

final referralDataProvider =
    FutureProvider.autoDispose<ReferralData>((ref) async {
  final service = ref.watch(referralSummaryServiceProvider);
  return service.fetchSummary();
});

