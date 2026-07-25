import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/data/repository/owner/owner_content_repository.dart';
import 'package:flutter_bloc_template/data/repository/wallet/wallet_repository.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

/// شاشة "💰 شحن الرصيد": اختيار الطريقة (CCP/بريدي موب)، إدخال القيمة، رفع
/// صورة التحويل، ثم إرسال الطلب لانتظار موافقة المالك.
@RoutePage()
class TopUpRequestPage extends StatefulWidget {
  final String studentId;

  const TopUpRequestPage({super.key, required this.studentId});

  @override
  State<TopUpRequestPage> createState() => _TopUpRequestPageState();
}

class _TopUpRequestPageState extends State<TopUpRequestPage> {
  final _amountController = TextEditingController();
  TopUpMethod _method = TopUpMethod.ccp;
  File? _receiptImage;

  Future<void> _pickReceipt() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) setState(() => _receiptImage = File(picked.path));
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أدخل قيمة صحيحة')));
      return;
    }
    if (_receiptImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء رفع صورة إيصال التحويل')));
      return;
    }
    final student = OwnerContentRepository.instance.students.where((s) => s.id == widget.studentId);
    final studentName = student.isNotEmpty ? student.first.fullName : 'طالب';

    WalletRepository.instance.submitTopUpRequest(
      studentId: widget.studentId,
      studentName: studentName,
      amount: amount,
      method: _method,
      receiptImagePath: _receiptImage!.path,
    );
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال طلب الشحن، بانتظار موافقة المالك')));
    AutoRouter.of(context).back();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: CommonAppBar(text: 'شحن الرصيد'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('طريقة الدفع', style: AppTextStyles.bodyLargeBold),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('CCP'),
                    selected: _method == TopUpMethod.ccp,
                    onSelected: (_) => setState(() => _method = TopUpMethod.ccp),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('بريدي موب'),
                    selected: _method == TopUpMethod.baridiMob,
                    onSelected: (_) => setState(() => _method = TopUpMethod.baridiMob),
                  ),
                ),
              ],
            ),
            const Gap(20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'قيمة الشحن (د.ج)', border: OutlineInputBorder()),
            ),
            const Gap(20),
            Text('صورة إيصال التحويل', style: AppTextStyles.bodyLargeBold),
            const Gap(10),
            InkWell(
              onTap: _pickReceipt,
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all(color: AppColors.current.greyscale200), borderRadius: BorderRadius.circular(14)),
                child: _receiptImage == null
                    ? const Center(child: Icon(Icons.add_a_photo_outlined, size: 32))
                    : ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.file(_receiptImage!, fit: BoxFit.cover)),
              ),
            ),
            const Gap(24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.current.primary500, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: _submit,
                child: Text('إرسال الطلب', style: AppTextStyles.bodyLargeBold.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
