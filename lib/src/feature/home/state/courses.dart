import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class CoursesStore extends PaginatedListStore<OnlineSchoolCourse> {
  CoursesStore({
    required super.apiClient,
    required super.fetchFunction,
    required super.faker,
  }) : super(
          testDataGenerator: () {
            return OnlineSchoolCourse(
              id: faker.datatype.uuid(),
              title: faker.lorem.word(),
              onlineSchoolId: faker.datatype.uuid(),
              shortDescription: faker.lorem.paragraph(sentenceCount: 2),
            );
          },
          basePath: Endpoint().schoolCourses,
          transformer: (raw) {
            final data = List.from(raw['list'] ?? [])
                .map((e) => OnlineSchoolCourse.fromJson(e))
                .toList();

            // return data;

            return {
              'main': data,
            };
          },
        );
}
