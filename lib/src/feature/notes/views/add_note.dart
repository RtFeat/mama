import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class AddNoteView extends StatefulWidget {
  final AddNoteStore? store;
  final String? initialValue;
  final Function(String value)? onSaved;
  const AddNoteView({
    super.key,
    this.store,
    this.initialValue,
    this.onSaved,
  });

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
        text: widget.initialValue ?? widget.store?.content);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: CustomAppBar(
        title: t.feeding.note,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _Body(
          controller: controller,
        ),
      ),
      bottomNavigationBar: _BtmBarWidget(
        controller: controller,
        onSaved: widget.onSaved,
      ),
    );
  }
}

class _BtmBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String value)? onSaved;
  const _BtmBarWidget({
    required this.controller,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    final AddNoteStore store = context.watch();

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16),
      child: SafeArea(
        child: SizedBox(
          height: 50,
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                  child: CustomButton(
                title: t.profile.cancel,
                backgroundColor: AppColors.redLighterBackgroundColor,
                onTap: () {
                  store.setContent(null);
                  onSaved?.call('');
                  context.pop();
                },
              )),
              Expanded(
                  flex: 3,
                  child: ValueListenableBuilder(
                      valueListenable: controller!,
                      builder: (context, value, child) {
                        return CustomButton(
                          onTap: value.text.isEmpty
                              ? null
                              : () {
                                  store.setContent(controller?.text);
                                  onSaved?.call(controller!.text);
                                  context.pop();
                                },
                          maxLines: 1,
                          title: t.trackers.save,
                          icon: AppIcons.pencil,
                          iconColor: AppColors.primaryColor,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 12),
                          textStyle:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                  ),
                        );
                      }))
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final TextEditingController? controller;
  const _Body({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 1,
      maxLines: null,
      style: AppTextStyles.f17w400,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
        fillColor: AppColors.whiteColor,
        filled: true,
        hintText: t.services.addNoteHint,
        hintStyle: AppTextStyles.f17w400.copyWith(color: AppColors.greyColor),
      ),
    );
  }
}
