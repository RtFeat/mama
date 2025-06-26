import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class AddDiaper extends StatefulWidget {
  const AddDiaper({super.key});

  @override
  State<AddDiaper> createState() => _AddDiaperState();
}

class _AddDiaperState extends State<AddDiaper> {
  int selectedIndex = 0;
  bool isPopupVisible = false;

  DateTime? _selectedTime = DateTime.now();
  String? _selectedTypeOfDiaper;
  String? _countOfDiaper;

  void _onItemTapped(int index) {
    setState(() {
      if (isPopupVisible && index == selectedIndex) {
        _closeButton();
      } else {
        isPopupVisible = true;
      }
      selectedIndex = index;
    });
  }

  void _closeButton() {
    setState(() {
      isPopupVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch<UserStore>();
    final RestClient restClient = context.watch<Dependencies>().restClient;
    final AddNoteStore store = context.watch<AddNoteStore>();

    return Scaffold(
      backgroundColor: AppColors.diapersBackroundColor,
      appBar: CustomAppBar(
        title: t.trackers.diaper.add,
        padding: const EdgeInsets.only(right: 8),
        titleTextStyle: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: AppColors.trackerColor, fontSize: 17),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.whiteColor),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isPopupVisible)
                  CustomPopupWidget(
                    selectedIndex: selectedIndex,
                    countSelected: _countOfDiaper,
                    typeOfDiaperSelected: _selectedTypeOfDiaper,
                    closeButton: () => _closeButton(),
                    onCountSelected: (option) {
                      _countOfDiaper = option;
                      _closeButton();
                    },
                    onTypeOfDiaperSelected: (option) {
                      _selectedTypeOfDiaper = option;
                      _closeButton();
                    },
                  ),
                16.h,
                DiaperStateSwitch(
                  onTap: (index) => _onItemTapped(index),
                  selectedIndex: selectedIndex,
                  isPopupVisible: isPopupVisible,
                ),
                16.h,
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        type: CustomButtonType.outline,
                        onTap: () {
                          context.pushNamed(
                            AppViews.addNote,
                          );
                        },
                        maxLines: 1,
                        title: t.trackers.note.title,
                        icon: AppIcons.pencil,
                        iconColor: AppColors.primaryColor,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 12),
                        textStyle:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                      ),
                    ),
                  ],
                ),
                16.h,
                DateTimeSelectorWidget(
                  onChanged: (value) {
                    _selectedTime = value;
                  },
                ),
                16.h,
                Row(
                  children: [
                    AddButton(
                      title: t.trackers.add.title,
                      onTap: () {
                        restClient.diaper.postDiaper(
                            dto: DiapersCreateDiaperDto(
                                childId: userStore.selectedChild?.id,
                                howMuch: _countOfDiaper,
                                typeOfDiapers: _selectedTypeOfDiaper,
                                notes: store.content,
                                timeToEnd: _selectedTime
                                    ?.toUtc()
                                    .toString()
                                    .replaceAll('Z', '')));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
