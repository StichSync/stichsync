import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/models/user_profile_model.dart';
import 'package:stichsync/shared/services/account_service.dart';
import 'package:stichsync/shared/components/horizontal_carousel.dart';
import 'package:stichsync/shared/components/editable_text_item.dart';
import 'package:stichsync/shared/components/editable_avatar.dart';
import 'package:stichsync/shared/components/image_picker_util.dart';
import 'package:stichsync/shared/components/text_edit_dialog.dart';
import 'package:stichsync/shared/components/toaster.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Me extends StatefulWidget {
  const Me({super.key});

  @override
  State<Me> createState() => _MeState();
}

class _MeState extends State<Me> {
  final accountService = GetIt.I<AccountService>();
  final _client = Supabase.instance.client.auth;

  late UserProfileModel userData;

  Future<void> updateUI() async {
    userData = await accountService.getUserData();
    setState(() {});
  }

  Future<void> updateAvatar() async {
    final avatarFile = await ImagePickerUtil.pickImageFromGallery();
    if (avatarFile != null) {
      var result = await accountService.setAvatar(avatarFile);
      if (result) {
        Toaster.toast(
          msg: "Avatar updated.",
          type: ToastType.success,
        );
        updateUI();
      } else {
        Toaster.toast(
          msg: "We couldn't update your avatar. Make sure you have stable internet connection and try again.",
          type: ToastType.error,
        );
      }
    } else {
      Toaster.toast(
        msg: "Operation cancelled.",
        type: ToastType.message,
      );
    }
  }

  Future<void> updateUsername() async {
    Future<String?> editedText = TextEditDialog(
      limit: 40,
      placeholder: userData.username ?? "",
      title: 'Update username',
    ).show(context);
    editedText.then((text) async {
      if (text != null) {
        var result = await accountService.setUsername(text);
        if (result) {
          Toaster.toast(
            msg: "Username updated",
            type: ToastType.success,
          );
          updateUI();
        } else {
          Toaster.toast(
            msg: "We couldn't update your username. Make sure you have stable internet connection and try again.",
            type: ToastType.error,
          );
        }
      }
    });
  }

  Future<void> updateEmail() async {
    Future<String?> editedText = TextEditDialog(
      limit: 40,
      placeholder: userData.email,
      title: 'Update email',
    ).show(context);
    editedText.then((text) async {
      if (text != null) {
        var result = await accountService.setEmail(text);
        if (result) {
          Toaster.toast(
            msg: "Check your inbox for the confirmation link.",
            type: ToastType.success,
          );
          updateUI();
        } else {
          Toaster.toast(
            msg: "We couldn't update your email. Make sure you have stable internet connection and try again.",
            type: ToastType.error,
          );
        }
      }
    });
  }

  Future<void> _logout() async {
    await _client.signOut();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<UserProfileModel> _getUserData() async {
    await Future.delayed(Durations.long1);
    return accountService.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: FutureBuilder<UserProfileModel>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            userData = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async {
                updateUI();
              },
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: EditableAvatar(
                        radius: 60,
                        imageUrl: userData.picUrl ?? "",
                        onPressed: () => updateAvatar(),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Username",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 64.0,
                      vertical: 8.0,
                    ),
                    child: EditableTextItem(
                      text: userData.username ?? "",
                      onPressed: () => updateUsername(),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "E-mail",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 64.0,
                      vertical: 8.0,
                    ),
                    child: EditableTextItem(
                      text: userData.email,
                      onPressed: () => updateEmail(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: Center(
                      child: Text(
                        "Your projects",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 4,
                    thickness: 2,
                    color: Colors.white,
                    endIndent: 100,
                    indent: 100,
                  ),
                  HorizCarousel(
                    items: userData.posts,
                    optionsOver: CarouselOptions(
                      enableInfiniteScroll: false,
                      initialPage: 1,
                      enlargeCenterPage: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: ElevatedButton(
                        onPressed: _logout,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 20,
                            ),
                            Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Text("Unhandled case");
          }
        },
      ),
    );
  }
}
