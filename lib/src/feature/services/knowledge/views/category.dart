import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => CategoriesStore(
        restClient: context.read<Dependencies>().restClient,
      ),
      builder: (context, child) {
        final CategoriesStore store = context.watch();

        return Scaffold(
          appBar: CustomAppBar(),
          body: _Body(store: store),
        );
      },
    );
  }
}

class _Body extends StatefulWidget {
  final CategoriesStore store;
  const _Body({required this.store});

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  void initState() {
    widget.store.loadPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedLoadingWidget(
      store: widget.store,
      itemBuilder: (context, item) {
        return Text(item.title);
      },
    );
  }
}
