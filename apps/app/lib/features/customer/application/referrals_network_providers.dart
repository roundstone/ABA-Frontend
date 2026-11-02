import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/referrals_network_repository.dart';
import '../domain/referral_network_member.dart';

export '../data/referrals_network_repository.dart';
export '../domain/referral_network_member.dart';

enum ReferralNetworkViewMode {
  downline,
  upline;

  String get displayName {
    switch (this) {
      case ReferralNetworkViewMode.downline:
        return 'Downline Network';
      case ReferralNetworkViewMode.upline:
        return 'Upline Mentors';
    }
  }
}

final referralsNetworkRepoProvider =
    Provider<ReferralsNetworkRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ReferralsNetworkRemoteRepository(dio: dio);
});

final referralNetworkViewModeProvider =
    StateProvider.autoDispose<ReferralNetworkViewMode>((ref) {
  return ReferralNetworkViewMode.downline;
});

final referralNetworkDepthProvider = StateProvider.autoDispose<int>((ref) {
  return 1;
});

final referralUplineProvider = FutureProvider.autoDispose
    .family<List<ReferralNetworkMember>, int>((ref, depth) async {
  final repo = ref.watch(referralsNetworkRepoProvider);
  return repo.getUpline(depth: depth);
});

final referralDownlineProvider = FutureProvider.autoDispose
    .family<List<ReferralNetworkMember>, int>((ref, depth) async {
  final repo = ref.watch(referralsNetworkRepoProvider);
  return repo.getDownline(depth: depth);
});

