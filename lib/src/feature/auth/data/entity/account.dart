import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'account.g.dart';

@JsonSerializable()
class AccountModel extends _AccountModel with _$AccountModel {
  @JsonKey(name: 'id', includeIfNull: false)
  String? id;

  @JsonKey(name: 'fcm_token')
  String fcmToken;

  Gender gender;

  @JsonKey(includeToJson: false)
  final Role? role;

  @JsonKey(includeToJson: false)
  final Status? status;

  AccountModel({
    this.fcmToken = '',
    required this.gender,
    required super.firstName,
    required super.secondName,
    required super.phone,
    super.avatarUrl,
    super.email,
    super.info,
    this.id,
    super.profession,
    this.role,
    this.status,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountModel &&
          id == other.id &&
          fcmToken == other.fcmToken &&
          gender == other.gender &&
          role == other.role &&
          status == other.status &&
          runtimeType == other.runtimeType &&
          firstName == other.firstName &&
          secondName == other.secondName &&
          phone == other.phone &&
          avatarUrl == other.avatarUrl &&
          email == other.email &&
          profession == other.profession &&
          info == other.info;

  @override
  int get hashCode =>
      id.hashCode ^
      fcmToken.hashCode ^
      gender.hashCode ^
      role.hashCode ^
      status.hashCode ^
      firstName.hashCode ^
      secondName.hashCode ^
      phone.hashCode ^
      avatarUrl.hashCode ^
      email.hashCode ^
      profession.hashCode ^
      info.hashCode;
}

abstract class _AccountModel extends BaseModel with Store {
  _AccountModel({
    required this.firstName,
    required this.secondName,
    required this.phone,
    this.avatarUrl,
    this.email,
    this.profession,
    this.info,
  });

  @observable
  @JsonKey(name: 'first_name')
  String firstName = '';

  @action
  void setFirstName(String value) {
    firstName = value;
    isChanged = true;
  }

  @observable
  @JsonKey(name: 'second_name')
  String? secondName;

  @action
  void setSecondName(String? value) {
    secondName = value;
    isChanged = true;
  }

  @computed
  String get name => '$firstName ${secondName != null ? secondName! : ''}';

  @observable
  @JsonKey(name: 'profession', includeIfNull: false, includeToJson: false)
  String? profession = '';

  @action
  void setProfession(String value) {
    profession = value;
    isChanged = true;
  }

  @observable
  @JsonKey(name: 'phone')
  String phone = '';

  @action
  void setPhone(String value) {
    phone = value;
    isChanged = true;
  }

  @observable
  @JsonKey(name: 'avatar', includeIfNull: false, includeToJson: false)
  String? avatarUrl;

  @action
  void setAvatar(String value) {
    avatarUrl = value;
  }

  @observable
  @JsonKey(name: 'email', includeIfNull: false)
  String? email;

  @action
  void setEmail(String value) {
    email = value;
    isChanged = true;
  }

  @observable
  @JsonKey(
    name: 'info',
  )
  String? info;

  @action
  void setInfo(String? value) {
    info = value;
    isChanged = true;
  }

  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isChanged = false;

  @action
  void setIsChanged(bool value) {
    isChanged = value;
  }
}

enum Role {
  @JsonValue('ADMIN')
  admin,

  @JsonValue('USER')
  user,
  @JsonValue('MODERATOR')
  moderator,

  @JsonValue('DOCTOR')
  doctor,

  @JsonValue('ONLINE_SCHOOL')
  onlineSchool
}

enum Status {
  @JsonValue('SUBSCRIBED')
  subscribed,

  @JsonValue('NO_SUBSCRIBED')
  noSubscribe,

  @JsonValue('TRIAL')
  trial,

  @JsonValue('DELETED')
  deleted,

  @JsonValue('PROMO_CODE')
  promoCode,
}
