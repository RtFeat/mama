import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';

class TrackersView extends StatelessWidget {
  final CustomAppBar appBar;
  const TrackersView({super.key, required this.appBar});

  @override
  Widget build(BuildContext context) {
    final categories = [
      [TrackerCategory.evolution, TrackerCategory.sleepAndCry],
      [TrackerCategory.feeding],
      [TrackerCategory.health, TrackerCategory.diapers],
    ];

    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final row = categories[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: row
                    .map(
                      (category) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: CategoryCard(
                            onTap: () {
                              if (category.route.isNotEmpty) {
                                context.pushNamed(category.route);
                              }
                            },
                            title: category.title,
                            icon: category.icon,
                            backgroundColor: category.backgroundColor,
                          ),
                        ),
                      ),
                    )
                    .toList()
                  ..last = Expanded(
                    child: CategoryCard(
                      onTap: () {
                        if (row.last.route.isNotEmpty) {
                          context.pushNamed(row.last.route);
                        }
                      },
                      title: row.last.title,
                      icon: row.last.icon,
                      backgroundColor: row.last.backgroundColor,
                    ),
                  ),
              ),
            );
          },
        ),
      ),
    );
  }
}
