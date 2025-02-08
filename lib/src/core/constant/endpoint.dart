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

  static const String categories = 'category';

  String get ageCaterories => '$categories/age';

  String get authorCaterories => '$article/$categories/writer';

  static const String consultation = 'consultation';

  String get userConsultations => '$consultation/user';

  String get addConsultation => '$consultation/set';

  static const String school = 'online-school';

  String get schools => '$school/all';

  String get schoolCourses => '$school/course/all';

  static const String article = 'article';

  String get articles => '$article/list';

  String get favoriteArticles => '$article/favorite';

  String get allByCategory => '$article/category/all';

  String get articleOwn => '$article/file/own';

  String get articlesForMe => '$article/for_you';

  String get articleToggleFavorite => '$article/favorite';

  static const String chat = 'chat';

  String get uploadFile => '$chat/upload';

  String get groups => '$chat/group';

  String get groupUsers => '${groups}s/all';

  String get messages => '$chat/message';

  static const String doctor = 'doctor';

  String get doctorData => '$doctor/me';

  String get doctorHoliday => '$doctor/holiday';

  String get doctorCancelConsultations => '$doctor/cancel_consultations';

  String get updateDoctorWorkTime => '$doctor/update_work_time';

  static const String avatar = 'resources/avatar';

  static const String feedback = 'feedback';

  static const String music = 'music/descriptions';

  static const String sleepCry = 'sleep_cry';

  String get sleepCryTable => '$sleepCry/table';
  static const String health = 'health';

  static const String medicine = 'health/drug';
  static const String doctorVisit = 'health/doctorVisit';
  static const String vaccine = 'health/vaccine';

  String get drug => '$health/drug';
}
