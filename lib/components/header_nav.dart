import 'package:flutter/material.dart';

class HeaderNav extends AppBar {
  HeaderNav({super.key, required BuildContext context, required String title})
      : super(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        );
}
