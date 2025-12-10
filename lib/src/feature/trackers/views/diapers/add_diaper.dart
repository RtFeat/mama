import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/core/api/models/diapers_update_diaper_dto.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class AddDiaper extends StatefulWidget {
  final Function(DiapersCreateDiaperDto data, String? id, [Map<String, dynamic>? originalData]) onSave;
  final Function(String id)? onDelete;
  final Map<String, dynamic>? editData;
  const AddDiaper({super.key, required this.onSave, this.onDelete, this.editData});

  @override
  State<AddDiaper> createState() => _AddDiaperState();
}

class _AddDiaperState extends State<AddDiaper> {
  int selectedIndex = 0;
  bool isPopupVisible = false;

  DateTime? _selectedTime = DateTime.now();
  String? _selectedTypeOfDiaper;
  String? _countOfDiaper;

  @override
  void initState() {
    super.initState();
    
    // Инициализируем данные для редактирования
    if (widget.editData != null) {
      _selectedTypeOfDiaper = widget.editData!['typeOfDiapers'] as String?;
      _countOfDiaper = widget.editData!['howMuch'] as String?;
      
      // Определяем selectedIndex по типу подгузника
      final typeOfDiapers = widget.editData!['typeOfDiapers'] as String?;
      switch (typeOfDiapers?.toLowerCase()) {
        case 'мокрый':
          selectedIndex = 0;
          break;
        case 'смешанный':
          selectedIndex = 1;
          break;
        case 'грязный':
          selectedIndex = 2;
          break;
        default:
          selectedIndex = 0;
      }
      
      // Парсим время из строки
      final timeStr = widget.editData!['time'] as String?;
      if (timeStr != null) {
        final parts = timeStr.split(':');
        if (parts.length >= 2) {
          final hour = int.tryParse(parts[0]) ?? 0;
          final minute = int.tryParse(parts[1]) ?? 0;
          _selectedTime = DateTime.now().copyWith(hour: hour, minute: minute);
        }
      }
    }
  }

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
        title: widget.editData != null ? t.trackers.diaper.edit : t.trackers.diaper.add,
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
                      _countOfDiaper = option; // Также обновляем количество
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
                    Expanded(
                      child: AddButton(
                        title: t.trackers.add.title,
                        onTap: () {
                        // Определяем основной тип подгузника по выбранному индексу
                        String mainType;
                        switch (selectedIndex) {
                          case 0:
                            mainType = 'Мокрый';
                            break;
                          case 1:
                            mainType = 'Смешанный';
                            break;
                          case 2:
                            mainType = 'Грязный';
                            break;
                          default:
                            mainType = 'Мокрый';
                        }
                        
                        // Для всех типов подгузников сохраняем количество
                        String howMuch = _countOfDiaper ?? '';
                        
                        
                        // Если количество не выбрано, используем описание из popup
                        // Но только если пользователь не выбрал конкретное количество
                        if (howMuch.isEmpty && _selectedTypeOfDiaper != null) {
                          howMuch = _selectedTypeOfDiaper!;
                        }
                        
                        
                        if (widget.editData != null) {
                          // Редактируем существующую запись
                          final updateDto = DiapersUpdateDiaperDto(
                            id: widget.editData!['id'] as String?,
                            howMuch: howMuch,
                            typeOfDiapers: mainType,
                            notes: store.content,
                            timeToEnd: _selectedTime != null 
                                ? _selectedTime!.toUtc().toIso8601String()
                                : null,
                          );
                          restClient.diaper.patchDiaper(dto: updateDto).then((_) {
                            if (context.mounted) {
                              final editId = widget.editData!['id'] as String?;
                              context.pop();
                              widget.onSave(DiapersCreateDiaperDto(
                                childId: userStore.selectedChild?.id,
                                howMuch: howMuch,
                                typeOfDiapers: mainType,
                                notes: store.content,
                                timeToEnd: _selectedTime != null 
                                    ? DateFormat('yyyy-MM-dd HH:mm:ss.000').format(_selectedTime!.toUtc())
                                    : null,
                              ), editId, {
                                'originalTime': widget.editData!['time'],
                                'originalType': widget.editData!['typeOfDiapers'],
                              });
                            }
                          });
                        } else {
                          // Создаем новую запись
                          final dto = DiapersCreateDiaperDto(
                              childId: userStore.selectedChild?.id,
                              howMuch: howMuch,
                              typeOfDiapers: mainType, // Сохраняем основной тип, а не описание
                              notes: store.content,
                              timeToEnd: _selectedTime != null 
                                  ? DateFormat('yyyy-MM-dd HH:mm:ss.000').format(_selectedTime!.toUtc())
                                  : null);
                          restClient.diaper.postDiaper(dto: dto).then((value) {
                            if (context.mounted) {
                              context.pop();
                              // Передаем данные с ID из ответа сервера
                              widget.onSave(dto, value.id, null);
                            }
                          });
                        }
                      },
                      ),
                    ),
                    if (widget.editData != null) ...[
                      16.w,
                      Expanded(
                        child: CustomButton(
                          type: CustomButtonType.outline,
                          onTap: () {
                            final id = widget.editData!['id'] as String?;
                            if (widget.onDelete != null) {
                              if (id != null) {
                                widget.onDelete!(id);
                              } else {
                                // Если ID нет, передаем данные для удаления по другим параметрам
                                final time = widget.editData!['time'] as String? ?? '';
                                final type = widget.editData!['typeOfDiapers'] as String? ?? '';
                                widget.onDelete!('COMPOSITE_${time}_${type}');
                              }
                            }
                          },
                          maxLines: 1,
                          title: t.trackers.medicines.delete,
                          iconColor: const Color(0xFFCE6A6A),
                          backgroundColor: const Color(0xFFFBE3E3),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 12),
                          textStyle:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: const Color(0xFFCE6A6A),
                                  ),
                        ),
                      ),
                    ],
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
