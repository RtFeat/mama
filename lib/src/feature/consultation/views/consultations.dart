import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class ConsultationsView extends StatefulWidget {
  final int initialIndex;
  const ConsultationsView({super.key, this.initialIndex = 0});

  @override
  State<ConsultationsView> createState() => _ConsultationsViewState();
}

class _ConsultationsViewState extends State<ConsultationsView>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    controller = TabController(
        length: 3, vsync: this, initialIndex: widget.initialIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => ConsultationViewStore(
          faker: context.read<Dependencies>().faker,
          apiClient: context.read<Dependencies>().apiClient),
      builder: (context, _) {
        final ConsultationViewStore store = context.watch();

        return Scaffold(
            appBar: CustomAppBar(
              title: t.consultation.title,
              height: 114,
              // height: 94,
              action: const ProfileWidget(),
              tabController: controller,
              tabs: [
                t.consultation.records,
                t.consultation.professionals,
                t.consultation.schools,
              ],
            ),
            body: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: TabBarView(controller: controller, children: [
                ConsultationRecords(
                  store: store,
                ),
                SpecialistsView(
                  store: store,
                ),
                SchoolsView(
                  store: store,
                ),
              ]),
            ));
      },
    );
  }
}
