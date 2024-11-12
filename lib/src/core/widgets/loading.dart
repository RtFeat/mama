import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class LoadingWidget<T> extends StatelessWidget {
  final ObservableFuture<T> future;

  final Widget Function(T) builder;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? emptyData;

  const LoadingWidget({
    super.key,
    required this.future,
    required this.builder,
    this.loadingWidget,
    this.errorWidget,
    this.emptyData,
  });

  @override
  Widget build(BuildContext context) {
    final Dependencies dependencies = context.watch<Dependencies>();

    return Observer(
      builder: (context) {
        switch (future.status) {
          case FutureStatus.pending:
            return loadingWidget ??
                const Center(
                  child: CircularProgressIndicator(),
                );
          case FutureStatus.rejected:
            return errorWidget ??
                Center(
                  child: FutureBuilder(
                      future: dependencies.tokenStorage.token,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          final OAuth2Token token =
                              snapshot.data as OAuth2Token;
                          return Text(
                              'Error loading.\nError: ${future.error} \nResult: ${future.result}\n Token: ${token.accessToken}\nRefresh: ${token.refreshToken}');
                        }

                        return const CircularProgressIndicator();
                      }),
                );
          case FutureStatus.fulfilled:
            final T data = future.value as T;

            if (data == null || (data is List && data.isEmpty)) {
              return emptyData ?? const SizedBox.shrink();
            }

            return builder(data);
        }
      },
    );
  }
}
