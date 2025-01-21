import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';

class ConsultationRecords extends StatefulWidget {
  final ConsultationViewStore store;
  const ConsultationRecords({
    super.key,
    required this.store,
  });

  @override
  State<ConsultationRecords> createState() => _ConsultationRecordsState();
}

class _ConsultationRecordsState extends State<ConsultationRecords> {
  @override
  initState() {
    super.initState();
    widget.store.loadAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedLoadingWidget(
        emptyData: const SizedBox.shrink(),
        store: widget.store.recordsState,
        itemBuilder: (context, item) {
          final Consultation? consultation = item;

          return ConsultationItem(
              onTap: () {
                context.pushNamed(AppViews.consultation, extra: {
                  'consultation': consultation,
                });
              },
              url: consultation?.doctor?.account?.avatarUrl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConsultationTime(
                    startDate:
                        consultation?.startedAt?.toLocal() ?? DateTime.now(),
                    endDate: consultation?.endedAt?.toLocal() ?? DateTime.now(),
                  ),
                  ConsultationItemTitle(
                      name:
                          '${consultation?.doctor?.firstName} ${consultation?.doctor?.lastName}',
                      badgeTitle: consultation?.doctor?.profession),
                  ConsultationTypeWidget(
                    type: consultation?.type ?? ConsultationType.chat,
                    iconColor: AppColors.primaryColor,
                  ),
                ],
              ));
        });
    // );
  }
}
