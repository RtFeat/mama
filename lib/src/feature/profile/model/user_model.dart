import 'package:faker_dart/faker_dart.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends BaseModel {
  @JsonKey(includeToJson: false)
  final String? id;

  @JsonKey(name: 'account_id', includeToJson: false)
  final String? accountId;

  @JsonKey()
  final String? city;

  @JsonKey(name: 'created_id', includeToJson: false)
  final String? createdId;

  @JsonKey(name: 'end_prime', includeToJson: false)
  final String? endPrime;

  @JsonKey(includeToJson: false)
  final List<String?>? roles;

  @JsonKey(name: 'start_prime', includeToJson: false)
  final String? startPrime;

  @JsonKey(name: 'type_prime', includeToJson: false)
  final String? typePrime;

  @JsonKey(name: 'updated_id', includeToJson: false)
  final String? updatedId;

  UserModel(
      {required this.accountId,
      required this.city,
      required this.createdId,
      required this.endPrime,
      required this.id,
      required this.roles,
      required this.startPrime,
      required this.typePrime,
      required this.updatedId});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Connect the generated [_$UserModelFromJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.mock(Faker faker) {
    return UserModel(
      accountId: faker.datatype.uuid(),
      city: faker.address.city(),
      createdId: faker.datatype.uuid(),
      endPrime: faker.datatype.string(),
      id: faker.datatype.uuid(),
      roles: [faker.datatype.string()],
      startPrime: faker.datatype.string(),
      typePrime: faker.datatype.string(),
      updatedId: faker.datatype.uuid(),
    );
  }

  @override
  String toString() {
    return 'UserModel{accountId: $accountId, city: $city, createdAt: $createdId, endPrime: $endPrime, id: $id, roles: $roles, startPrime: $startPrime, typePrime: $typePrime, updatedId: $updatedId}';
  }
}
