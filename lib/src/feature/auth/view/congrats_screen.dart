import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class CongratsScreen extends StatelessWidget {
  const CongratsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthStore store = context.watch<AuthStore>();
    final VerifyStore verifyStore = context.watch<VerifyStore>();

    return ReactionBuilder(
        builder: (context) {
          return reaction((_) => store.status.value, (v) async {
            if (store.isAuthorized && verifyStore.isRegistered) {
              router.pushReplacementNamed(AppViews.homeScreen);
            }
          });
        },
        child: Scaffold(
          body: BodyDecoration(
            backgroundImage: DecorationImage(
              image: AssetImage(
                Assets.images.authDecor.path,
              ),
              alignment: Alignment.topLeft,
            ),
            child: Column(
              children: [
                const Spacer(
                  flex: 2,
                ),
                const CongratsBodyWidget(),
                const Spacer(),
                CustomButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  isSmall: false,
                  title: t.register.letsStart,
                  onTap: () {
                    context.pushReplacementNamed(AppViews.registerFillName);
                  },
                ),
                120.h,
              ],
            ),
          ),
        ));
  }
}
