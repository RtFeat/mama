class VaccineItem {
  final String vaccineName;
  final String recommendedAge;
  final String? recommendedAgeSubtitle;
  final bool isDone;
  final String? date;

  VaccineItem({
    required this.vaccineName,
    required this.recommendedAge,
    this.recommendedAgeSubtitle,
    this.isDone = false,
    this.date,
  });
}
