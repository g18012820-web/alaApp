// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i21;
import 'package:flutter/material.dart' as _i22;
import 'package:flutter_bloc_template/ui/course/page/course_detail/course_detail_page.dart'
    as _i1;
import 'package:flutter_bloc_template/ui/course/page/course_list/course_list_page.dart'
    as _i2;
import 'package:flutter_bloc_template/ui/course/page/lesson_video_player/lesson_video_player_page.dart'
    as _i8;
import 'package:flutter_bloc_template/ui/home/home_page.dart' as _i5;
import 'package:flutter_bloc_template/ui/home/page/home_search/home_search_page.dart'
    as _i6;
import 'package:flutter_bloc_template/ui/inbox/inbox_page.dart' as _i7;
import 'package:flutter_bloc_template/ui/let_in/let_in_page.dart' as _i9;
import 'package:flutter_bloc_template/ui/login/login_page.dart' as _i10;
import 'package:flutter_bloc_template/ui/main/main_page.dart' as _i11;
import 'package:flutter_bloc_template/ui/my_course/my_course_page.dart' as _i12;
import 'package:flutter_bloc_template/ui/onboarding/onboarding_page.dart'
    as _i13;
import 'package:flutter_bloc_template/ui/profile/pages/edit_profile/edit_profile_page.dart'
    as _i3;
import 'package:flutter_bloc_template/ui/profile/pages/help_center/help_center_page.dart'
    as _i4;
import 'package:flutter_bloc_template/ui/profile/pages/setting_language/setting_language_page.dart'
    as _i15;
import 'package:flutter_bloc_template/ui/profile/pages/setting_notification/setting_notification_page.dart'
    as _i16;
import 'package:flutter_bloc_template/ui/profile/pages/setting_payment/setting_payment_page.dart'
    as _i17;
import 'package:flutter_bloc_template/ui/profile/profile_page.dart' as _i14;
import 'package:flutter_bloc_template/ui/sign_up/sign_up_page.dart' as _i18;
import 'package:flutter_bloc_template/ui/owner/dashboard/owner_dashboard_page.dart'
    as _i23;
import 'package:flutter_bloc_template/ui/owner/subjects/owner_subjects_page.dart'
    as _i24;
import 'package:flutter_bloc_template/ui/owner/courses/owner_courses_page.dart'
    as _i25;
import 'package:flutter_bloc_template/ui/owner/lessons/owner_lessons_page.dart'
    as _i26;
import 'package:flutter_bloc_template/ui/owner/students/owner_students_page.dart'
    as _i27;
import 'package:flutter_bloc_template/ui/owner/teachers/owner_teachers_page.dart'
    as _i28;
import 'package:flutter_bloc_template/ui/owner/settings/owner_credentials_page.dart'
    as _i29;
import 'package:flutter_bloc_template/ui/activate_account/activate_account_page.dart'
    as _i30;
import 'package:flutter_bloc_template/ui/owner/settings/owner_registration_settings_page.dart'
    as _i31;
import 'package:flutter_bloc_template/ui/wallet/wallet_page.dart' as _i32;
import 'package:flutter_bloc_template/ui/wallet/top_up_request_page.dart'
    as _i33;
import 'package:flutter_bloc_template/ui/wallet/redeem_code_page.dart'
    as _i34;
import 'package:flutter_bloc_template/ui/owner/wallet/owner_charging_page.dart'
    as _i35;
import 'package:flutter_bloc_template/ui/owner/wallet/owner_codes_page.dart'
    as _i36;
import 'package:flutter_bloc_template/ui/favorites/favorites_page.dart'
    as _i37;
import 'package:flutter_bloc_template/ui/owner/quizzes/owner_quizzes_page.dart'
    as _i38;
import 'package:flutter_bloc_template/ui/owner/quizzes/owner_quiz_questions_page.dart'
    as _i39;
import 'package:flutter_bloc_template/ui/quiz/quiz_taking_page.dart' as _i40;
import 'package:flutter_bloc_template/ui/quiz/student_quiz_list_page.dart'
    as _i41;
import 'package:flutter_bloc_template/ui/static_info/static_info_page.dart'
    as _i42;
import 'package:flutter_bloc_template/ui/browse/student_subjects_page.dart'
    as _i43;
import 'package:flutter_bloc_template/ui/browse/student_subject_courses_page.dart'
    as _i44;
import 'package:flutter_bloc_template/ui/splash/splash_page.dart' as _i19;
import 'package:flutter_bloc_template/ui/transaction/transaction_page.dart'
    as _i20;

/// generated route for
/// [_i1.CourseDetailPage]
class CourseDetailRoute extends _i21.PageRouteInfo<CourseDetailRouteArgs> {
  CourseDetailRoute({
    _i22.Key? key,
    required String id,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          CourseDetailRoute.name,
          args: CourseDetailRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'CourseDetailRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CourseDetailRouteArgs>(
          orElse: () => CourseDetailRouteArgs(id: pathParams.getString('id')));
      return _i1.CourseDetailPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class CourseDetailRouteArgs {
  const CourseDetailRouteArgs({
    this.key,
    required this.id,
  });

  final _i22.Key? key;

  final String id;

  @override
  String toString() {
    return 'CourseDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i2.CourseListPage]
class CourseListRoute extends _i21.PageRouteInfo<void> {
  const CourseListRoute({List<_i21.PageRouteInfo>? children})
      : super(
          CourseListRoute.name,
          initialChildren: children,
        );

  static const String name = 'CourseListRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i2.CourseListPage();
    },
  );
}

/// generated route for
/// [_i3.EditProfilePage]
class EditProfileRoute extends _i21.PageRouteInfo<void> {
  const EditProfileRoute({List<_i21.PageRouteInfo>? children})
      : super(
          EditProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'EditProfileRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i3.EditProfilePage();
    },
  );
}

/// generated route for
/// [_i4.HelpCenterPage]
class HelpCenterRoute extends _i21.PageRouteInfo<void> {
  const HelpCenterRoute({List<_i21.PageRouteInfo>? children})
      : super(
          HelpCenterRoute.name,
          initialChildren: children,
        );

  static const String name = 'HelpCenterRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i4.HelpCenterPage();
    },
  );
}

/// generated route for
/// [_i5.HomePage]
class HomeRoute extends _i21.PageRouteInfo<void> {
  const HomeRoute({List<_i21.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i5.HomePage();
    },
  );
}

/// generated route for
/// [_i6.HomeSearchPage]
class HomeSearchRoute extends _i21.PageRouteInfo<void> {
  const HomeSearchRoute({List<_i21.PageRouteInfo>? children})
      : super(
          HomeSearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeSearchRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i6.HomeSearchPage();
    },
  );
}

/// generated route for
/// [_i7.InboxPage]
class InboxRoute extends _i21.PageRouteInfo<void> {
  const InboxRoute({List<_i21.PageRouteInfo>? children})
      : super(
          InboxRoute.name,
          initialChildren: children,
        );

  static const String name = 'InboxRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i7.InboxPage();
    },
  );
}

/// generated route for
/// [_i8.LessonVideoPlayerPage]
class LessonVideoPlayerRoute
    extends _i21.PageRouteInfo<LessonVideoPlayerRouteArgs> {
  LessonVideoPlayerRoute({
    _i22.Key? key,
    required String videoUrl,
    String? title,
    String? lessonId,
    String? watermarkText,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          LessonVideoPlayerRoute.name,
          args: LessonVideoPlayerRouteArgs(
            key: key,
            videoUrl: videoUrl,
            title: title,
            lessonId: lessonId,
            watermarkText: watermarkText,
          ),
          initialChildren: children,
        );

  static const String name = 'LessonVideoPlayerRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LessonVideoPlayerRouteArgs>();
      return _i8.LessonVideoPlayerPage(
        key: args.key,
        videoUrl: args.videoUrl,
        title: args.title,
        lessonId: args.lessonId,
        watermarkText: args.watermarkText,
      );
    },
  );
}

class LessonVideoPlayerRouteArgs {
  const LessonVideoPlayerRouteArgs({
    this.key,
    required this.videoUrl,
    this.title,
    this.lessonId,
    this.watermarkText,
  });

  final _i22.Key? key;

  final String videoUrl;

  final String? title;

  final String? lessonId;

  final String? watermarkText;

  @override
  String toString() {
    return 'LessonVideoPlayerRouteArgs{key: $key, videoUrl: $videoUrl, title: $title, lessonId: $lessonId, watermarkText: $watermarkText}';
  }
}

/// generated route for
/// [_i23.OwnerDashboardPage]
class OwnerDashboardRoute extends _i21.PageRouteInfo<void> {
  const OwnerDashboardRoute({List<_i21.PageRouteInfo>? children})
      : super(
          OwnerDashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'OwnerDashboardRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i23.OwnerDashboardPage();
    },
  );
}

/// generated route for
/// [_i24.OwnerSubjectsPage]
class OwnerSubjectsRoute extends _i21.PageRouteInfo<void> {
  const OwnerSubjectsRoute({List<_i21.PageRouteInfo>? children})
      : super(
          OwnerSubjectsRoute.name,
          initialChildren: children,
        );

  static const String name = 'OwnerSubjectsRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i24.OwnerSubjectsPage();
    },
  );
}

/// generated route for
/// [_i25.OwnerCoursesPage]
class OwnerCoursesRoute extends _i21.PageRouteInfo<OwnerCoursesRouteArgs> {
  OwnerCoursesRoute({
    _i22.Key? key,
    required String subjectId,
    required String subjectName,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          OwnerCoursesRoute.name,
          args: OwnerCoursesRouteArgs(
            key: key,
            subjectId: subjectId,
            subjectName: subjectName,
          ),
          initialChildren: children,
        );

  static const String name = 'OwnerCoursesRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OwnerCoursesRouteArgs>();
      return _i25.OwnerCoursesPage(
        key: args.key,
        subjectId: args.subjectId,
        subjectName: args.subjectName,
      );
    },
  );
}

class OwnerCoursesRouteArgs {
  const OwnerCoursesRouteArgs({
    this.key,
    required this.subjectId,
    required this.subjectName,
  });

  final _i22.Key? key;

  final String subjectId;

  final String subjectName;

  @override
  String toString() {
    return 'OwnerCoursesRouteArgs{key: $key, subjectId: $subjectId, subjectName: $subjectName}';
  }
}

/// generated route for
/// [_i26.OwnerLessonsPage]
class OwnerLessonsRoute extends _i21.PageRouteInfo<OwnerLessonsRouteArgs> {
  OwnerLessonsRoute({
    _i22.Key? key,
    required String courseId,
    required String courseName,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          OwnerLessonsRoute.name,
          args: OwnerLessonsRouteArgs(
            key: key,
            courseId: courseId,
            courseName: courseName,
          ),
          initialChildren: children,
        );

  static const String name = 'OwnerLessonsRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OwnerLessonsRouteArgs>();
      return _i26.OwnerLessonsPage(
        key: args.key,
        courseId: args.courseId,
        courseName: args.courseName,
      );
    },
  );
}

class OwnerLessonsRouteArgs {
  const OwnerLessonsRouteArgs({
    this.key,
    required this.courseId,
    required this.courseName,
  });

  final _i22.Key? key;

  final String courseId;

  final String courseName;

  @override
  String toString() {
    return 'OwnerLessonsRouteArgs{key: $key, courseId: $courseId, courseName: $courseName}';
  }
}

/// generated route for
/// [_i27.OwnerStudentsPage]
class OwnerStudentsRoute extends _i21.PageRouteInfo<void> {
  const OwnerStudentsRoute({List<_i21.PageRouteInfo>? children})
      : super(
          OwnerStudentsRoute.name,
          initialChildren: children,
        );

  static const String name = 'OwnerStudentsRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i27.OwnerStudentsPage();
    },
  );
}

/// generated route for
/// [_i28.OwnerTeachersPage]
class OwnerTeachersRoute extends _i21.PageRouteInfo<void> {
  const OwnerTeachersRoute({List<_i21.PageRouteInfo>? children})
      : super(
          OwnerTeachersRoute.name,
          initialChildren: children,
        );

  static const String name = 'OwnerTeachersRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i28.OwnerTeachersPage();
    },
  );
}

/// generated route for
/// [_i29.OwnerCredentialsPage]
class OwnerCredentialsRoute extends _i21.PageRouteInfo<void> {
  const OwnerCredentialsRoute({List<_i21.PageRouteInfo>? children})
      : super(
          OwnerCredentialsRoute.name,
          initialChildren: children,
        );

  static const String name = 'OwnerCredentialsRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i29.OwnerCredentialsPage();
    },
  );
}

/// generated route for
/// [_i30.ActivateAccountPage]
class ActivateAccountRoute extends _i21.PageRouteInfo<ActivateAccountRouteArgs> {
  ActivateAccountRoute({
    _i22.Key? key,
    required String email,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          ActivateAccountRoute.name,
          args: ActivateAccountRouteArgs(key: key, email: email),
          initialChildren: children,
        );

  static const String name = 'ActivateAccountRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ActivateAccountRouteArgs>();
      return _i30.ActivateAccountPage(key: args.key, email: args.email);
    },
  );
}

class ActivateAccountRouteArgs {
  const ActivateAccountRouteArgs({this.key, required this.email});

  final _i22.Key? key;

  final String email;

  @override
  String toString() {
    return 'ActivateAccountRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [_i31.OwnerRegistrationSettingsPage]
class OwnerRegistrationSettingsRoute extends _i21.PageRouteInfo<void> {
  const OwnerRegistrationSettingsRoute({List<_i21.PageRouteInfo>? children})
      : super(
          OwnerRegistrationSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'OwnerRegistrationSettingsRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i31.OwnerRegistrationSettingsPage();
    },
  );
}

/// generated route for
/// [_i32.WalletPage]
class WalletRoute extends _i21.PageRouteInfo<void> {
  const WalletRoute({List<_i21.PageRouteInfo>? children})
      : super(
          WalletRoute.name,
          initialChildren: children,
        );

  static const String name = 'WalletRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i32.WalletPage();
    },
  );
}

/// generated route for
/// [_i33.TopUpRequestPage]
class TopUpRequestRoute extends _i21.PageRouteInfo<TopUpRequestRouteArgs> {
  TopUpRequestRoute({
    _i22.Key? key,
    required String studentId,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          TopUpRequestRoute.name,
          args: TopUpRequestRouteArgs(key: key, studentId: studentId),
          initialChildren: children,
        );

  static const String name = 'TopUpRequestRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TopUpRequestRouteArgs>();
      return _i33.TopUpRequestPage(key: args.key, studentId: args.studentId);
    },
  );
}

class TopUpRequestRouteArgs {
  const TopUpRequestRouteArgs({this.key, required this.studentId});

  final _i22.Key? key;

  final String studentId;

  @override
  String toString() {
    return 'TopUpRequestRouteArgs{key: $key, studentId: $studentId}';
  }
}

/// generated route for
/// [_i34.RedeemCodePage]
class RedeemCodeRoute extends _i21.PageRouteInfo<RedeemCodeRouteArgs> {
  RedeemCodeRoute({
    _i22.Key? key,
    required String studentId,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          RedeemCodeRoute.name,
          args: RedeemCodeRouteArgs(key: key, studentId: studentId),
          initialChildren: children,
        );

  static const String name = 'RedeemCodeRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RedeemCodeRouteArgs>();
      return _i34.RedeemCodePage(key: args.key, studentId: args.studentId);
    },
  );
}

class RedeemCodeRouteArgs {
  const RedeemCodeRouteArgs({this.key, required this.studentId});

  final _i22.Key? key;

  final String studentId;

  @override
  String toString() {
    return 'RedeemCodeRouteArgs{key: $key, studentId: $studentId}';
  }
}

/// generated route for
/// [_i35.OwnerChargingPage]
class OwnerChargingRoute extends _i21.PageRouteInfo<void> {
  const OwnerChargingRoute({List<_i21.PageRouteInfo>? children})
      : super(
          OwnerChargingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OwnerChargingRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i35.OwnerChargingPage();
    },
  );
}

/// generated route for
/// [_i36.OwnerCodesPage]
class OwnerCodesRoute extends _i21.PageRouteInfo<void> {
  const OwnerCodesRoute({List<_i21.PageRouteInfo>? children})
      : super(
          OwnerCodesRoute.name,
          initialChildren: children,
        );

  static const String name = 'OwnerCodesRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i36.OwnerCodesPage();
    },
  );
}

/// generated route for
/// [_i37.FavoritesPage]
class FavoritesRoute extends _i21.PageRouteInfo<void> {
  const FavoritesRoute({List<_i21.PageRouteInfo>? children})
      : super(
          FavoritesRoute.name,
          initialChildren: children,
        );

  static const String name = 'FavoritesRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i37.FavoritesPage();
    },
  );
}

/// generated route for
/// [_i38.OwnerQuizzesPage]
class OwnerQuizzesRoute extends _i21.PageRouteInfo<OwnerQuizzesRouteArgs> {
  OwnerQuizzesRoute({
    _i22.Key? key,
    required String courseId,
    required String courseName,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          OwnerQuizzesRoute.name,
          args: OwnerQuizzesRouteArgs(key: key, courseId: courseId, courseName: courseName),
          initialChildren: children,
        );

  static const String name = 'OwnerQuizzesRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OwnerQuizzesRouteArgs>();
      return _i38.OwnerQuizzesPage(key: args.key, courseId: args.courseId, courseName: args.courseName);
    },
  );
}

class OwnerQuizzesRouteArgs {
  const OwnerQuizzesRouteArgs({this.key, required this.courseId, required this.courseName});

  final _i22.Key? key;

  final String courseId;

  final String courseName;

  @override
  String toString() {
    return 'OwnerQuizzesRouteArgs{key: $key, courseId: $courseId, courseName: $courseName}';
  }
}

/// generated route for
/// [_i39.OwnerQuizQuestionsPage]
class OwnerQuizQuestionsRoute extends _i21.PageRouteInfo<OwnerQuizQuestionsRouteArgs> {
  OwnerQuizQuestionsRoute({
    _i22.Key? key,
    required String courseId,
    required String quizId,
    required String quizTitle,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          OwnerQuizQuestionsRoute.name,
          args: OwnerQuizQuestionsRouteArgs(key: key, courseId: courseId, quizId: quizId, quizTitle: quizTitle),
          initialChildren: children,
        );

  static const String name = 'OwnerQuizQuestionsRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OwnerQuizQuestionsRouteArgs>();
      return _i39.OwnerQuizQuestionsPage(key: args.key, courseId: args.courseId, quizId: args.quizId, quizTitle: args.quizTitle);
    },
  );
}

class OwnerQuizQuestionsRouteArgs {
  const OwnerQuizQuestionsRouteArgs({this.key, required this.courseId, required this.quizId, required this.quizTitle});

  final _i22.Key? key;

  final String courseId;

  final String quizId;

  final String quizTitle;

  @override
  String toString() {
    return 'OwnerQuizQuestionsRouteArgs{key: $key, courseId: $courseId, quizId: $quizId, quizTitle: $quizTitle}';
  }
}

/// generated route for
/// [_i40.QuizTakingPage]
class QuizTakingRoute extends _i21.PageRouteInfo<QuizTakingRouteArgs> {
  QuizTakingRoute({
    _i22.Key? key,
    required String quizId,
    required String studentId,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          QuizTakingRoute.name,
          args: QuizTakingRouteArgs(key: key, quizId: quizId, studentId: studentId),
          initialChildren: children,
        );

  static const String name = 'QuizTakingRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QuizTakingRouteArgs>();
      return _i40.QuizTakingPage(key: args.key, quizId: args.quizId, studentId: args.studentId);
    },
  );
}

class QuizTakingRouteArgs {
  const QuizTakingRouteArgs({this.key, required this.quizId, required this.studentId});

  final _i22.Key? key;

  final String quizId;

  final String studentId;

  @override
  String toString() {
    return 'QuizTakingRouteArgs{key: $key, quizId: $quizId, studentId: $studentId}';
  }
}

/// generated route for
/// [_i41.StudentQuizListPage]
class StudentQuizListRoute extends _i21.PageRouteInfo<StudentQuizListRouteArgs> {
  StudentQuizListRoute({
    _i22.Key? key,
    required String courseId,
    required String courseName,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          StudentQuizListRoute.name,
          args: StudentQuizListRouteArgs(key: key, courseId: courseId, courseName: courseName),
          initialChildren: children,
        );

  static const String name = 'StudentQuizListRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StudentQuizListRouteArgs>();
      return _i41.StudentQuizListPage(key: args.key, courseId: args.courseId, courseName: args.courseName);
    },
  );
}

class StudentQuizListRouteArgs {
  const StudentQuizListRouteArgs({this.key, required this.courseId, required this.courseName});

  final _i22.Key? key;

  final String courseId;

  final String courseName;

  @override
  String toString() {
    return 'StudentQuizListRouteArgs{key: $key, courseId: $courseId, courseName: $courseName}';
  }
}

/// generated route for
/// [_i42.StaticInfoPage]
class StaticInfoRoute extends _i21.PageRouteInfo<StaticInfoRouteArgs> {
  StaticInfoRoute({
    _i22.Key? key,
    required String title,
    required String content,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          StaticInfoRoute.name,
          args: StaticInfoRouteArgs(key: key, title: title, content: content),
          initialChildren: children,
        );

  static const String name = 'StaticInfoRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StaticInfoRouteArgs>();
      return _i42.StaticInfoPage(key: args.key, title: args.title, content: args.content);
    },
  );
}

class StaticInfoRouteArgs {
  const StaticInfoRouteArgs({this.key, required this.title, required this.content});

  final _i22.Key? key;

  final String title;

  final String content;

  @override
  String toString() {
    return 'StaticInfoRouteArgs{key: $key, title: $title, content: $content}';
  }
}

/// generated route for
/// [_i43.StudentSubjectsPage]
class StudentSubjectsRoute extends _i21.PageRouteInfo<void> {
  const StudentSubjectsRoute({List<_i21.PageRouteInfo>? children})
      : super(
          StudentSubjectsRoute.name,
          initialChildren: children,
        );

  static const String name = 'StudentSubjectsRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i43.StudentSubjectsPage();
    },
  );
}

/// generated route for
/// [_i44.StudentSubjectCoursesPage]
class StudentSubjectCoursesRoute extends _i21.PageRouteInfo<StudentSubjectCoursesRouteArgs> {
  StudentSubjectCoursesRoute({
    _i22.Key? key,
    required String subjectId,
    required String subjectName,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          StudentSubjectCoursesRoute.name,
          args: StudentSubjectCoursesRouteArgs(key: key, subjectId: subjectId, subjectName: subjectName),
          initialChildren: children,
        );

  static const String name = 'StudentSubjectCoursesRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StudentSubjectCoursesRouteArgs>();
      return _i44.StudentSubjectCoursesPage(key: args.key, subjectId: args.subjectId, subjectName: args.subjectName);
    },
  );
}

class StudentSubjectCoursesRouteArgs {
  const StudentSubjectCoursesRouteArgs({this.key, required this.subjectId, required this.subjectName});

  final _i22.Key? key;

  final String subjectId;

  final String subjectName;

  @override
  String toString() {
    return 'StudentSubjectCoursesRouteArgs{key: $key, subjectId: $subjectId, subjectName: $subjectName}';
  }
}

/// generated route for
/// [_i9.LetInPage]
class LetInRoute extends _i21.PageRouteInfo<void> {
  const LetInRoute({List<_i21.PageRouteInfo>? children})
      : super(
          LetInRoute.name,
          initialChildren: children,
        );

  static const String name = 'LetInRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i9.LetInPage();
    },
  );
}

/// generated route for
/// [_i10.LoginPage]
class LoginRoute extends _i21.PageRouteInfo<void> {
  const LoginRoute({List<_i21.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i10.LoginPage();
    },
  );
}

/// generated route for
/// [_i11.MainPage]
class MainRoute extends _i21.PageRouteInfo<void> {
  const MainRoute({List<_i21.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i11.MainPage();
    },
  );
}

/// generated route for
/// [_i12.MyCoursePage]
class MyCourseRoute extends _i21.PageRouteInfo<void> {
  const MyCourseRoute({List<_i21.PageRouteInfo>? children})
      : super(
          MyCourseRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyCourseRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i12.MyCoursePage();
    },
  );
}

/// generated route for
/// [_i13.OnboardingPage]
class OnboardingRoute extends _i21.PageRouteInfo<void> {
  const OnboardingRoute({List<_i21.PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i13.OnboardingPage();
    },
  );
}

/// generated route for
/// [_i14.ProfilePage]
class ProfileRoute extends _i21.PageRouteInfo<void> {
  const ProfileRoute({List<_i21.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i14.ProfilePage();
    },
  );
}

/// generated route for
/// [_i15.SettingLanguagePage]
class SettingLanguageRoute extends _i21.PageRouteInfo<void> {
  const SettingLanguageRoute({List<_i21.PageRouteInfo>? children})
      : super(
          SettingLanguageRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingLanguageRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i15.SettingLanguagePage();
    },
  );
}

/// generated route for
/// [_i16.SettingNotificationPage]
class SettingNotificationRoute extends _i21.PageRouteInfo<void> {
  const SettingNotificationRoute({List<_i21.PageRouteInfo>? children})
      : super(
          SettingNotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingNotificationRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i16.SettingNotificationPage();
    },
  );
}

/// generated route for
/// [_i17.SettingPaymentPage]
class SettingPaymentRoute extends _i21.PageRouteInfo<void> {
  const SettingPaymentRoute({List<_i21.PageRouteInfo>? children})
      : super(
          SettingPaymentRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingPaymentRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i17.SettingPaymentPage();
    },
  );
}

/// generated route for
/// [_i18.SignUpPage]
class SignUpRoute extends _i21.PageRouteInfo<void> {
  const SignUpRoute({List<_i21.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i18.SignUpPage();
    },
  );
}

/// generated route for
/// [_i19.SplashPage]
class SplashRoute extends _i21.PageRouteInfo<void> {
  const SplashRoute({List<_i21.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i19.SplashPage();
    },
  );
}

/// generated route for
/// [_i20.TransactionPage]
class TransactionRoute extends _i21.PageRouteInfo<void> {
  const TransactionRoute({List<_i21.PageRouteInfo>? children})
      : super(
          TransactionRoute.name,
          initialChildren: children,
        );

  static const String name = 'TransactionRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i20.TransactionPage();
    },
  );
}
