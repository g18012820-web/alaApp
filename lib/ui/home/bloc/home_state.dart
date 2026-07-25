import 'package:flutter_bloc_template/base/bloc/base_bloc/base_state.dart';
import 'package:flutter_bloc_template/domain/entity/course/category_entity.dart';
import 'package:flutter_bloc_template/domain/entity/course/course_entity.dart';
import 'package:flutter_bloc_template/domain/entity/course/mentor_entity.dart';
import 'package:flutter_bloc_template/domain/entity/course/promote_entity.dart';

final class HomeState extends BaseState {
  final List<PromoteEntity> promotes;
  final List<CourseEntity> courses;
  final List<MentorEntity> mentors;
  final List<CategoryEntity> categories;
  final String categoryId;

  HomeState({
    this.promotes = const [],
    this.courses = const [],
    this.mentors = const [],
    this.categories = const [],
    required this.categoryId,
  });

  HomeState copyWith({
    List<PromoteEntity>? promotes,
    List<CourseEntity>? courses,
    List<MentorEntity>? mentors,
    List<CategoryEntity>? categories,
    String? categoryId,
  }) {
    return HomeState(
      promotes: promotes ?? this.promotes,
      courses: courses ?? this.courses,
      mentors: mentors ?? this.mentors,
      categories: categories ?? this.categories,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  List<Object?> get props => [
        promotes,
        courses,
        mentors,
        categories,
        categoryId,
      ];
}
