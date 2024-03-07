import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/components/require_authenticated.dart';
import 'package:stichsync/shared/services/auth_service.dart';
import 'package:stichsync/shared/services/account_service.dart';
import 'package:stichsync/shared/components/horizontal_carousel.dart';
import 'package:stichsync/shared/components/editable_text_item.dart';
import 'package:stichsync/shared/components/editable_avatar.dart';
import 'package:stichsync/shared/components/image_picker_util.dart';
import 'package:stichsync/shared/components/text_edit_dialog.dart';

// this site will contain users account settings
class Me extends StatefulWidget {
  const Me({super.key});

  @override
  State<Me> createState() => _MeState();
}

class _MeState extends State<Me> {
  late AccountService accountService;
  late String username;
  late String email;
  late String avatarUrl;
  late File avatarFile;

  _MeState() {
    username = "";
    email = "";
    avatarUrl = "";
  }

  @override
  void initState() {
    super.initState();
    accountService = GetIt.I<AccountService>();
    getProfile();
    setState(() {
      
    });
  }

  Future<void> getProfile() async {
    await accountService.getUserData();
    avatarUrl = accountService.getAvatarUrl();
    username = accountService.getUsername();
    email = accountService.getEmail(); 
  }

  Future<void> updateAvatar() async {
    avatarFile = (await ImagePickerUtil.pickImageFromGallery())!;
    await accountService.setAvatar(avatarFile);
    getProfile();
  }

  Future<void> updateUsername() async {
    Future<String?> editedText = TextEditDialog(placeholder: username, title: 'Update username').show(context);
    editedText.then((text) async {
      if (text != null) {
        await accountService.setUsername(text);
      }
    });
  }

  Future<void> updateEmail() async {
    Future<String?> editedText = TextEditDialog(placeholder: email, title: 'Update email').show(context);
    editedText.then((text) async {
      if (text != null) {
        await accountService.setEmail(text);
      }
    });
  }

  Future<void> _logout() async {
    final authService = GetIt.I<AuthService>();
    var result = await authService.logout();
    if (!context.mounted) return;
    if (result) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/Authorization',
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
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: FutureBuilder<void>(
                future: getProfile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return EditableAvatar(
                        imageUrl: "https://placehold.co/400x400/png",
                        onPressed: () => print("placeholder"),
                      );
                  } else {
                    return EditableAvatar(
                        imageUrl: avatarUrl,
                        onPressed: () => updateAvatar(),
                      );
                  }
                },
              )
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
              child: FutureBuilder<void>(
                future: getProfile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return EditableTextItem(
                      text: "",
                      onPressed: () => print("placeholder"),
                    );
                  } else {
                    return EditableTextItem(
                      text: username,
                      onPressed: () => updateUsername(),
                    );
                  }
                },
              )
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
              child: FutureBuilder<void>(
                future: getProfile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return EditableTextItem(
                      text: "",
                      onPressed: () => print("placeholder"),
                    );
                  } else {
                    return EditableTextItem(
                      text: email,
                      onPressed: () => updateEmail(),
                    );
                  }
                },
              )
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
