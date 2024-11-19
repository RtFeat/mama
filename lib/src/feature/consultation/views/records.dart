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
        store: widget.store.recordsState,
        itemBuilder: (context, index) {
          final Consultation? consultation =
              widget.store.recordsState.listData[index];

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
                    startDate: consultation?.startedAt ?? DateTime.now(),
                    endDate: consultation?.endedAt ?? DateTime.now(),
                  ),
                  ConsultationItemTitle(
                      name:
                          '${consultation?.doctor?.firstName} ${consultation?.doctor?.lastName}',
                      badgeTitle: consultation?.doctor?.profession),
                  ConsultationTypeWidget(
                    type: consultation?.type ?? ConsultationType.chat,
                  ),
                ],
              ));
        });
    // );
  }
}
