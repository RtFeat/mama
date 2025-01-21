import 'package:mama/src/data.dart';

class CoursesStore extends PaginatedListStore<OnlineSchoolCourse> {
  CoursesStore({
    required super.fetchFunction,
  }) : super(
          transformer: (raw) {
            final data = List.from(raw['list'] ?? [])
                .map((e) => OnlineSchoolCourse.fromJson(e))
                .toList();

            return data;
          },
        );
}
