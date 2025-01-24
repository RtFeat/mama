import 'package:mama/src/data.dart';

class CoursesStore extends PaginatedListStore<OnlineSchoolCourse> {
  CoursesStore({
    required super.restClient,
    required super.fetchFunction,
  }) : super(
          basePath: Endpoint().schoolCourses,
          transformer: (raw) {
            final data = List.from(raw['list'] ?? [])
                .map((e) => OnlineSchoolCourse.fromJson(e))
                .toList();

            return data;
          },
        );
}
