import 'package:faker_dart/faker_dart.dart' as faker;
import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'doctor.g.dart';

@JsonSerializable()
class DoctorModel extends BaseModel {
  final String? id;

  @JsonKey(name: 'account_id')
  final String? accountId;

  final AccountModel? account;

  @JsonKey(name: 'is_consultation')
  final bool isConsultation;

  @JsonKey(name: 'profession')
  final String? profession;

  @JsonKey(name: 'first_name')
  final String? firstName;

  @JsonKey(name: 'last_name')
  final String? lastName;

  @JsonKey(name: 'time_work')
  final DoctorWorkTime? workTime;

  @JsonKey(name: 'count_articles')
  final int? countArticles;

  String get fullName =>
      '$firstName ${lastName != null && lastName!.isNotEmpty ? lastName : ''}';

  DoctorModel({
    this.id,
    this.account,
    this.accountId,
    this.isConsultation = false,
    this.profession,
    super.updatedAt,
    this.countArticles,
    this.firstName,
    this.lastName,
    super.createdAt,
    this.workTime,
  });

  factory DoctorModel.mock(faker.Faker faker) {
    return DoctorModel(
        id: faker.datatype.uuid(),
        accountId: faker.datatype.uuid(),
        profession: faker.name.jobTitle(),
        countArticles: faker.datatype.number(),
        firstName: faker.name.firstName(),
        lastName: faker.name.lastName(),
        createdAt: faker.date.past(DateTime.now()),
        workTime: DoctorWorkTime(
          id: faker.datatype.uuid(),
          monday: WeekDay(
              title: 'monday',
              workSlots: ObservableList.of(
                List.generate(
                    faker.datatype.number(max: 10),
                    (index) => WorkSlot(
                        consultationId: faker.datatype.uuid(),
                        patientFullName: faker.name.fullName(),
                        workSlot: faker.date
                            .future(DateTime.now())
                            .timeRange(faker.date.future(DateTime.now())))),
              )),
          tuesday: WeekDay(
              title: 'tuesday',
              workSlots: ObservableList.of(
                List.generate(
                    faker.datatype.number(max: 10),
                    (index) => WorkSlot(
                        consultationId: faker.datatype.uuid(),
                        patientFullName: faker.name.fullName(),
                        workSlot: faker.date
                            .future(DateTime.now())
                            .timeRange(faker.date.future(DateTime.now())))),
              )),
          wednesday: WeekDay(
              title: 'wednesday',
              workSlots: ObservableList.of(
                List.generate(
                    faker.datatype.number(max: 10),
                    (index) => WorkSlot(
                        consultationId: faker.datatype.uuid(),
                        patientFullName: faker.name.fullName(),
                        workSlot: faker.date
                            .future(DateTime.now())
                            .timeRange(faker.date.future(DateTime.now())))),
              )),
          thursday: WeekDay(
              title: 'thursday',
              workSlots: ObservableList.of(
                List.generate(
                    faker.datatype.number(max: 10),
                    (index) => WorkSlot(
                        consultationId: faker.datatype.uuid(),
                        patientFullName: faker.name.fullName(),
                        workSlot: faker.date
                            .future(DateTime.now())
                            .timeRange(faker.date.future(DateTime.now())))),
              )),
          friday: WeekDay(
              title: 'friday',
              workSlots: ObservableList.of(
                List.generate(
                    faker.datatype.number(max: 10),
                    (index) => WorkSlot(
                        consultationId: faker.datatype.uuid(),
                        patientFullName: faker.name.fullName(),
                        workSlot: faker.date
                            .future(DateTime.now())
                            .timeRange(faker.date.future(DateTime.now())))),
              )),
          saturday: WeekDay(
              title: 'saturday',
              workSlots: ObservableList.of(
                List.generate(
                    faker.datatype.number(max: 10),
                    (index) => WorkSlot(
                        consultationId: faker.datatype.uuid(),
                        patientFullName: faker.name.fullName(),
                        workSlot: faker.date
                            .future(DateTime.now())
                            .timeRange(faker.date.future(DateTime.now())))),
              )),
          sunday: WeekDay(
              title: 'sunday',
              workSlots: ObservableList.of(
                List.generate(
                    faker.datatype.number(max: 10),
                    (index) => WorkSlot(
                        consultationId: faker.datatype.uuid(),
                        patientFullName: faker.name.fullName(),
                        workSlot: faker.date
                            .future(DateTime.now())
                            .timeRange(faker.date.future(DateTime.now())))),
              )),
        ),
        account: AccountModel(
          id: faker.datatype.uuid(),
          firstName: faker.name.firstName(),
          secondName: faker.name.lastName(),
          avatarUrl: faker.image.image(),
          gender: Gender
              .values[faker.datatype.number(max: Gender.values.length - 1)],
          phone: faker.phoneNumber.phoneNumber(),
        ));
  }

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
}
