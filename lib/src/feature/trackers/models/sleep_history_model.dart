class HistoryOfTrackingSleepCry {
  final DateTime begin;
  final DateTime end;

  HistoryOfTrackingSleepCry({
    required this.begin,
    required this.end,
  });
}

class DetailTimeSleepCry {
  final String begin;
  final String end;
  final String time;

  DetailTimeSleepCry({
    required this.begin,
    required this.end,
    required this.time,
  });
}

class SleepCryModel {
  final String date;
  final List<DetailTimeSleepCry> listOfData;

  SleepCryModel({
    required this.date,
    required this.listOfData,
  });
}
