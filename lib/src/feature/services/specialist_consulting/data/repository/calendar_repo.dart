import '../../../../../data.dart';

var greenFC = AppColors.greenLighterBackgroundColor;
var greenTC = AppColors.greenTextColor;

var redFC = AppColors.redLighterBackgroundColor;
var redTC = AppColors.redColor;

var blueFC = AppColors.lightBlueBackgroundStatus;
var blueTC = AppColors.primaryColor;

var listOfDayOfWeek = [
  firstWeek,
  secondWeek,
  thirdWeek,
  fourthWeek,
  fifthWeek,
  sixthWeek
];

var firstWeek = [
  DayOfWeek(
    day: 28,
    events: [Events(event: 1, fillColor: greenFC, textColor: greenTC)],
  ),
  DayOfWeek(
    day: 28,
    events: [Events(event: 3, fillColor: greenFC, textColor: greenTC)],
  ),
  DayOfWeek(
    day: 28,
    events: [Events(event: 2, fillColor: greenFC, textColor: greenTC)],
  ),
  DayOfWeek(
    day: 28,
    events: [
      Events(event: 3, fillColor: greenFC, textColor: greenTC),
      Events(event: 1, fillColor: redFC, textColor: redTC),
    ],
  ),
  DayOfWeek(
    day: 1,
    events: [Events(event: 3, fillColor: greenFC, textColor: greenTC)],
  ),
  DayOfWeek(
    day: 2,
    events: [Events(event: 4, fillColor: greenFC, textColor: greenTC)],
  ),
  DayOfWeek(
    day: 3,
    events: [Events(event: 5, fillColor: greenFC, textColor: greenTC)],
  ),
];

var secondWeek = [
  DayOfWeek(
    day: 4,
    events: [Events(event: 3, fillColor: greenFC, textColor: greenTC)],
  ),
  DayOfWeek(
    day: 5,
    events: [
      Events(event: 2, fillColor: greenFC, textColor: greenTC),
      Events(event: 1, fillColor: redFC, textColor: redTC),
    ],
  ),
  DayOfWeek(
    day: 6,
    events: [
      Events(event: 1, fillColor: greenFC, textColor: greenTC),
      Events(event: 1, fillColor: redFC, textColor: redTC),
    ],
  ),
  DayOfWeek(
    day: 7,
    events: [
      Events(event: 3, fillColor: greenFC, textColor: greenTC),
    ],
  ),
  DayOfWeek(
    day: 8,
    events: [
      Events(event: 1, fillColor: greenFC, textColor: greenTC),
      Events(event: 1, fillColor: redFC, textColor: redTC),
    ],
  ),
  DayOfWeek(
    day: 9,
    events: [Events(event: 4, fillColor: greenFC, textColor: greenTC)],
  ),
  DayOfWeek(
    day: 10,
    events: [Events(event: 5, fillColor: greenFC, textColor: greenTC)],
  ),
];

var thirdWeek = [
  DayOfWeek(
    day: 11,
    events: [Events(event: 3, fillColor: greenFC, textColor: greenTC)],
  ),
  DayOfWeek(
    day: 12,
    events: [
      Events(event: 2, fillColor: greenFC, textColor: greenTC),
      Events(event: 1, fillColor: redFC, textColor: redTC),
    ],
  ),
  DayOfWeek(
    day: 13,
    events: [Events(event: 3, fillColor: greenFC, textColor: greenTC)],
  ),
  DayOfWeek(
    day: 14,
    events: [
      Events(event: 3, fillColor: greenFC, textColor: greenTC),
    ],
  ),
  DayOfWeek(
    day: 15,
    events: [Events(event: 3, fillColor: greenFC, textColor: greenTC)],
  ),
  DayOfWeek(
    day: 16,
    events: [Events(event: 4, fillColor: greenFC, textColor: greenTC)],
  ),
  DayOfWeek(
    day: 17,
    events: [
      Events(event: 6, fillColor: greenFC, textColor: greenTC),
      Events(event: 1, fillColor: redFC, textColor: redTC),
    ],
  ),
];

var fourthWeek = [
  DayOfWeek(
    day: 18,
    events: [Events(event: 3, fillColor: greenFC, textColor: greenTC)],
  ),
  DayOfWeek(
    day: 19,
    events: [Events(event: 3, fillColor: greenFC, textColor: greenTC)],
  ),
  DayOfWeek(
    day: 20,
    events: [
      Events(event: 7, fillColor: greenFC, textColor: greenTC),
      Events(event: 1, fillColor: redFC, textColor: redTC),
    ],
  ),
  DayOfWeek(
    day: 21,
    events: [
      Events(event: 7, fillColor: greenFC, textColor: greenTC),
    ],
  ),
  DayOfWeek(
    day: 22,
    events: [
      Events(event: 3, fillColor: blueFC, textColor: blueTC),
      Events(event: 3, fillColor: greenFC, textColor: greenTC),
      Events(event: 1, fillColor: redFC, textColor: redTC),
    ],
  ),
  DayOfWeek(
    day: 23,
    events: [Events(event: 4, fillColor: blueFC, textColor: blueTC)],
  ),
  DayOfWeek(
    day: 24,
    events: [],
  ),
];

var fifthWeek = [
  DayOfWeek(
    day: 25,
    events: [Events(event: 16, fillColor: blueFC, textColor: blueTC)],
  ),
  DayOfWeek(
    day: 26,
    events: [Events(event: 3, fillColor: blueFC, textColor: blueTC)],
  ),
  DayOfWeek(
    day: 27,
    events: [
      Events(event: 7, fillColor: blueFC, textColor: blueTC),
    ],
  ),
  DayOfWeek(
    day: 28,
    events: [
      Events(event: 3, fillColor: blueFC, textColor: blueTC),
    ],
  ),
  DayOfWeek(
    day: 29,
    events: [
      Events(event: 3, fillColor: blueFC, textColor: blueTC),
    ],
  ),
  DayOfWeek(
    day: 30,
    events: [Events(event: 4, fillColor: blueFC, textColor: blueTC)],
  ),
  DayOfWeek(
    day: 1,
    events: [],
  ),
];

var sixthWeek = [
  DayOfWeek(day: 2,events: [],),
  DayOfWeek(day: 3, events: [],),
  DayOfWeek(day: 4,events: [],),
  DayOfWeek(day: 5, events: [],),
  DayOfWeek(day: 6, events: [],),
  DayOfWeek(day: 7,events: [],),
  DayOfWeek(day: 8, events: [],),
];
