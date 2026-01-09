import 'package:intl/intl.dart';

enum FeeStatus {
  paid,
  pending,
  overdue,
  partiallyPaid
}

enum FeeType {
  tuition,
  transport,
  examination,
  stationary,
  uniform,
  library,
  other
}

class FeeModel {
  final String id;
  final String childId;
  final double amount;
  final double paidAmount;
  final DateTime dueDate;
  final FeeStatus status;
  final FeeType type;
  final String title;
  final String? description;
  final DateTime? paymentDate;
  final String? transactionId;
  final String? invoiceUrl;

  FeeModel({
    required this.id,
    required this.childId,
    required this.amount,
    this.paidAmount = 0.0,
    required this.dueDate,
    required this.status,
    required this.type,
    required this.title,
    this.description,
    this.paymentDate,
    this.transactionId,
    this.invoiceUrl,
  });

  double get remainingAmount => amount - paidAmount;

  String get formattedDueDate => DateFormat('MMM dd, yyyy').format(dueDate);
  String get formattedPaymentDate => paymentDate != null ? DateFormat('MMM dd, yyyy').format(paymentDate!) : 'N/A';

  factory FeeModel.fromJson(Map<String, dynamic> json) {
    return FeeModel(
      id: json['id'],
      childId: json['childId'],
      amount: (json['amount'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
      dueDate: DateTime.parse(json['dueDate']),
      status: FeeStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => FeeStatus.pending,
      ),
      type: FeeType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => FeeType.other,
      ),
      title: json['title'],
      description: json['description'],
      paymentDate: json['paymentDate'] != null ? DateTime.parse(json['paymentDate']) : null,
      transactionId: json['transactionId'],
      invoiceUrl: json['invoiceUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'childId': childId,
      'amount': amount,
      'paidAmount': paidAmount,
      'dueDate': dueDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'type': type.toString().split('.').last,
      'title': title,
      'description': description,
      'paymentDate': paymentDate?.toIso8601String(),
      'transactionId': transactionId,
      'invoiceUrl': invoiceUrl,
    };
  }
}
