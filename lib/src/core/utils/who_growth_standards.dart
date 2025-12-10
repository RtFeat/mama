import 'package:mama/src/feature/trackers/widgets/fl_chart.dart';

/// WHO Growth Standards - simplified implementation
/// Based on WHO Child Growth Standards
class WHOGrowthStandards {
  /// Generate norm data for weight (in kg) based on age in days
  /// Gender: 'male' or 'female'
  static List<NormData> getWeightNorms({
    required int minAgeDays,
    required int maxAgeDays,
    required String gender,
  }) {
    final List<NormData> norms = [];
    
    // Sample every 30 days (monthly)
    for (int days = minAgeDays; days <= maxAgeDays; days += 30) {
      final months = days / 30.44; // Average days per month
      
      // Simplified WHO weight standards (median and SD)
      // These are approximate values - real WHO tables are more detailed
      double median;
      double sd;
      
      if (gender == 'male') {
        median = _getMaleWeightMedian(months);
        sd = _getMaleWeightSD(months);
      } else {
        median = _getFemaleWeightMedian(months);
        sd = _getFemaleWeightSD(months);
      }
      
      norms.add(NormData(
        x: days.toDouble(),
        median: median,
        sd1Lower: median - sd,
        sd1Upper: median + sd,
        sd2Lower: median - 2 * sd,
        sd2Upper: median + 2 * sd,
        sd3Lower: median - 3 * sd,
        sd3Upper: median + 3 * sd,
      ));
    }
    
    return norms;
  }
  
  // Simplified male weight median (kg) by age in months
  static double _getMaleWeightMedian(double months) {
    if (months <= 0) return 3.3;
    if (months <= 1) return 4.5;
    if (months <= 2) return 5.6;
    if (months <= 3) return 6.4;
    if (months <= 4) return 7.0;
    if (months <= 5) return 7.5;
    if (months <= 6) return 7.9;
    if (months <= 9) return 8.6;
    if (months <= 12) return 9.6;
    if (months <= 18) return 10.9;
    if (months <= 24) return 12.2;
    // Linear approximation for older ages
    return 12.2 + (months - 24) * 0.2;
  }
  
  // Simplified male weight SD (kg) by age in months
  static double _getMaleWeightSD(double months) {
    if (months <= 6) return 0.8;
    if (months <= 12) return 1.2;
    if (months <= 24) return 1.5;
    return 1.8;
  }
  
  // Simplified female weight median (kg) by age in months
  static double _getFemaleWeightMedian(double months) {
    if (months <= 0) return 3.2;
    if (months <= 1) return 4.2;
    if (months <= 2) return 5.1;
    if (months <= 3) return 5.8;
    if (months <= 4) return 6.4;
    if (months <= 5) return 6.9;
    if (months <= 6) return 7.3;
    if (months <= 9) return 8.0;
    if (months <= 12) return 9.0;
    if (months <= 18) return 10.2;
    if (months <= 24) return 11.5;
    // Linear approximation for older ages
    return 11.5 + (months - 24) * 0.18;
  }
  
  // Simplified female weight SD (kg) by age in months
  static double _getFemaleWeightSD(double months) {
    if (months <= 6) return 0.7;
    if (months <= 12) return 1.0;
    if (months <= 24) return 1.3;
    return 1.6;
  }
  
  /// Generate norm data for height (in cm) based on age in days
  static List<NormData> getHeightNorms({
    required int minAgeDays,
    required int maxAgeDays,
    required String gender,
  }) {
    final List<NormData> norms = [];
    
    for (int days = minAgeDays; days <= maxAgeDays; days += 30) {
      final months = days / 30.44;
      
      double median;
      double sd;
      
      if (gender == 'male') {
        median = _getMaleHeightMedian(months);
        sd = _getMaleHeightSD(months);
      } else {
        median = _getFemaleHeightMedian(months);
        sd = _getFemaleHeightSD(months);
      }
      
      norms.add(NormData(
        x: days.toDouble(),
        median: median,
        sd1Lower: median - sd,
        sd1Upper: median + sd,
        sd2Lower: median - 2 * sd,
        sd2Upper: median + 2 * sd,
        sd3Lower: median - 3 * sd,
        sd3Upper: median + 3 * sd,
      ));
    }
    
    return norms;
  }
  
  static double _getMaleHeightMedian(double months) {
    if (months <= 0) return 49.9;
    if (months <= 1) return 54.7;
    if (months <= 2) return 58.4;
    if (months <= 3) return 61.4;
    if (months <= 6) return 67.6;
    if (months <= 9) return 72.0;
    if (months <= 12) return 75.7;
    if (months <= 18) return 82.3;
    if (months <= 24) return 87.8;
    return 87.8 + (months - 24) * 0.8;
  }
  
  static double _getMaleHeightSD(double months) {
    if (months <= 6) return 3.5;
    if (months <= 12) return 4.0;
    if (months <= 24) return 4.5;
    return 5.0;
  }
  
  static double _getFemaleHeightMedian(double months) {
    if (months <= 0) return 49.1;
    if (months <= 1) return 53.7;
    if (months <= 2) return 57.1;
    if (months <= 3) return 59.8;
    if (months <= 6) return 65.7;
    if (months <= 9) return 70.1;
    if (months <= 12) return 74.0;
    if (months <= 18) return 80.7;
    if (months <= 24) return 86.4;
    return 86.4 + (months - 24) * 0.75;
  }
  
  static double _getFemaleHeightSD(double months) {
    if (months <= 6) return 3.3;
    if (months <= 12) return 3.8;
    if (months <= 24) return 4.3;
    return 4.8;
  }
  
  /// Generate norm data for head circumference (in cm)
  static List<NormData> getHeadCircumferenceNorms({
    required int minAgeDays,
    required int maxAgeDays,
    required String gender,
  }) {
    final List<NormData> norms = [];
    
    for (int days = minAgeDays; days <= maxAgeDays; days += 30) {
      final months = days / 30.44;
      
      double median;
      double sd;
      
      if (gender == 'male') {
        median = _getMaleHeadCircumferenceMedian(months);
        sd = _getMaleHeadCircumferenceSD(months);
      } else {
        median = _getFemaleHeadCircumferenceMedian(months);
        sd = _getFemaleHeadCircumferenceSD(months);
      }
      
      norms.add(NormData(
        x: days.toDouble(),
        median: median,
        sd1Lower: median - sd,
        sd1Upper: median + sd,
        sd2Lower: median - 2 * sd,
        sd2Upper: median + 2 * sd,
        sd3Lower: median - 3 * sd,
        sd3Upper: median + 3 * sd,
      ));
    }
    
    return norms;
  }
  
  static double _getMaleHeadCircumferenceMedian(double months) {
    if (months <= 0) return 34.5;
    if (months <= 1) return 37.3;
    if (months <= 2) return 39.1;
    if (months <= 3) return 40.5;
    if (months <= 6) return 43.3;
    if (months <= 9) return 45.0;
    if (months <= 12) return 46.1;
    if (months <= 18) return 47.6;
    if (months <= 24) return 48.4;
    return 48.4 + (months - 24) * 0.1;
  }
  
  static double _getMaleHeadCircumferenceSD(double months) {
    if (months <= 6) return 2.8;
    if (months <= 12) return 3.0;
    if (months <= 24) return 3.2;
    return 3.4;
  }
  
  static double _getFemaleHeadCircumferenceMedian(double months) {
    if (months <= 0) return 33.9;
    if (months <= 1) return 36.5;
    if (months <= 2) return 38.3;
    if (months <= 3) return 39.5;
    if (months <= 6) return 42.2;
    if (months <= 9) return 43.8;
    if (months <= 12) return 45.0;
    if (months <= 18) return 46.4;
    if (months <= 24) return 47.2;
    return 47.2 + (months - 24) * 0.1;
  }
  
  static double _getFemaleHeadCircumferenceSD(double months) {
    if (months <= 6) return 2.6;
    if (months <= 12) return 2.8;
    if (months <= 24) return 3.0;
    return 3.2;
  }
}
