import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';

enum TrackerCategory { evolution, sleepAndCry, feeding, health, diapers }

extension TrackerCategoryExtension on TrackerCategory {
  String get title {
    switch (this) {
      case TrackerCategory.evolution:
        return 'Развитие';
      case TrackerCategory.sleepAndCry:
        return 'Сон и плач';
      case TrackerCategory.feeding:
        return 'Кормление';
      case TrackerCategory.health:
        return 'Здоровье';
      case TrackerCategory.diapers:
        return 'Подгузники';
    }
  }
}

extension RouteExtension on TrackerCategory {
  String get route {
    switch (this) {
      case TrackerCategory.evolution:
        return AppViews.evolutionView;
      case TrackerCategory.sleepAndCry:
        return ''; // Же керектүү маршрутту коюңуз
      case TrackerCategory.feeding:
        return AppViews.feeding;
      case TrackerCategory.health:
        return AppViews.trackersHealthView;
      case TrackerCategory.diapers:
        return AppViews.diapersView;
    }
  }
}

extension IconExtension on TrackerCategory {
  IconModel get icon {
    switch (this) {
      case TrackerCategory.evolution:
        return IconModel(iconPath: Assets.images.grow.path);
      case TrackerCategory.sleepAndCry:
        return IconModel(iconPath: Assets.images.sleep.path);
      case TrackerCategory.feeding:
        return IconModel(iconPath: Assets.images.feeding.path);
      case TrackerCategory.health:
        return IconModel(iconPath: Assets.images.health.path);
      case TrackerCategory.diapers:
        return IconModel(iconPath: Assets.images.diaper.path);
      default:
        throw Exception('Unhandled TrackerCategory:');
    }
  }
}

extension ColorsExtension on TrackerCategory {
  Color get backgroundColor {
    switch (this) {
      case TrackerCategory.evolution:
        return AppColors.blueLighter1;
      case TrackerCategory.sleepAndCry:
        return AppColors.lavenderBlue;
      case TrackerCategory.feeding:
        return AppColors.paleBlue;
      case TrackerCategory.health:
        return AppColors.lightPurple;
      case TrackerCategory.diapers:
        return AppColors.mintGreen;
      default:
        throw Exception('Unhandled TrackerCategory:');
    }
  }
}
