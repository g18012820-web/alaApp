import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_template/data/repository/owner/owner_content_repository.dart';

enum TopUpMethod { ccp, baridiMob }

enum TopUpStatus { pending, approved, rejected }

/// طلب شحن رصيد (راجع "💰 شحن الرصيد"). ينتظر موافقة المالك.
class TopUpRequest {
  final String id;
  final String studentId;
  final String studentName;
  final double amount;
  final TopUpMethod method;
  final String? receiptImagePath;
  TopUpStatus status;
  String? ownerNote;
  final DateTime createdAt;

  TopUpRequest({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.amount,
    required this.method,
    this.receiptImagePath,
    this.status = TopUpStatus.pending,
    this.ownerNote,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

enum WalletTransactionType { topUp, purchase, codeRedeem, ownerAdjustment }

/// سجل حركة محفظة واحد (للعرض في "💳 المحفظة → آخر العمليات").
class WalletTransaction {
  final String id;
  final String studentId;
  final WalletTransactionType type;
  final double amount; // موجب = إضافة، سالب = خصم
  final String note;
  final DateTime createdAt;

  WalletTransaction({
    required this.id,
    required this.studentId,
    required this.type,
    required this.amount,
    required this.note,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

enum CodeType { balance, course, lesson, accountActivation }

/// كود قابل للاستخدام مرة واحدة (راجع "🎟️ الأكواد").
class RedemptionCode {
  final String code;
  final CodeType type;

  /// المبلغ (لكود الرصيد) أو معرّف الدورة/الحصة (لكود الدورة/الحصة)
  final String value;
  bool isUsed;
  String? usedByStudentId;
  final DateTime createdAt;

  RedemptionCode({
    required this.code,
    required this.type,
    required this.value,
    this.isUsed = false,
    this.usedByStudentId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

/// نتيجة استخدام كود، لعرض رسالة نجاح/فشل واضحة للطالب.
class RedeemResult {
  final bool success;
  final String message;

  const RedeemResult(this.success, this.message);
}

/// مستودع المحفظة/الشحن/الأكواد — محلي في الذاكرة (لا خادم بعد). راجع
/// `docs/wallet-and-codes.md` لتفاصيل ما يحتاج خادمًا حقيقيًا لاحقًا.
class WalletRepository extends ChangeNotifier {
  WalletRepository._internal();

  static final WalletRepository instance = WalletRepository._internal();

  final List<TopUpRequest> _topUpRequests = [];
  final List<WalletTransaction> _transactions = [];
  final List<RedemptionCode> _codes = [];
  int _idCounter = 5000;

  String _newId() => (_idCounter++).toString();

  // ── شحن الرصيد ─────────────────────────────────────────
  List<TopUpRequest> get topUpRequests => List.unmodifiable(_topUpRequests.reversed);

  List<TopUpRequest> pendingTopUpRequests() => _topUpRequests.where((r) => r.status == TopUpStatus.pending).toList().reversed.toList();

  void submitTopUpRequest({required String studentId, required String studentName, required double amount, required TopUpMethod method, String? receiptImagePath}) {
    _topUpRequests.add(TopUpRequest(id: _newId(), studentId: studentId, studentName: studentName, amount: amount, method: method, receiptImagePath: receiptImagePath));
    notifyListeners();
  }

  void approveTopUp(String requestId) {
    final request = _topUpRequests.firstWhere((r) => r.id == requestId);
    if (request.status != TopUpStatus.pending) return;
    request.status = TopUpStatus.approved;
    OwnerContentRepository.instance.adjustStudentBalance(request.studentId, request.amount);
    _addTransaction(studentId: request.studentId, type: WalletTransactionType.topUp, amount: request.amount, note: 'شحن رصيد مقبول (${_methodLabel(request.method)})');
    notifyListeners();
  }

  void rejectTopUp(String requestId, {String? note}) {
    final request = _topUpRequests.firstWhere((r) => r.id == requestId);
    if (request.status != TopUpStatus.pending) return;
    request.status = TopUpStatus.rejected;
    request.ownerNote = note;
    notifyListeners();
  }

  String _methodLabel(TopUpMethod method) => method == TopUpMethod.ccp ? 'CCP' : 'بريدي موب';

  // ── سجل العمليات ───────────────────────────────────────
  List<WalletTransaction> transactionsOf(String studentId) => _transactions.where((t) => t.studentId == studentId).toList().reversed.toList();

  void _addTransaction({required String studentId, required WalletTransactionType type, required double amount, required String note}) {
    _transactions.add(WalletTransaction(id: _newId(), studentId: studentId, type: type, amount: amount, note: note));
  }

  // ── الشراء ──────────────────────────────────────────────
  /// يسجّل عملية شراء دورة بالمحفظة (يخصم من الرصيد ويضيف سطرًا في السجل).
  /// يُرجع `false` إن كان الرصيد غير كافٍ دون خصم أي شيء.
  bool purchaseWithBalance({required String studentId, required String courseId, required String courseTitle, required double price}) {
    final student = OwnerContentRepository.instance.students.where((s) => s.id == studentId);
    final balance = student.isNotEmpty ? student.first.walletBalance : 0.0;
    if (balance < price) return false;
    OwnerContentRepository.instance.adjustStudentBalance(studentId, -price);
    OwnerContentRepository.instance.enroll(studentId, courseId);
    _addTransaction(studentId: studentId, type: WalletTransactionType.purchase, amount: -price, note: 'شراء دورة: $courseTitle');
    notifyListeners();
    return true;
  }

  // ── الأكواد ─────────────────────────────────────────────
  List<RedemptionCode> get codes => List.unmodifiable(_codes.reversed);

  /// يولّد دفعة أكواد دفعة واحدة (راجع "إنشاء آلاف الأكواد" في لوحة المالك).
  List<RedemptionCode> generateCodes({required CodeType type, required String value, required int count}) {
    final generated = <RedemptionCode>[];
    for (var i = 0; i < count; i++) {
      final code = RedemptionCode(code: _randomCode(), type: type, value: value);
      _codes.add(code);
      generated.add(code);
    }
    notifyListeners();
    return generated;
  }

  void deleteCode(String code) {
    _codes.removeWhere((c) => c.code == code);
    notifyListeners();
  }

  String _randomCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rand = Random();
    return List.generate(10, (i) => i == 5 ? '-' : chars[rand.nextInt(chars.length)]).join().replaceAll('--', '-');
  }

  /// يستخدم الطالب كودًا؛ يُرجع نتيجة واضحة (نجاح/فشل) مع سبب الفشل.
  RedeemResult redeemCode({required String studentId, required String rawCode}) {
    final code = rawCode.trim().toUpperCase();
    final index = _codes.indexWhere((c) => c.code == code);
    if (index == -1) return const RedeemResult(false, 'هذا الكود غير موجود');
    final found = _codes[index];
    if (found.isUsed) return const RedeemResult(false, 'هذا الكود مستخدم مسبقًا');

    switch (found.type) {
      case CodeType.balance:
        final amount = double.tryParse(found.value) ?? 0;
        OwnerContentRepository.instance.adjustStudentBalance(studentId, amount);
        _addTransaction(studentId: studentId, type: WalletTransactionType.codeRedeem, amount: amount, note: 'تفعيل كود رصيد (${found.code})');
        found.isUsed = true;
        found.usedByStudentId = studentId;
        notifyListeners();
        return RedeemResult(true, 'تم إضافة $amount د.ج إلى محفظتك');
      case CodeType.course:
        found.isUsed = true;
        found.usedByStudentId = studentId;
        OwnerContentRepository.instance.enroll(studentId, found.value);
        notifyListeners();
        return const RedeemResult(true, 'تم فتح الدورة بنجاح');
      case CodeType.lesson:
        found.isUsed = true;
        found.usedByStudentId = studentId;
        notifyListeners();
        return const RedeemResult(true, 'تم فتح الحصة بنجاح');
      case CodeType.accountActivation:
        found.isUsed = true;
        found.usedByStudentId = studentId;
        notifyListeners();
        return const RedeemResult(true, 'تم تفعيل الحساب بنجاح');
    }
  }
}
