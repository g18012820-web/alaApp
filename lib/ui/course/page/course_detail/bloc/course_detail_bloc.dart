import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/base/bloc/base_bloc/base_bloc.dart';
import 'package:flutter_bloc_template/base/util/current_student_session.dart';
import 'package:flutter_bloc_template/data/repository/favorites/favorites_store.dart';
import 'package:flutter_bloc_template/data/repository/owner/owner_content_repository.dart';
import 'package:flutter_bloc_template/domain/entity/course/course_entity.dart';
import 'package:flutter_bloc_template/domain/entity/enum/enum.dart';
import 'package:flutter_bloc_template/domain/use_case/course/fetch_course_detail_use_case.dart';
import 'package:flutter_bloc_template/ui/course/page/course_detail/bloc/course_detail_event.dart';
import 'package:flutter_bloc_template/ui/course/page/course_detail/bloc/course_detail_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../../domain/use_case/course/fetch_lesson_list_from_course_id_use_case.dart';
import '../../../../../domain/use_case/course/fetch_review_list_from_course_id_use_case.dart';
import '../../../../../domain/use_case/course/toggle_favourite_course_use_case.dart';

@injectable
final class CourseDetailBloc extends BaseBloc<CourseDetailEvent, CourseDetailState> {
  CourseDetailBloc(
    this._fetchCourseDetailUseCase,
    this._fetchLessonListFromCourseIdUseCase,
    this._fetchReviewListFromCourseIdUseCase,
    this._toggleFavouriteCourseUseCase,
  ) : super(CourseDetailState(
          course: CourseEntity.defaultValue(),
          tab: CourseTab.about,
        )) {
    on<FetchCourseDetailEvent>(_onFetchCourseDetailEvent);
    on<CourseTabChangedEvent>(_onCourseTabChangedEvent);
    on<ToggleFavoriteCourseEvent>(_onToggleFavoriteCourseEvent);
  }

  final FetchCourseDetailUseCase _fetchCourseDetailUseCase;
  final FetchLessonListFromCourseIdUseCase _fetchLessonListFromCourseIdUseCase;
  final FetchReviewListFromCourseIdUseCase _fetchReviewListFromCourseIdUseCase;
  final ToggleFavouriteCourseUseCase _toggleFavouriteCourseUseCase;

  FutureOr<void> _onFetchCourseDetailEvent(FetchCourseDetailEvent event, Emitter<CourseDetailState> emit) {
    // ربط مع دورات المالك الحقيقية: إن وُجدت دورة بهذا المعرّف في
    // OwnerContentRepository (أُنشئت من لوحة المالك) نعرضها مباشرة، بدل
    // انتظار API الوهمي الذي لا يعرف عنها شيئًا. راجع docs/full-integration.md
    final ownerCourse = _findOwnerCourse(event.courseId);
    if (ownerCourse != null) {
      return runAction(onAction: () async => emit(state.copyWith(course: ownerCourse)));
    }
    return runAction(
      onAction: () async {
        final result = await _fetchCourseDetailUseCase.invoke(CourseDetailRequest(id: event.courseId));
        result.when(
          ok: (data) {
            emit(state.copyWith(course: data));
          },
        );
      },
    );
  }

  CourseEntity? _findOwnerCourse(String courseId) {
    for (final subject in OwnerContentRepository.instance.subjects) {
      for (final course in OwnerContentRepository.instance.coursesOf(subject.id)) {
        if (course.id == courseId) return course;
      }
    }
    return null;
  }

  FutureOr<void> _onCourseTabChangedEvent(CourseTabChangedEvent event, Emitter<CourseDetailState> emit) {
    switch (event.tab) {
      case CourseTab.about:
        return null;
      case CourseTab.lessons:
        return _fetchLesson(emit: emit);
      case CourseTab.reviews:
        return _fetchReview(emit: emit);
    }
  }

  Future<void> _fetchLesson({required Emitter<CourseDetailState> emit}) async {
    if (state.lessons.isNotEmpty) return;
    final ownerLessons = OwnerContentRepository.instance.lessonsOf(state.course.id);
    if (ownerLessons.isNotEmpty) {
      emit(state.copyWith(lessons: ownerLessons, tab: CourseTab.lessons));
      return;
    }
    return runAction(
      onAction: () async {
        final result = await _fetchLessonListFromCourseIdUseCase.invoke(state.course.id);
        result.when(
          ok: (data) {
            emit(state.copyWith(lessons: data, tab: CourseTab.lessons));
          },
        );
      },
    );
  }

  Future<void> _fetchReview({required Emitter<CourseDetailState> emit}) async {
    if (state.reviews.isNotEmpty) return;
    return runAction(
      onAction: () async {
        final result = await _fetchReviewListFromCourseIdUseCase.invoke(state.course.id);
        result.when(
          ok: (data) {
            emit(state.copyWith(reviews: data, tab: CourseTab.reviews));
          },
        );
      },
    );
  }

  FutureOr<void> _onToggleFavoriteCourseEvent(ToggleFavoriteCourseEvent event, Emitter<CourseDetailState> emit) async {
    final studentId = await CurrentStudentSession.getCurrentStudentId();
    if (studentId != null) {
      FavoritesStore.instance.toggle(studentId, state.course.id);
    }
    _toggleFavouriteCourseUseCase.invoke(ToggleFavouriteCourseInput(id: state.course.id, isFav: false));
  }
}
