import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart';

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
  // Map<String, bool Function(AccountModel)> filters = {};

  @override
  void initState() {
    widget.store?.loadPage();
    // filters = {
    //   'query': (AccountModel e) {
    //     if (widget.store?.query == null || (widget.store?.query)!.isEmpty) {
    //       return true;
    //     }
    //     return e.name.contains(widget.store?.query ?? '');
    //   }
    // };
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
              child: _OtherRoles(store: widget.store),
            ),
            SliverToBoxAdapter(
              child: Observer(builder: (_) {
                return _Users(
                  store: widget.store,
                );
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
  const _Users({
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final TextStyle titleStyle = textTheme.labelLarge!;

    return ReactiveForm(
        formGroup: store!.formGroup,
        child: CustomScrollView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  bottom: 8,
                  top: 8,
                ),
                child: Text(
                  t.chat.groupChatsListTitle,
                  style: titleStyle,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CardWidget(
                  elevation: 0,
                  // title: t.chat.groupChatsListTitle,
                  child: CustomScrollView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Observer(builder: (_) {
                            return Finder(
                              suffixIcon: () {
                                if (store?.query == null ||
                                    store!.query!.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return GestureDetector(
                                  onTap: () {
                                    store?.formGroup.control('search').value =
                                        '';
                                    store?.setQuery('');
                                  },
                                  child: const Icon(
                                    Icons.clear,
                                    size: 24,
                                    color: AppColors.greyBrighterColor,
                                  ),
                                );
                              },
                              value: store?.query,
                              onChanged: (v) {
                                store?.setQuery(v);
                              },
                              onPressedClear: () {},
                              formControlName: 'search',
                              hintText: t.chat.hintSearchParticipant,
                            );
                          }),
                        ),
                        PaginatedLoadingWidget(
                          isFewLists: true,
                          store: store!,
                          listData: () {
                            if (store!.query != null &&
                                store!.query!.isNotEmpty) {
                              return store!.filteredUsers;
                            }
                            return store!.listData;
                          },
                          // separator: (_, __) => separator,
                          itemBuilder: (context, item, _) {
                            return PersonItem(
                              person: item,
                              store: store,
                            );
                          },
                        ),
                      ])),
            )
          ],
        ));
  }
}

class _OtherRoles extends StatelessWidget {
  final GroupUsersStore? store;
  const _OtherRoles({
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final TextStyle titleStyle = textTheme.labelLarge!;

    return Observer(
      builder: (context) {
        return CustomScrollView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  bottom: 8,
                  top: 8,
                ),
                child: Text(
                  t.chat.buttonToogleSpecialist,
                  style: titleStyle,
                ),
              ),
            ),
            if (store!.doctors.isEmpty)
              const SliverToBoxAdapter(
                  child: Center(child: Text('There are no specialists'))),
            if (store!.doctors.isNotEmpty)
              SliverToBoxAdapter(
                child: CardWidget(
                    elevation: 0,
                    child: CustomScrollView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        slivers: [
                          PaginatedLoadingWidget(
                            isFewLists: true,
                            store: store!,
                            listData: () {
                              return store!.doctors;
                            },
                            // separator: (_, __) => separator,
                            itemBuilder: (context, item, _) {
                              return PersonItem(
                                person: item,
                                store: store,
                              );
                            },
                          ),
                        ])),
              )
          ],
        );
      },
    );
  }
}
