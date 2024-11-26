class Endpoint {
  static const String auth = 'auth';

  String get accessToken => '$auth/access-token';

  String get logout => '$auth/log-out';

  String get login => '$auth/sign-in';

  String get register => '$auth/sign-up';

  String get sendCode => '$auth/send-phone-code';

  static const String geo = 'geo';

  String get cities => '$geo/city';

  String get countries => '$geo/country';

  static const String user = 'user';

  String get userData => '$user/me';

  static const String account = 'account';

  String get accountAvatar => '$account/avatar';

  static const String child = 'child';

  String get childAvatar => '$child/avatar';

  static const String payment = 'payment';

  String get promocode => '$payment/promocode';

  static const String consultation = 'consultation';

  String get userConsultations => '$consultation/user';

  static const String school = 'online-school';

  String get schools => '$school/all';

  static const String article = 'article';

  String get articles => '$article/list';

  String get articleOwn => '$article/file/own';

  String get articlesForMe => '$article/for_you';

  String get addArticleToFavorite => '$article/favorite';

  static const String chat = 'chat';

  String get groups => '$chat/group';

  String get groupUsers => '${groups}s/all';

  String get messages => '$chat/message';

  static const String doctor = 'doctor';

  String get doctorData => '$doctor/me';

  String get updateDoctorWorkTime => '$doctor/update_work_time';

  static const String avatar = 'resources/avatar';

  static const String feedback = 'feedback';
}
