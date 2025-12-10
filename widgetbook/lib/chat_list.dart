import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Import the widget from your app
import 'package:mama/src/feature/chat/widgets/items/unread_box.dart';

@widgetbook.UseCase(name: 'Default', type: UnreadBox)
Widget buildDefaultUseCase(BuildContext context) {
  return UnreadBox(
    unread: 5,
  );
}

@widgetbook.UseCase(name: 'few count', type: UnreadBox)
Widget buildFewCountUseCase(BuildContext context) {
  return UnreadBox(
    unread: 15,
  );
}

@widgetbook.UseCase(name: 'many count', type: UnreadBox)
Widget buildManyCountUseCase(BuildContext context) {
  return UnreadBox(
    unread: 100,
  );
}

@widgetbook.UseCase(name: 'many count 2', type: UnreadBox)
Widget buildManyCountUseCase2(BuildContext context) {
  return UnreadBox(
    unread: 10000,
  );
}

@widgetbook.UseCase(name: 'all', type: UnreadBox)
Widget allVarious(BuildContext context) {
  return Column(
    children: [
      UnreadBox(
        unread: 9,
      ),
      SizedBox(
        height: 10,
      ),
      UnreadBox(
        unread: 99,
      ),
      SizedBox(
        height: 10,
      ),
      UnreadBox(
        unread: 999,
      ),
      SizedBox(
        height: 10,
      ),
      UnreadBox(
        unread: 9999,
      ),
      SizedBox(
        height: 10,
      ),
      UnreadBox(
        unread: 99999,
      ),
    ],
  );
}
