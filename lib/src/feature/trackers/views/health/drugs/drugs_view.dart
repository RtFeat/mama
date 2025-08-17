import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class DrugsView extends StatelessWidget {
  const DrugsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(
              create: (context) => DrugsDataSourceLocal(
                  sharedPreferences:
                      context.read<Dependencies>().sharedPreferences)),
          Provider(create: (context) {
            return DrugsStore(
              apiClient: context.read<Dependencies>().apiClient,
              onLoad: () => context.read<DrugsDataSourceLocal>().getIsShow(),
              onSet: (value) =>
                  context.read<DrugsDataSourceLocal>().setShow(value),
              faker: context.read<Dependencies>().faker,
            );
          })
        ],
        builder: (context, _) {
          final DrugsStore store = context.watch();
          final UserStore userStore = context.watch<UserStore>();

          return _Body(
            store: store,
            childId: userStore.selectedChild?.id ?? '',
          );
        });
  }
}

class _Body extends StatefulWidget {
  const _Body({
    required this.store,
    required this.childId,
  });

  final DrugsStore store;
  final String childId;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  void initState() {
    widget.store.loadPage(newFilters: [
      SkitFilter(
          field: 'child_id',
          operator: FilterOperator.equals,
          value: widget.childId),
    ]);

    widget.store.getIsShowInfo().then((v) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TrackerBody(
      learnMoreWidgetText: t.trackers.findOutMoreTextMedicines,
      // learnMoreStore: widget.store,
      isShowInfo: widget.store.isShowInfo,
      setIsShowInfo: (v) {
        widget.store.setIsShowInfo(v).then((v) {
          setState(() {});
        });
      },
      onPressLearnMore: () {},
      bottomNavigatorBar:

          /// #bottom buttons

          SafeArea(
        child: ButtonsLearnPdfAdd(
          onTapLearnMore: () {},
          onTapPDF: () {},
          onTapAdd: () {
            context.pushNamed(AppViews.addDrug, extra: {
              'data': null,
              'store': widget.store,
            });
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => Observer(builder: (_) {
            //       return AddMedicineView(
            //         titlesStyle: titlesStyle,
            //         store: store,
            //         medicineStore: medicineStore,
            //         type: AddMedicineType.add,
            //       );
            //     }),
            //   ),
            // );
          },
          iconAddButton: AppIcons.pillsFill,
          addButtonTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 17,
              ),
        ),
      ),
      children: [
        SliverToBoxAdapter(child: 16.h),
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                t.trackers.showCompleted.title,
                style: AppTextStyles.f17w400,
              ),
              Observer(builder: (context) {
                return CupertinoSwitch(
                  value: widget.store.isShowCompleted,
                  onChanged: (value) {
                    widget.store.setIsShowCompleted(value);
                  },
                );
              }),
            ],
          ),
        ),
        SliverToBoxAdapter(child: 16.h),
        PaginatedLoadingWidget(
            store: widget.store,
            listData: () => widget.store.isShowCompleted
                ? widget.store.completedList
                : widget.store.listData,
            itemsPadding: EdgeInsets.all(8),
            isFewLists: true,
            emptyData: SliverToBoxAdapter(child: SizedBox.shrink()),
            additionalLoadingWidget:
                SliverToBoxAdapter(child: SizedBox.shrink()),
            initialLoadingWidget: SliverToBoxAdapter(child: SizedBox.shrink()),
            itemBuilder: (context, item, index) {
              final EntityMainDrug model = item;

              final bool hasImage =
                  model.imageId != null && model.imageId!.isNotEmpty;
              final bool hasLocalImage = model.imagePath != null;

              return GestureDetector(
                onTap: () {
                  context.pushNamed(AppViews.addDrug, extra: {
                    'data': model,
                    'store': widget.store,
                  });
                  // context.pushNamed(AppViews.addVisit,
                  //     extra: {'data': model, 'store': widget.store});
                },
                child: DrugWidget(
                  imageUrl: !hasLocalImage && hasImage ? model.imageId : null,
                  imagePath: hasLocalImage ? model.imagePath : null,
                  model: model,
                ),
              );
            }),
      ],
    );
  }
}
