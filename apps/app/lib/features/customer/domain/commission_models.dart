import 'package:flutter/material.dart';

class CommissionOverview {
  const CommissionOverview({
    required this.generatedPeriod,
    required this.pendingApproval,
    required this.approvedUnpaid,
    required this.paidPeriod,
    required this.reversedPeriod,
    required this.outstandingLiability,
  });

  final double generatedPeriod;
  final double pendingApproval;
  final double approvedUnpaid;
  final double paidPeriod;
  final double reversedPeriod;
  final double outstandingLiability;

  factory CommissionOverview.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    double parseNum(dynamic val) {
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    return CommissionOverview(
      generatedPeriod: parseNum(data['generatedPeriod']),
      pendingApproval: parseNum(data['pendingApproval']),
      approvedUnpaid: parseNum(data['approvedUnpaid']),
      paidPeriod: parseNum(data['paidPeriod']),
      reversedPeriod: parseNum(data['reversedPeriod']),
      outstandingLiability: parseNum(data['outstandingLiability']),
    );
  }

  static const empty = CommissionOverview(
    generatedPeriod: 0.0,
    pendingApproval: 0.0,
    approvedUnpaid: 0.0,
    paidPeriod: 0.0,
    reversedPeriod: 0.0,
    outstandingLiability: 0.0,
  );
}

class CommissionRuleInfo {
  const CommissionRuleInfo({
    required this.id,
    required this.title,
    this.merchantId,
  });

  final int id;
  final String title;
  final int? merchantId;

  factory CommissionRuleInfo.fromJson(Map<String, dynamic> json) {
    return CommissionRuleInfo(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      merchantId: json['merchantId'] is int
          ? json['merchantId'] as int
          : int.tryParse(json['merchantId']?.toString() ?? ''),
    );
  }
}

class CommissionRecord {
  const CommissionRecord({
    required this.id,
    required this.userId,
    this.commissionRuleId,
    this.sourceType = 'order',
    this.sourceId,
    this.commissionLevel = 1,
    this.calculationBase = 0.0,
    this.appliedRate,
    this.appliedFixedAmount,
    required this.amount,
    this.currency = 'NGN',
    required this.status,
    this.eligibleAt,
    this.releasedAt,
    this.commissionRule,
    this.sourceOrderNumber,
    this.sourceCustomerName,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int userId;
  final int? commissionRuleId;
  final String sourceType;
  final int? sourceId;
  final int commissionLevel;
  final double calculationBase;
  final double? appliedRate;
  final double? appliedFixedAmount;
  final double amount;
  final String currency;
  final int status; // 1: Pending, 2: Approved, 3: Paid, 4: Reversed
  final DateTime? eligibleAt;
  final DateTime? releasedAt;
  final CommissionRuleInfo? commissionRule;
  final String? sourceOrderNumber;
  final String? sourceCustomerName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get statusName {
    switch (status) {
      case 1:
        return 'Pending Approval';
      case 2:
        return 'Approved';
      case 3:
        return 'Paid';
      case 4:
        return 'Reversed';
      default:
        return 'Status $status';
    }
  }

  Color get statusColor {
    switch (status) {
      case 1:
        return const Color(0xFFF59E0B); // Amber
      case 2:
        return const Color(0xFF3B82F6); // Blue
      case 3:
        return const Color(0xFF10B981); // Emerald / Green
      case 4:
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280);
    }
  }

  factory CommissionRecord.fromJson(Map<String, dynamic> json) {
    double parseNum(dynamic val) {
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      return DateTime.tryParse(val.toString());
    }

    final ruleJson = json['commissionRule'];

    return CommissionRecord(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      userId: json['user_id'] is int
          ? json['user_id'] as int
          : int.tryParse(json['user_id']?.toString() ?? '') ?? 0,
      commissionRuleId: json['commission_rule_id'] is int
          ? json['commission_rule_id'] as int
          : int.tryParse(json['commission_rule_id']?.toString() ?? ''),
      sourceType: json['source_type']?.toString() ?? 'order',
      sourceId: json['source_id'] is int
          ? json['source_id'] as int
          : int.tryParse(json['source_id']?.toString() ?? ''),
      commissionLevel: json['commission_level'] is int
          ? json['commission_level'] as int
          : int.tryParse(json['commission_level']?.toString() ?? '') ?? 1,
      calculationBase: parseNum(json['calculation_base']),
      appliedRate: json['applied_rate'] != null ? parseNum(json['applied_rate']) : null,
      appliedFixedAmount:
          json['applied_fixed_amount'] != null ? parseNum(json['applied_fixed_amount']) : null,
      amount: parseNum(json['amount']),
      currency: json['currency']?.toString() ?? 'NGN',
      status: json['status'] is int
          ? json['status'] as int
          : int.tryParse(json['status']?.toString() ?? '') ?? 1,
      eligibleAt: parseDate(json['eligible_at']),
      releasedAt: parseDate(json['released_at']),
      commissionRule: ruleJson is Map<String, dynamic>
          ? CommissionRuleInfo.fromJson(ruleJson)
          : null,
      sourceOrderNumber: json['sourceOrderNumber']?.toString(),
      sourceCustomerName: json['sourceCustomerName']?.toString(),
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }
}

class PaginatedCommissions {
  const PaginatedCommissions({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.hasNext,
  });

  final List<CommissionRecord> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final bool hasNext;

  static const empty = PaginatedCommissions(
    items: [],
    totalItems: 0,
    totalPages: 1,
    currentPage: 1,
    hasNext: false,
  );
}

