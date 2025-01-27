import 'package:mama/src/data.dart';

enum EvolutionCategory {
  weight,
  growth,
  head,
  table;
}

extension EvolutionTabViewExtension on EvolutionCategory {
  String get title {
    switch (this) {
      case EvolutionCategory.weight:
        return t.trackers.weight.title;
      case EvolutionCategory.growth:
        return t.trackers.growth.title;
      case EvolutionCategory.head:
        return t.trackers.head.title;
      case EvolutionCategory.table:
        return 'Таблица';
      default:
        return '';
    }
  }
}

extension EvolutionKnowMore on EvolutionCategory {
  String get knowMoreTitle {
    switch (this) {
      case EvolutionCategory.weight:
        return t.trackers.findOutMoreTextWeight;
      case EvolutionCategory.growth:
        return t.trackers.findOutMoreTextHeight;
      case EvolutionCategory.head:
        return t.trackers.findOutMoreTextHead;
      default:
        return '';
    }
  }
}

extension CurrentLabel on EvolutionCategory {
  String get currentLabel {
    switch (this) {
      case EvolutionCategory.weight:
        return '6 кг 250 г';
      case EvolutionCategory.growth:
        return '67 см';
      case EvolutionCategory.head:
        return '42 см';
      default:
        return '';
    }
  }
}

extension DynamicLabel on EvolutionCategory {
  String get dynamicLabel {
    switch (this) {
      case EvolutionCategory.weight:
        return '+150 г';
      case EvolutionCategory.growth:
        return '+9 см';
      case EvolutionCategory.head:
        return '+3,5 см';
      default:
        return '';
    }
  }
}

extension SwitchContainerTitle on EvolutionCategory {
  String get switchContainerTitle1 {
    switch (this) {
      case EvolutionCategory.weight:
        return t.trackers.kg.title;
      case EvolutionCategory.growth:
        return t.trackers.cm.title.toUpperCase();
      case EvolutionCategory.head:
        return t.trackers.cm.title.toUpperCase();
      default:
        return '';
    }
  }

  String get switchContainerTitle2 {
    switch (this) {
      case EvolutionCategory.weight:
        return t.trackers.g.title;
      case EvolutionCategory.growth:
        return t.trackers.m.title.toUpperCase();
      case EvolutionCategory.head:
        return t.trackers.m.title.toUpperCase();
      default:
        return '';
    }
  }
}

extension StoriesValueTitle on EvolutionCategory {
  String get storiesValueTitle {
    switch (this) {
      case EvolutionCategory.weight:
        return t.trackers.weight.title;
      case EvolutionCategory.growth:
        return t.trackers.growth.title;
      case EvolutionCategory.head:
        return t.trackers.head.title;
      default:
        return '';
    }
  }
}

extension StoriesValue on EvolutionCategory {
  String get storiesValue {
    switch (this) {
      case EvolutionCategory.weight:
        return '1';
      case EvolutionCategory.growth:
        return '2';
      case EvolutionCategory.head:
        return '3';
      default:
        return '';
    }
  }
}

extension AddButtonTitle on EvolutionCategory {
  String get addButtonTitle {
    switch (this) {
      case EvolutionCategory.weight:
        return t.trackers.weight.add;
      case EvolutionCategory.growth:
        return t.trackers.growth.add;
      case EvolutionCategory.head:
        return t.trackers.head.add;
      default:
        return '';
    }
  }
}

extension Router on EvolutionCategory {
  String get route {
    switch (this) {
      case EvolutionCategory.weight:
        return AppViews.addWeightView;
      case EvolutionCategory.growth:
        return AppViews.addGrowthView;
      case EvolutionCategory.head:
        return AppViews.addHeadView;
      default:
        return '';
    }
  }
}
