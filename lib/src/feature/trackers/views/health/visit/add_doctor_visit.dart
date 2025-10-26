import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

enum AddDocVisitType { add, edit }

class AddDocVisit extends StatelessWidget {
  final EntityMainDoctor? model;
  final DoctorVisitsStore? store;
  const AddDocVisit({super.key, this.model, this.store});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AddDoctorVisitViewStore(
          picker: context.read<Dependencies>().imagePicker,
          restClient: context.read<Dependencies>().restClient),
      builder: (context, child) {
        return _Body(
          store: context.watch(),
          type: model == null ? AddDocVisitType.add : AddDocVisitType.edit,
          model: model,
          doctorVisitsStore: store,
        );
      },
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    required this.store,
    required this.type,
    required this.doctorVisitsStore,
    this.model,
  });

  final EntityMainDoctor? model;
  final AddDoctorVisitViewStore store;
  final AddDocVisitType type;
  final DoctorVisitsStore? doctorVisitsStore;

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  void initState() {
    widget.store.init(widget.model);
    super.initState();
  }

  @override
  void dispose() {
    widget.store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: widget.type == AddDocVisitType.edit 
            ? t.trackers.doctor.editVisitTitle 
            : t.trackers.doctor.addNewVisitTitle,
        appBarColor: AppColors.e8ddf9,
        padding: const EdgeInsets.only(right: 8),
        titleTextStyle: textTheme.headlineSmall!
            .copyWith(fontSize: 17, color: AppColors.blueDark),
      ),
      backgroundColor: AppColors.primaryColorBright,
      bottomNavigationBar: SafeArea(
        child: VisitSaveButton(
          type: widget.type,
          store: widget.store,
          doctorVisitsStore: widget.doctorVisitsStore,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          VisitPhotoWidget(store: widget.store),
          20.h,
          VisitInputsWidget(store: widget.store),
          16.h,
        ],
      ),
    );
  }
}
