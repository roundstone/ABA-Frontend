import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/commission_service.dart';
import '../domain/commission_models.dart';

export '../domain/commission_models.dart';

final commissionServiceProvider = Provider<CommissionService>((ref) {
  final dio = ref.watch(dioProvider);
  return CommissionService(dio: dio);
});

final commissionOverviewProvider =
    FutureProvider.autoDispose<CommissionOverview>((ref) async {
  final service = ref.watch(commissionServiceProvider);
  return service.getOverview();
});

final commissionFilterStatusProvider = StateProvider.autoDispose<int?>((ref) {
  return null; // null represents All
});

final commissionsListProvider =
    FutureProvider.autoDispose<PaginatedCommissions>((ref) async {
  final service = ref.watch(commissionServiceProvider);
  final status = ref.watch(commissionFilterStatusProvider);
  return service.getCommissions(page: 1, limit: 20, status: status);
});

