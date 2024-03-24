import 'package:flutter/material.dart';
import 'package:stichsync/shared/services/router/router.dart';

class SsNavBackBtn extends StatelessWidget {
  const SsNavBackBtn({super.key});

  void goBack(BuildContext context) {
    // in case when there's nothing to pop and user is not in home page
    // *canPop - there is previous route in route historyu
    router.canPop() ? router.pop() : router.goNamed("home");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          semanticLabel: "back",
        ),
        onPressed: () => goBack(context),
      ),
    );
  }
}
