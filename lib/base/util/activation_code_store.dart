import 'dart:math';

/// يولّد ويتحقق من رموز تفعيل الحساب (راجع "🔐 تفعيل الحساب").
///
/// ⚠️ هذا **تنفيذ تجريبي بحت للعرض المحلي فقط**: الرمز يُخزَّن في الذاكرة
/// ويُعرض مباشرة على الشاشة بعد التسجيل بدل إرساله فعليًا عبر SMS/بريد
/// إلكتروني، لأن ذلك يتطلب خدمة خارجية حقيقية (Twilio, Firebase, بوابة SMS
/// جزائرية...) لا تتوفر بدون خادم. عند بناء الخادم، يُستبدل هذا كليًا بإرسال
/// حقيقي وتحقق من جانب الخادم.
abstract final class ActivationCodeStore {
  ActivationCodeStore._();

  static final Map<String, String> _codesByEmail = {};

  static String generate(String email) {
    final code = (100000 + Random().nextInt(900000)).toString();
    _codesByEmail[email.trim().toLowerCase()] = code;
    return code;
  }

  static bool verify(String email, String code) {
    final expected = _codesByEmail[email.trim().toLowerCase()];
    return expected != null && expected == code.trim();
  }
}
