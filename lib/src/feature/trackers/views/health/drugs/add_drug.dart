import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class AddDrugView extends StatelessWidget {
  final EntityMainDrug? model;
  final DrugsStore? store;
  const AddDrugView({super.key, this.model, this.store});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AddDrugsViewStore(
          picker: context.read<Dependencies>().imagePicker,
          restClient: context.read<Dependencies>().restClient,
          sharedPreferences: context.read<Dependencies>().sharedPreferences),
      builder: (context, child) {
        return _Body(
          addDrugsStore: context.watch(),
          model: model,
          store: store,
        );
      },
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    required this.store,
    required this.addDrugsStore,
    this.model,
  });

  final EntityMainDrug? model;
  final DrugsStore? store;
  final AddDrugsViewStore addDrugsStore;

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  void initState() {
    widget.addDrugsStore.init(widget.model);
    super.initState();
  }

  @override
  void dispose() {
    widget.addDrugsStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: widget.model != null ? t.trackers.medicines.edit : t.trackers.medicines.add,
        appBarColor: AppColors.e8ddf9,
        padding: const EdgeInsets.only(right: 8),
        titleTextStyle: textTheme.headlineSmall!
            .copyWith(fontSize: 17, color: AppColors.blueDark),
      ),
      backgroundColor: AppColors.primaryColorBright,
      bottomNavigationBar: SafeArea(
          child: DrugsBottomBarWidget(
        store: widget.store,
      )),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          DrugPhoto(),
          // VisitPhotoWidget(store: widget.addDrugsStore),
          20.h,
          DrugsInputs(),
          // VisitInputsWidget(store: widget.store),
          16.h,
          DrugNotificationsWidget(),
        ],
      ),
    );
  }
}
