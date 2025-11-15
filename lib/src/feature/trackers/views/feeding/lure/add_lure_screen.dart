import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/feature/trackers/widgets/date_time_selector.dart';
import 'package:mama/src/core/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/core/api/export.dart';

class AddLureScreen extends StatefulWidget {
  final Object? existing; // can be EntityLureHistory
  const AddLureScreen({super.key, this.existing});

  @override
  State<AddLureScreen> createState() => _AddLureScreenState();
}

class _ProductEntry {
  final TextEditingController name = TextEditingController();
  final TextEditingController grams = TextEditingController(text: '0');
  LureReaction reaction = LureReaction.dislike;
}

enum LureReaction { like, dislike, allergy }

class _AddLureScreenState extends State<AddLureScreen> {
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _gramsController = TextEditingController(text: '0');
  final List<_ProductEntry> _entries = <_ProductEntry>[];

  LureReaction? _reaction = LureReaction.dislike;
  DateTime _selectedDateTime = DateTime.now();
  String? _noteText;

  EntityLureHistory? get existingRec => widget.existing is EntityLureHistory ? widget.existing as EntityLureHistory : null;

  @override
  void dispose() {
    _productController.dispose();
    _gramsController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    // 14 сентября
    final months = t.home.monthsData.title;
    final monthName = (dt.month >= 1 && dt.month <= months.length)
        ? months[dt.month - 1]
        : '';
    return '${dt.day} $monthName';
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pickTime() async {
    final TimeOfDay initial = TimeOfDay.fromDateTime(_selectedDateTime);
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Prefill for edit
    if (existingRec != null) {
      _noteText ??= existingRec!.notes;
      _gramsController.text = (existingRec!.gram ?? 0).toString();
      final r = (existingRec!.reaction ?? '').toLowerCase();
      _reaction = r == 'like' ? LureReaction.like : r == 'allergy' ? LureReaction.allergy : LureReaction.dislike;
      if ((existingRec!.time ?? '').isNotEmpty) {
        try {
          final parsed = existingRec!.time!.contains('T')
              ? DateTime.parse(existingRec!.time!)
              : DateFormat('yyyy-MM-dd HH:mm:ss').parse(existingRec!.time!);
          _selectedDateTime = parsed.toLocal();
        } catch (_) {}
      }
    }
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final bool canSubmit = _productController.text.trim().isNotEmpty;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          height: 55,
          titleWidget: Text(
            t.feeding.addComplementaryFood,
            style: textTheme.titleMedium?.copyWith(color: AppColors.darkSlateBlue),
          ),
        ),
        body: SafeArea(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: _buildProductCard(context, index: 0),
                ),
                // Dynamic extra product cards (up to 4 more)
                for (int i = 0; i < _entries.length; i++) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: _buildExtraProductCard(context, i),
                  ),
                ],
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextButton.icon(
                      onPressed: _entries.length >= 4
                          ? null
                          : () {
                              setState(() {
                                _entries.add(_ProductEntry());
                              });
                            },
                      icon: const Icon(Icons.add_box_outlined, color: AppColors.primaryColor),
                      label: Text(
                        'Добавить продукт',
                        style: textTheme.titleSmall?.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DateTimeSelectorWidget(
                onChanged: (value) {
                  setState(() {
                    _selectedDateTime = value ?? DateTime.now();
                  });
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      height: 48,
                      width: double.infinity,
                      type: CustomButtonType.outline,
                      icon: AppIcons.pencil,
                      iconColor: AppColors.primaryColor,
                      title: t.trackers.note.title,
                      textStyle: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                      onTap: () {
                        context.pushNamed(AppViews.addNote, extra: {
                          'initialValue': _noteText,
                          'onSaved': (String value) {
                            setState(() {
                              _noteText = value;
                            });
                          },
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      height: 48,
                      width: double.infinity,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                      backgroundColor: AppColors.purpleLighterBackgroundColor,
                      title: existingRec != null ? t.trackers.save : t.trackers.add.title,
                      textStyle: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                      onTap: canSubmit
                          ? () async {
                              final deps = context.read<Dependencies>();
                              final user = context.read<UserStore>();
                              final childId = user.selectedChild?.id;
                              if (childId == null) return;

                              final List<EntityInsertLure> items = [];
                              // Base (first) card
                              items.add(
                                EntityInsertLure(
                                  childId: childId,
                                  nameProduct: _productController.text.trim(),
                                  gram: int.tryParse(_gramsController.text.trim()) ?? 0,
                                  reaction: _reaction == LureReaction.like
                                      ? 'like'
                                      : _reaction == LureReaction.allergy
                                          ? 'allergy'
                                          : 'dislike',
                                  timeToEnd: DateFormat('yyyy-MM-dd HH:mm:ss').format(_selectedDateTime.add(const Duration(hours: 3))),
                                  notes: _noteText?.isNotEmpty == true ? _noteText! : '',
                                ),
                              );
                              // Extra dynamic cards
                              for (final e in _entries) {
                                if (e.name.text.trim().isEmpty) continue;
                                items.add(
                                  EntityInsertLure(
                                    childId: childId,
                                    nameProduct: e.name.text.trim(),
                                    gram: int.tryParse(e.grams.text.trim()) ?? 0,
                                    reaction: e.reaction.name,
                                    timeToEnd: DateFormat('yyyy-MM-dd HH:mm:ss').format(_selectedDateTime.add(const Duration(hours: 3))),
                                    notes: _noteText?.isNotEmpty == true ? _noteText! : '',
                                  ),
                                );
                              }

                              final dto = FeedInsertLureDto(lure: items);

                              try {
                                if (existingRec != null && (existingRec!.id?.isNotEmpty == true)) {
                                  await deps.apiClient.patch('feed/lure/stats', body: {
                                    'id': existingRec!.id,
                                    'child_id': childId,
                                    'time_to_end': DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(_selectedDateTime.toUtc()),
                                    'gram': int.tryParse(_gramsController.text.trim()) ?? 0,
                                    'reaction': _reaction == LureReaction.like
                                        ? 'like'
                                        : _reaction == LureReaction.allergy
                                            ? 'allergy'
                                            : 'dislike',
                                    'name_product': _productController.text.trim(),
                                  });
                                  if (_noteText != null) {
                                    await deps.apiClient.patch('feed/lure/notes', body: {
                                      'id': existingRec!.id,
                                      'notes': _noteText,
                                    });
                                  }
                                } else {
                                  await deps.restClient.feed.postFeedLure(dto: dto);
                                }
                                if (mounted) {
                                  // Очищаем заметку после успешного сохранения
                                  setState(() {
                                    _noteText = null;
                                  });
                                  context.pop(true);
                                }
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Ошибка сохранения: $e')),
                                );
                              }
                            }
                          : null,
                    ),
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

  Widget _buildProductCard(BuildContext context, {required int index}) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Продукт',
                  style: textTheme.titleMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).maybePop(),
                child: const Icon(Icons.close, color: AppColors.redColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Название', style: textTheme.labelSmall?.copyWith(color: AppColors.greyBrighterColor)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _productController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Введите название продукта',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: const UnderlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 88,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Грамм', style: textTheme.labelSmall?.copyWith(color: AppColors.greyBrighterColor)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _gramsController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => FocusScope.of(context).unfocus(),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Реакция ребенка', style: textTheme.labelSmall?.copyWith(color: AppColors.greyBrighterColor)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _reactionTile(
                label: 'Понравилось',
                icon: const Text('🙂', style: TextStyle(fontSize: 17)),
                selected: _reaction == LureReaction.like,
                onTap: () => setState(() => _reaction = LureReaction.like),
              ),
              _reactionTile(
                label: 'Не понравилось',
                icon: const Text('🤢', style: TextStyle(fontSize: 17)),
                selected: _reaction == LureReaction.dislike,
                onTap: () => setState(() => _reaction = LureReaction.dislike),
              ),
              _reactionTile(
                label: 'Аллергическая\nреакция',
                icon: const Text('⚠', style: TextStyle(fontSize: 17)),
                selected: _reaction == LureReaction.allergy,
                onTap: () => setState(() => _reaction = LureReaction.allergy),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExtraProductCard(BuildContext context, int idx) {
    final entry = _entries[idx];
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Продукт', style: textTheme.titleMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14)),
              ),
              InkWell(
                onTap: () => setState(() => _entries.removeAt(idx)),
                child: const Icon(Icons.close, color: AppColors.redColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Название', style: textTheme.labelSmall?.copyWith(color: AppColors.greyBrighterColor)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: entry.name,
                      decoration: const InputDecoration(
                        hintText: 'Введите название продукта',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 88,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Грамм', style: textTheme.labelSmall?.copyWith(color: AppColors.greyBrighterColor)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: entry.grams,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => FocusScope.of(context).unfocus(),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Реакция ребенка', style: textTheme.labelSmall?.copyWith(color: AppColors.greyBrighterColor)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _extraReactionTile(entry, label: 'Понравилось', icon: const Text('🙂', style: TextStyle(fontSize: 17)), value: LureReaction.like),
              _extraReactionTile(entry, label: 'Не понравилось', icon: const Text('🤢', style: TextStyle(fontSize: 17)), value: LureReaction.dislike),
              _extraReactionTile(entry, label: 'Аллергическая\nреакция', icon: const Text('⚠', style: TextStyle(fontSize: 17)), value: LureReaction.allergy),
            ],
          ),
        ],
      ),
    );
  }

  Widget _extraReactionTile(_ProductEntry e, {required String label, required Widget icon, required LureReaction value}) {
    final bool selected = e.reaction == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => e.reaction = value),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 65,
          decoration: BoxDecoration(
            color: selected ? AppColors.whiteColor : const Color(0xFFF2F3F7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: selected ? AppColors.whiteColor : Colors.transparent, width: selected ? 1.5 : 0),
            boxShadow: selected ? [
              BoxShadow(color: Colors.grey.withValues(alpha: 0.2), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3)),
            ] : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(height: 4),
              Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: selected ? FontWeight.w600 : FontWeight.w400, color: selected ? AppColors.primaryColor : AppColors.darkSlateBlue)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reactionTile({
    required String label,
    required Widget icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 65,
          decoration: BoxDecoration(
            color: selected ? AppColors.whiteColor : const Color(0xFFF2F3F7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? AppColors.whiteColor : Colors.transparent,
              width: selected ? 1.5 : 0,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? AppColors.primaryColor : AppColors.darkSlateBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pillButton({
    required String label,
    required VoidCallback onTap,
    Widget? leading,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isPrimary ? Colors.white : const Color(0xFFECEFFE),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[
              leading,
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? AppColors.primaryColor : AppColors.darkSlateBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
