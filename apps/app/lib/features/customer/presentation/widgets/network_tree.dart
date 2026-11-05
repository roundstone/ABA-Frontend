import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../auth/application/auth_providers.dart';
import '../../application/referrals_network_providers.dart';
import '../marketer_profile_models.dart';
import 'network_member_tile.dart';
import 'network_tree_builder.dart';
import 'network_tree_header.dart';
import 'network_tree_node.dart';

export 'network_tree_node.dart';

class NetworkTreeWidget extends ConsumerStatefulWidget {
  final NetworkNode? data;
  final MarketerProfileData? profile;
  final bool anonymize;

  const NetworkTreeWidget({
    super.key,
    this.data,
    this.profile,
    this.anonymize = false,
  });

  @override
  ConsumerState<NetworkTreeWidget> createState() => _NetworkTreeWidgetState();
}

class _NetworkTreeWidgetState extends ConsumerState<NetworkTreeWidget> {
  bool _isListView = false;
  NetworkNode? _selectedNode;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mode = ref.watch(referralNetworkViewModeProvider);
    final depth = ref.watch(referralNetworkDepthProvider);

    final asyncMembers = mode == ReferralNetworkViewMode.downline
        ? ref.watch(referralDownlineProvider(depth))
        : ref.watch(referralUplineProvider(depth));

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header with Mode Tabs & View Switcher
          NetworkTreeHeader(
            isListView: _isListView,
            onToggleView: () => setState(() => _isListView = !_isListView),
          ),

          // 2. Main Content
          SizedBox(
            height: 480,
            child: widget.data != null && widget.profile == null
                ? _buildDirectNodeView(widget.data!)
                : asyncMembers.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    error: (err, _) => ErrorState(
                      message: ApiError.toUserFriendlyMessage(err),
                      onRetry: () {
                        if (mode == ReferralNetworkViewMode.downline) {
                          ref.invalidate(referralDownlineProvider(depth));
                        } else {
                          ref.invalidate(referralUplineProvider(depth));
                        }
                      },
                    ),
                    data: (members) {
                      if (members.isEmpty) {
                        return _buildEmptyState(mode, depth, isDark);
                      }
                      return _isListView
                          ? _buildListView(members)
                          : _buildTreeView(members, mode);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeView(
    List<ReferralNetworkMember> members,
    ReferralNetworkViewMode mode,
  ) {
    final user = ref.watch(currentUserProvider);
    final userDisplayName = user?.name.trim().isNotEmpty == true
        ? user!.name.trim()
        : 'You';
    final rootName = (widget.profile?.alias.trim().isNotEmpty == true &&
            widget.profile?.alias.trim() != 'Chima Obi')
        ? widget.profile!.alias.trim()
        : userDisplayName;

    final rootNode = NetworkTreeBuilder.buildTree(
      rootName: rootName,
      members: members,
      isDownline: mode == ReferralNetworkViewMode.downline,
    );
    return _buildDirectNodeView(rootNode);
  }

  Widget _buildDirectNodeView(NetworkNode root) {
    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(120),
      minScale: 0.5,
      maxScale: 2.5,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: TreeNodeWidget(
          node: root,
          anonymize: widget.anonymize,
          selectedNodeId: _selectedNode?.id,
          onNodeTap: (node) => setState(() => _selectedNode = node),
        ),
      ),
    );
  }

  Widget _buildListView(List<ReferralNetworkMember> members) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: members.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) => NetworkMemberTile(member: members[i]),
    );
  }

  Widget _buildEmptyState(
    ReferralNetworkViewMode mode,
    int depth,
    bool isDark,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_outline,
              size: 48,
              color: isDark ? Colors.white38 : Colors.grey.shade400,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'No ${mode.displayName.toLowerCase()} at depth $depth',
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
