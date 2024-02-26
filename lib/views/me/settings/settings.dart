import 'package:flutter/material.dart';
import 'package:stichsync/shared/components/require_authenticated.dart';

// this site will contain general app settings
// will also contain big sidebar with all settings subsites and/or
// small settings (eg dark mode switch)
class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return RequireAuthenticated(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 36,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: const Text(
            "Settings",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: Text("Settings"),
        ),
      ),
    );
  }
}
