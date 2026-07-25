// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hello`
  String get greeting {
    return Intl.message(
      'Hello',
      name: 'greeting',
      desc: '',
      args: [],
    );
  }

  /// `We provide the best learning courses & great mentors!`
  String get onboarding_1_title {
    return Intl.message(
      'We provide the best learning courses & great mentors!',
      name: 'onboarding_1_title',
      desc: '',
      args: [],
    );
  }

  /// `Learn anytime and anywhere easily and conveniently`
  String get onboarding_2_title {
    return Intl.message(
      'Learn anytime and anywhere easily and conveniently',
      name: 'onboarding_2_title',
      desc: '',
      args: [],
    );
  }

  /// `Let's improve your skills together with Elera right now!`
  String get onboarding_3_title {
    return Intl.message(
      'Let\'s improve your skills together with Elera right now!',
      name: 'onboarding_3_title',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get get_started {
    return Intl.message(
      'Get Started',
      name: 'get_started',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Let's you in`
  String get lets_you_in {
    return Intl.message(
      'Let\'s you in',
      name: 'lets_you_in',
      desc: '',
      args: [],
    );
  }

  /// `Google`
  String get google {
    return Intl.message(
      'Google',
      name: 'google',
      desc: '',
      args: [],
    );
  }

  /// `Facebook`
  String get facebook {
    return Intl.message(
      'Facebook',
      name: 'facebook',
      desc: '',
      args: [],
    );
  }

  /// `Apple`
  String get apple {
    return Intl.message(
      'Apple',
      name: 'apple',
      desc: '',
      args: [],
    );
  }

  /// `Continue with {name}`
  String continue_with(Object name) {
    return Intl.message(
      'Continue with $name',
      name: 'continue_with',
      desc: '',
      args: [name],
    );
  }

  /// `Or`
  String get or {
    return Intl.message(
      'Or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with password`
  String get sign_in_with_password {
    return Intl.message(
      'Sign in with password',
      name: 'sign_in_with_password',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dont_have_an_account {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dont_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get sign_up {
    return Intl.message(
      'Sign up',
      name: 'sign_up',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get sign_in {
    return Intl.message(
      'Sign in',
      name: 'sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get already_have_an_account {
    return Intl.message(
      'Already have an account?',
      name: 'already_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `or continue with`
  String get or_continue_with {
    return Intl.message(
      'or continue with',
      name: 'or_continue_with',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Remember me`
  String get remember_me {
    return Intl.message(
      'Remember me',
      name: 'remember_me',
      desc: '',
      args: [],
    );
  }

  /// `Forgot the password?`
  String get forgot_the_password {
    return Intl.message(
      'Forgot the password?',
      name: 'forgot_the_password',
      desc: '',
      args: [],
    );
  }

  /// `Create your\nAccount`
  String get create_ur_account {
    return Intl.message(
      'Create your\nAccount',
      name: 'create_ur_account',
      desc: '',
      args: [],
    );
  }

  /// `Login to your\nAccount`
  String get login_to_ur_account {
    return Intl.message(
      'Login to your\nAccount',
      name: 'login_to_ur_account',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `My Course`
  String get my_course {
    return Intl.message(
      'My Course',
      name: 'my_course',
      desc: '',
      args: [],
    );
  }

  /// `Inbox`
  String get inbox {
    return Intl.message(
      'Inbox',
      name: 'inbox',
      desc: '',
      args: [],
    );
  }

  /// `Transaction`
  String get transaction {
    return Intl.message(
      'Transaction',
      name: 'transaction',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Collapse`
  String get collapse {
    return Intl.message(
      'Collapse',
      name: 'collapse',
      desc: '',
      args: [],
    );
  }

  /// `Read more`
  String get read_more {
    return Intl.message(
      'Read more',
      name: 'read_more',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get edit_profile {
    return Intl.message(
      'Edit Profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Owner Dashboard`
  String get owner_dashboard {
    return Intl.message('Owner Dashboard', name: 'owner_dashboard', desc: '', args: []);
  }

  /// `Owner`
  String get owner {
    return Intl.message('Owner', name: 'owner', desc: '', args: []);
  }

  /// `Student`
  String get student {
    return Intl.message('Student', name: 'student', desc: '', args: []);
  }

  /// `Teacher`
  String get teacher {
    return Intl.message('Teacher', name: 'teacher', desc: '', args: []);
  }

  /// `Subjects`
  String get subjects {
    return Intl.message('Subjects', name: 'subjects', desc: '', args: []);
  }

  /// `Courses`
  String get courses {
    return Intl.message('Courses', name: 'courses', desc: '', args: []);
  }

  /// `Lessons`
  String get lessons {
    return Intl.message('Lessons', name: 'lessons', desc: '', args: []);
  }

  /// `Wallet`
  String get wallet {
    return Intl.message('Wallet', name: 'wallet', desc: '', args: []);
  }

  /// `Balance`
  String get wallet_balance {
    return Intl.message('Balance', name: 'wallet_balance', desc: '', args: []);
  }

  /// `Activate Code`
  String get activate_code {
    return Intl.message('Activate Code', name: 'activate_code', desc: '', args: []);
  }

  /// `Enter activation code`
  String get enter_activation_code {
    return Intl.message('Enter activation code', name: 'enter_activation_code', desc: '', args: []);
  }

  /// `Activate Account`
  String get activate_account {
    return Intl.message('Activate Account', name: 'activate_account', desc: '', args: []);
  }

  /// `Add New`
  String get add_new {
    return Intl.message('Add New', name: 'add_new', desc: '', args: []);
  }

  /// `Manage Students`
  String get manage_students {
    return Intl.message('Manage Students', name: 'manage_students', desc: '', args: []);
  }

  /// `Manage Codes`
  String get manage_codes {
    return Intl.message('Manage Codes', name: 'manage_codes', desc: '', args: []);
  }

  /// `Manage Notifications`
  String get manage_notifications {
    return Intl.message('Manage Notifications', name: 'manage_notifications', desc: '', args: []);
  }

  /// `Course Program`
  String get course_program {
    return Intl.message('Course Program', name: 'course_program', desc: '', args: []);
  }

  /// `Quiz`
  String get quiz {
    return Intl.message('Quiz', name: 'quiz', desc: '', args: []);
  }

  /// `Full Name`
  String get full_name {
    return Intl.message('Full Name', name: 'full_name', desc: '', args: []);
  }

  /// `Phone Number`
  String get phone_number {
    return Intl.message('Phone Number', name: 'phone_number', desc: '', args: []);
  }

  /// `State`
  String get state {
    return Intl.message('State', name: 'state', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message('Confirm Password', name: 'confirm_password', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
