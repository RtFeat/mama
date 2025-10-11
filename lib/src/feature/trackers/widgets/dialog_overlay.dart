import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart'; // Предполагая, что здесь AppColors и AppTextStyles

// --- Модель данных для виджета ---
class MeasurementDetails {
  final String title;
  final String previousWeek;
  final String selectedWeek;
  final String currentWeek;
  final String nextWeek;
  final String weight;
  final String weightStatus;
  final Color weightStatusColor;
  final String medianWeight;
  final String normWeightRange;
  final String weightToGain;
  final String? note;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? viewNormsLabel;

  final VoidCallback? onNoteEdit;
  final VoidCallback? onNoteDelete;
  final VoidCallback? onClose;
  final VoidCallback? onNextWeekTap;
  final VoidCallback? onPreviousWeekTap;

  MeasurementDetails({
    required this.title,
    required this.currentWeek,
    required this.selectedWeek,
    required this.previousWeek,
    required this.nextWeek,
    required this.weight,
    required this.weightStatus,
    required this.weightStatusColor,
    required this.medianWeight,
    required this.normWeightRange,
    required this.weightToGain,
    this.note,
    this.onEdit,
    this.onDelete,
    this.onClose,
    this.onNoteEdit,
    this.onNoteDelete,
    this.onNextWeekTap,
    this.onPreviousWeekTap,
    this.viewNormsLabel,
  });
}

/// Оверлей для отображения детальной информации об измерении.
/// Вызывается через `showDialog`.
///
/// Пример использования:
/// ```
/// showDialog(
///   context: context,
///   barrierColor: Colors.black.withOpacity(0.5),
///   builder: (context) {
///     final details = MeasurementDetails(...);
///     return MeasurementOverlay(details: details);
///   },
/// );
/// ```
class MeasurementOverlay extends StatelessWidget {
  final MeasurementDetails details;

  const MeasurementOverlay({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        // Добавлено для контента, который может не поместиться на маленьких экранах
        child: Container(
          width: 374,
          padding: const EdgeInsets.all(8),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x190834A5),
                blurRadius: 1,
                offset: Offset(0, 2),
              ),
              BoxShadow(
                color: Color(0x260C4BE9),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(title: details.title, onClose: details.onClose),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                child: Row(
                  children: [
                    Text(
                      details.previousWeek,
                      style: AppTextStyles.f10w400,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: details.onPreviousWeekTap,
                      child: Icon(
                        AppIcons.chevronBackward,
                        color: AppColors.primaryColor,
                        size: 26,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      details.selectedWeek,
                      style: AppTextStyles.f17w400,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: details.onNextWeekTap,
                      child: Icon(
                        AppIcons.chevronForward,
                        color: AppColors.primaryColor,
                        size: 26,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      details.nextWeek,
                      style: AppTextStyles.f10w400,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _MeasurementCard(details: details),
              const SizedBox(height: 8),
              _ViewNormsButton(label: details.viewNormsLabel ?? 'Смотреть нормы веса'),
              if (details.note != null && details.note!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _NoteCard(details: details),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// --- Разделение на под-виджеты для читаемости ---

class _Header extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;

  const _Header({required this.title, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF11424B),
                fontSize: 20,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: onClose ?? () => Navigator.of(context).pop(),
              child: const Icon(Icons.close, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeasurementCard extends StatelessWidget {
  final MeasurementDetails details;
  const _MeasurementCard({required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE1E6FF)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                details.currentWeek,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontFamily: 'SF Pro Text',
                  fontWeight: FontWeight.w400,
                ),
              ),
              16.w,
              Row(
                children: [
                  Text(
                    details.weight,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontFamily: 'SF Pro Text',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    details.weightStatus,
                    style: TextStyle(
                      color: details.weightStatusColor,
                      fontSize: 10,
                      fontFamily: 'SF Pro Text',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoColumn(title: 'Медиана', value: details.medianWeight),
              12.w,
              _InfoColumn(title: 'Норма', value: details.normWeightRange),
              if (details.weightToGain.isNotEmpty) ...[
                12.w,
                _InfoColumn(
                    title: 'Надо добрать',
                    value: details.weightToGain,
                    icon: AppIcons.arrowUpRight),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                  onTap: details.onDelete,
                  child: const Icon(AppIcons.trash, color: AppColors.redColor)),
              16.w,
              GestureDetector(
                  onTap: details.onEdit,
                  child: const Icon(
                    AppIcons.squareAndPencil,
                    color: AppColors.greyLighterColor,
                    size: 28,
                  )),
            ],
          )
        ],
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;

  const _InfoColumn({required this.title, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF666D7F),
            fontSize: 10,
            fontFamily: 'SF Pro Text',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: AppColors.greenLightTextColor),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF666D7F),
                fontSize: 14,
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ViewNormsButton extends StatelessWidget {
  final String label;
  const _ViewNormsButton({super.key, required this.label});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO:Handle tap
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 2, color: Color(0xFFE1E6FF)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(AppIcons.rectanglesGroupFill,
                  color: AppColors.primaryColor),
              const SizedBox(width: 8),
              SizedBox(
                width: 120,
                child: Text(
                  label,
                  style: const TextStyle(
                    height: 1.2,
                    letterSpacing: -.1,
                    color: Color(0xFF4D4DE7),
                    fontSize: 10,
                    fontFamily: 'SF Pro Text',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final MeasurementDetails details;
  const _NoteCard({required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
              width: 1, color: AppColors.lightBlueBackgroundStatus),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.lightBlueBackgroundStatus,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: const Text(
              'Заметка',
              style: TextStyle(
                color: AppColors.greyBrighterColor,
                fontSize: 14,
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: Text(
              details.note!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: details.onNoteDelete,
                    child:
                        const Icon(AppIcons.trash, color: AppColors.redColor)),
                16.w,
                GestureDetector(
                    onTap: details.onNoteEdit,
                    child: const Icon(
                      AppIcons.squareAndPencil,
                      color: AppColors.greyLighterColor,
                      size: 28,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
