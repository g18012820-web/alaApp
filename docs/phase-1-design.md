# وثيقة تصميم المرحلة 1 — الأساس
### (مبنية على: «منصة تعليمية – مواصفات احترافية»، القسم 21: خارطة الطريق)

النطاق: هيكلة **المواد/الدورات/الحصص** + **نظام المستخدمين (مالك/طالب)** + **المصادقة الموحّدة**.

---

## 1. نموذج قاعدة البيانات (Phase 1)

### 1.1 users
| الحقل | النوع | ملاحظات |
|---|---|---|
| id | UUID (PK) | |
| role | ENUM('owner','student') | مالك واحد فقط في كامل النظام |
| full_name | VARCHAR | |
| email | VARCHAR (unique) | |
| phone_number | VARCHAR | |
| state | VARCHAR | الولاية (حقل من نموذج التسجيل §12.2) |
| password_hash | VARCHAR | bcrypt/argon2 |
| avatar_url | VARCHAR | nullable |
| is_active | BOOLEAN | يُستخدم مع كود تفعيل الحساب §12.3 |
| activation_required | BOOLEAN | يُحسب وقت الإنشاء حسب حالة الإعداد العام لحظة التسجيل (قاعدة الرجعية الزمنية) |
| created_at | TIMESTAMP | |
| blocked_at | TIMESTAMP | nullable — تمهيدًا للمرحلة 4 |

> ⚠️ حساب المالك: **لا يُنشأ عبر شاشة تسجيل** — يُزرع (seed) مرة واحدة عند أول تشغيل للخادم عبر متغيرات بيئة (`OWNER_EMAIL`, `OWNER_PASSWORD`) أو أمر CLI تفاعلي. هذا يمنع وجود أكثر من مالك ويمنع تسريب بيانات اعتماد ثابتة في الكود.

### 1.2 subjects (المواد)
`id, name, description, image_url, color_hex, created_by(owner_id), created_at`

### 1.3 courses (الدورات)
`id, subject_id(FK), title, about, cover_image, price, original_price, certificate(bool), status ENUM('sale_active','sale_stopped','registration_blocked','hidden','archived','deleted'), created_at`

### 1.4 lessons (الحصص)
`id, course_id(FK), title, type ENUM('video','pdf_file','image','text_article','quiz','downloadable_file'), video_url, duration, order, is_free, is_locked, scheduled_at, created_at`

### 1.5 enrollments (ربط الطالب بالدورة — أساس لمراحل المحفظة/الأكواد لاحقًا)
`id, student_id(FK), course_id(FK), enrolled_at, source ENUM('purchase','code','manual')`

---

## 2. نقاط النهاية (REST API) — المرحلة 1

### مصادقة
```
POST /auth/login          { email, password } → { token, user{role,...} }
POST /auth/register       { fullName, phoneNumber, state, email, password } → طالب جديد فقط
POST /auth/activate       { code }             → تفعيل الحساب (إن كانت الميزة مفعّلة)
GET  /auth/me
```
آلية `/auth/login` تطبّق **الدخول الموحّد الذكي (§12.1)**: نفس الـ endpoint يُعيد `role` ضمن الاستجابة، والتطبيق يوجّه المستخدم تلقائيًا حسب القيمة (owner → لوحة التحكم، student → الواجهة العادية) دون أي منطق تفريق في الخادم بين "نوعي تسجيل دخول".

### المواد
```
GET    /subjects
POST   /subjects          (owner only)
PUT    /subjects/:id      (owner only)
DELETE /subjects/:id      (owner only)
```

### الدورات
```
GET    /subjects/:id/courses
GET    /courses/:id
POST   /courses           (owner only)
PUT    /courses/:id       (owner only)
PATCH  /courses/:id/status(owner only)  { status }
```

### الحصص
```
GET    /courses/:id/lessons
POST   /courses/:id/lessons   (owner only)
PUT    /lessons/:id           (owner only)
DELETE /lessons/:id           (owner only)
```

كل مسارات `(owner only)` محمية بـ middleware يتحقق من `role == owner` بعد فك تشفير الـ JWT، ويُعيد `403` غير ذلك.

---

## 3. ما تم تنفيذه فعليًا في هذا المشروع (Flutter) ضمن هذا الرد

- ✅ العربية أصبحت اللغة الافتراضية للتطبيق مع دعم اتجاه RTL كامل (`lib/main.dart`, ملفات `l10n`).
- ✅ إضافة `UserRole` (owner/student) وربطها بـ `UserEntity` الموجود مسبقًا (الحقل `role` كان جاهزًا).
- ✅ توسعة `CourseEntity` بحقول: `subjectId`, `lessonsCount`, `status (CourseStatus)`, `coverImage`.
- ✅ توسعة `LessonEntity` + `LessonResponseDto` بحقول: `type (LessonType)`, `order`, `isLocked`, `scheduledAt`.
- ✅ توسعة `CategoryEntity` (تمثّل "المادة/Subject") و`MentorEntity` (تمثّل "الأستاذ") بحقول وصفية إضافية.
- كل التعديلات **متوافقة رجوعيًا** (backward-compatible): لم يتم حذف أو كسر أي حقل قديم، فقط إضافات اختيارية بقيم افتراضية، حتى لا ينكسر أي كود موجود في التطبيق التجريبي الحالي.

## 4. ما لم يتم تنفيذه بعد (ينتظر خادمًا فعليًا)

✅ **تحديث:** شاشات لوحة تحكم المالك لإدارة المواد/الدورات/الحصص (إضافة/تعديل/حذف) **أُنجزت الآن** — راجع `docs/owner-dashboard-screens.md` للتفاصيل. المتبقي أدناه لا يزال قائمًا:

هذا المستودع تطبيق **Flutter وحده** ويتصل حاليًا بـ API وهمي تجريبي (mock). لا يوجد خادم/قاعدة بيانات حقيقية في هذه البيئة، لذلك:
- منطق التحويل التلقائي owner/student في شاشة الدخول (`login_bloc`) لم يُفعَّل بعد.
- **"حساب المالك"**: لا يمكن تسليم بيانات دخول فعلية تعمل بدون خادم حقيقي مستضاف وقاعدة بيانات. بمجرد بناء الـ Backend (المرحلة القادمة)، ستُنشئ أنت حساب المالك بنفسك عبر أمر seed لمرة واحدة (موضّح في القسم 1.1 أعلاه) لضمان أن كلمة المرور لا تمر عبر طرف ثالث.

---
*المرحلة التالية المقترحة (2): تكامل مشغل الفيديو الموحّد + شاشات لوحة المالك لإدارة المواد/الدورات/الحصص.*
