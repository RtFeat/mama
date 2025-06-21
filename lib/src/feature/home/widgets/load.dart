import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class LoadHomeData extends StatefulWidget {
  final Widget child;
  final UserStore userStore;
  const LoadHomeData({
    super.key,
    required this.child,
    required this.userStore,
  });

  @override
  State<LoadHomeData> createState() => _LoadHomeDataState();
}

class _LoadHomeDataState extends State<LoadHomeData> {
  @override
  void initState() {
    widget.userStore.setUserData(null);
    widget.userStore.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingWidget(
        future: widget.userStore.fetchFuture,
        builder: (v) {
          return widget.child;
        },
      ),
    );
  }
}
