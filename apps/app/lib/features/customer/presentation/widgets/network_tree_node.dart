import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

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

class TreeNodeWidget extends StatefulWidget {
  final NetworkNode node;
  final bool anonymize;
  final String? selectedNodeId;
  final ValueChanged<NetworkNode> onNodeTap;

  const TreeNodeWidget({
    super.key,
    required this.node,
    required this.anonymize,
    required this.selectedNodeId,
    required this.onNodeTap,
  });

  @override
  State<TreeNodeWidget> createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends State<TreeNodeWidget> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final displayName = widget.anonymize
        ? (widget.node.alias ?? 'User ${widget.node.code}')
        : widget.node.name;
    final isSelected = widget.selectedNodeId == widget.node.id;

    Color levelColor = AppColors.primary;
    if (widget.node.level == 2) levelColor = const Color(0xFFC28B38);
    if (widget.node.level >= 3) levelColor = Colors.indigo;

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
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: levelColor.withAlpha(25),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.primary : levelColor,
                        width: isSelected ? 3 : 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: levelColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: widget.node.active
                          ? AppColors.success
                          : AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 90,
                child: Text(
                  displayName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
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
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _expanded
                    ? '- ${widget.node.children.length}'
                    : '+ ${widget.node.children.length}',
                style: const TextStyle(fontSize: 10, color: Colors.black87),
              ),
            ),
          ),
          if (_expanded) ...[
            Container(width: 1, height: 14, color: Colors.grey.shade400),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.node.children.map((child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 1,
                        height: 14,
                        color: Colors.grey.shade400,
                      ),
                      TreeNodeWidget(
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
