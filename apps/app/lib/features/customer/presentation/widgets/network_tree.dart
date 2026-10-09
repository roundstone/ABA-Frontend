import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class NetworkNode {
  final String id;
  final String name;
  final String? alias;
  final String code;
  final int level;
  final int sales;
  final int personalSales;
  final bool active;
  final DateTime? joinedDate;
  final int? performancePercentile;
  final List<NetworkNode> children;

  NetworkNode({
    required this.id,
    required this.name,
    this.alias,
    required this.code,
    required this.level,
    required this.sales,
    required this.personalSales,
    required this.active,
    this.joinedDate,
    this.performancePercentile,
    this.children = const [],
  });
}

class NetworkTreeWidget extends StatefulWidget {
  final NetworkNode data;
  final bool anonymize;

  const NetworkTreeWidget({
    super.key,
    required this.data,
    this.anonymize = false,
  });

  @override
  State<NetworkTreeWidget> createState() => _NetworkTreeWidgetState();
}

class _NetworkTreeWidgetState extends State<NetworkTreeWidget> {
  bool _isListView = false;
  NetworkNode? _selectedNode;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 600,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        children: [
          // Header Controls
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLG)),
              border: Border(bottom: BorderSide(color: isDark ? Colors.white12 : AppColors.border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () => setState(() => _isListView = !_isListView),
                  icon: Icon(_isListView ? Icons.account_tree_outlined : Icons.list, color: isDark ? Colors.white : Colors.black),
                  label: Text(_isListView ? 'Tree View' : 'List View', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: Size.zero,
                    side: BorderSide(color: isDark ? Colors.white24 : AppColors.border),
                  ),
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _isListView
                      ? _buildListView()
                      : InteractiveViewer(
                          constrained: false,
                          boundaryMargin: const EdgeInsets.all(double.infinity),
                          minScale: 0.5,
                          maxScale: 3.0,
                          child: Padding(
                            padding: const EdgeInsets.all(48.0),
                            child: _TreeNodeWidget(
                              node: widget.data,
                              anonymize: widget.anonymize,
                              selectedNodeId: _selectedNode?.id,
                              onNodeTap: (node) => setState(() => _selectedNode = node),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    final nodes = _flattenNodes(widget.data);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerStyle = TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87);
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: isDark ? Colors.white12 : Colors.black12,
          ),
          child: DataTable(
            showCheckboxColumn: false,
            headingTextStyle: headerStyle,
            columns: [
              DataColumn(label: Text('Member', style: headerStyle)),
              DataColumn(label: Text('Level', style: headerStyle)),
              DataColumn(label: Text('Sales (Team)', style: headerStyle)),
              DataColumn(label: Text('Status', style: headerStyle)),
            ],
          rows: nodes.map((node) {
            final displayName = widget.anonymize ? (node.alias ?? 'User ${node.code.substring(node.code.length - 4)}') : node.name;
            return DataRow(
              selected: _selectedNode?.id == node.id,
              onSelectChanged: (_) => setState(() => _selectedNode = node),
              cells: [
                DataCell(Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(node.level.toString())),
                DataCell(Text('₦${NumberFormat('#,##0').format(node.sales / 100)}')),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: node.active ? AppColors.success.withValues(alpha: 0.2) : AppColors.error.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      node.active ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 12,
                        color: node.active ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
          ),
        ),
      ),
    );
  }

  List<NetworkNode> _flattenNodes(NetworkNode node) {
    return [node, ...node.children.expand(_flattenNodes)];
  }
}

class _TreeNodeWidget extends StatefulWidget {
  final NetworkNode node;
  final bool anonymize;
  final String? selectedNodeId;
  final ValueChanged<NetworkNode> onNodeTap;

  const _TreeNodeWidget({
    required this.node,
    required this.anonymize,
    required this.selectedNodeId,
    required this.onNodeTap,
  });

  @override
  State<_TreeNodeWidget> createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends State<_TreeNodeWidget> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final displayName = widget.anonymize ? (widget.node.alias ?? 'User ${widget.node.code.substring(widget.node.code.length - 4)}') : widget.node.name;
    final int percentile = widget.node.performancePercentile ?? 0;
    
    double size = 40;
    Color bgColor = Colors.grey.shade50;
    Color borderColor = Colors.grey.shade300;
    
    if (percentile > 80) {
      size = 64;
      bgColor = AppColors.primary.withValues(alpha: 0.1);
      borderColor = AppColors.primary;
    } else if (percentile > 50) {
      size = 48;
      bgColor = Colors.blue.shade50;
      borderColor = Colors.blue.shade400;
    }

    final isSelected = widget.selectedNodeId == widget.node.id;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => widget.onNodeTap(widget.node),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.primary : borderColor,
                        width: isSelected ? 4 : 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        displayName.isNotEmpty ? displayName[0] : '?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                          fontSize: size * 0.4,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: widget.node.active ? AppColors.success : AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 80,
                child: Text(
                  displayName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        if (widget.node.children.isNotEmpty) ...[
          const SizedBox(height: 4),
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Text(
                _expanded ? '- ${widget.node.children.length}' : '+ ${widget.node.children.length}',
                style: const TextStyle(fontSize: 10, color: Colors.black87),
              ),
            ),
          ),
          if (_expanded) ...[
            Container(
              width: 1,
              height: 16,
              color: Colors.grey.shade400,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.node.children.map((child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 1,
                        height: 16,
                        color: Colors.grey.shade400,
                      ),
                      _TreeNodeWidget(
                        node: child,
                        anonymize: widget.anonymize,
                        selectedNodeId: widget.selectedNodeId,
                        onNodeTap: widget.onNodeTap,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ],
    );
  }
}
