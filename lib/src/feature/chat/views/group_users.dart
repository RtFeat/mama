import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';

class GroupUsersView extends StatefulWidget {
  final GroupUsersStore? store;
  final GroupChatInfo? groupInfo;
  const GroupUsersView({
    super.key,
    required this.store,
    required this.groupInfo,
  });

  @override
  State<GroupUsersView> createState() => _GroupUsersViewState();
}

class _GroupUsersViewState extends State<GroupUsersView> {
  Map<String, bool Function(AccountModel)> filters = {};

  @override
  void initState() {
    widget.store?.loadPage(queryParams: {});
    filters = {
      'query': (AccountModel e) {
        if (widget.store?.query == null || (widget.store?.query)!.isEmpty) {
          return true;
        }
        return e.name.contains(widget.store?.query ?? '');
      }
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GroupChatInfo groupInfo = widget.groupInfo ?? GroupChatInfo();
    final TextTheme textTheme = Theme.of(context).textTheme;

    const double appBarHeight = 200;

    return Scaffold(
      body: Observer(builder: (context) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: appBarHeight,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  // Получаем текущую высоту AppBar
                  final double currentExtent = constraints.biggest.height;
                  const double minExtent =
                      kToolbarHeight; // Минимальная высота AppBar
                  const double maxExtent =
                      appBarHeight; // Высота, указанная в expandedHeight

                  // Вычисляем коэффициент сворачивания (0.0 - полностью свернуто, 1.0 - полностью развернуто)
                  final double t =
                      (currentExtent - minExtent) / (maxExtent - minExtent);

                  return FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(bottom: 14),
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (groupInfo.avatarUrl != null && t > 0.5)
                          AvatarWidget(
                            radius: 40,
                            size: const Size(70, 70),
                            url: groupInfo.avatarUrl!,
                          ),
                        if (groupInfo.name != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: AutoSizeText(
                              groupInfo.name!,
                              style: textTheme.headlineSmall!.copyWith(
                                fontSize: 24,
                                height: 1,
                              ),
                              maxLines: 2,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: BodyGroup(
                isDecorated: true,
                titlePadding: const EdgeInsets.only(left: 20, bottom: 8),
                backgroundBorderRadius: BorderRadius.circular(24),
                title: t.chat.buttonToogleSpecialist,
                items: widget.store?.doctors.map((e) {
                      return PersonItem(
                        person: e,
                        store: widget.store,
                      );
                    }).toList() ??
                    [],
              ),
            ),
            SliverToBoxAdapter(
              child: Observer(builder: (_) {
                return _Users(
                    store: widget.store,
                    users: widget.store != null &&
                            widget.store!.filteredUsers.isEmpty
                        ? widget.store?.users
                        : widget.store?.filteredUsers.toList() ?? []);
              }),
            ),
          ],
        );
      }),
    );
  }
}

class _Users extends StatelessWidget {
  final GroupUsersStore? store;
  final List<AccountModel>? users;
  const _Users({
    required this.store,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return BodyGroup(
        isDecorated: true,
        title: '',
        formGroup: store?.formGroup,
        items: [
          Finder(
            onChanged: (v) {
              store?.setQuery(v);
              store?.setFilters({
                'query': (e) {
                  if (v.isEmpty) return true;

                  return e.name.contains(store?.query ?? '');
                }
              });
            },
            onPressedClear: () {},
            formControlName: 'search',
            hintText: t.chat.hintSearchParticipant,
          ),
          if (users != null)
            ...users!.map((e) {
              return PersonItem(
                person: e,
                store: store,
              );
            })
        ]);
  }
}
