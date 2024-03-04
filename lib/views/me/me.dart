import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/components/require_authenticated.dart';
import 'package:stichsync/shared/services/auth_service.dart';
import 'package:stichsync/shared/components/horizontal_carousel.dart';
import 'package:stichsync/shared/components/editable_text_item.dart';
import 'package:stichsync/shared/components/editable_avatar.dart';

// this site will contain users account settings
class Me extends StatefulWidget {
  const Me({super.key});

  @override
  State<Me> createState() => _MeState();
}

class _MeState extends State<Me> {
  Future<void> _logout() async {
    final authService = GetIt.I<AuthService>();
    var result = await authService.logout();
    if (!context.mounted) return;
    if (result) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RequireAuthenticated(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          centerTitle: true,
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
            "Account",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: EditableAvatar(
                  imageUrl: "https://placehold.co/400x400/png",
                  onPressed: () => print("placeholder"),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
              child: EditableTextItem(
                text:  "Name",
                onPressed: () => print("placeholder"),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
              child: EditableTextItem(
                text:  "Email",
                onPressed: () => print("placeholder"),
              ),
            ),
            
            Center(
              child: ElevatedButton(
                onPressed: _logout,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 36,
                    ),
                    Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
