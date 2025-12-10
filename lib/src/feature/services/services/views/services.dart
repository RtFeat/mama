import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class ServicesView extends StatelessWidget {
  final PreferredSizeWidget appBar;

  const ServicesView({
    super.key,
    required this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch<UserStore>();

    return Scaffold(
        appBar: appBar,
        body: switch (userStore.role) {
          Role.doctor => const SpecialistServicesBodyWidget(),
          Role.onlineSchool => const SchoolServicesBodyWidget(),
          _ => const UserServicesBodyWidget(),
        });
  }
}
