
import 'package:flutter_bloc_template/base/bloc/base_bloc/base_bloc.dart';
import 'package:flutter_bloc_template/ui/course/page/course_list/bloc/course_list_event.dart';
import 'package:flutter_bloc_template/ui/course/page/course_list/bloc/course_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class CourseListBloc extends BaseBloc<CourseListEvent, CourseListState> {
  CourseListBloc() : super(CourseListState());
}