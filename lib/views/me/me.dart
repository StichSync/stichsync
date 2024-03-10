import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/components/require_authenticated.dart';
import 'package:stichsync/shared/services/auth_service.dart';
import 'package:stichsync/shared/services/account_service.dart';
import 'package:stichsync/shared/components/horizontal_carousel.dart';
import 'package:stichsync/shared/components/editable_text_item.dart';
import 'package:stichsync/shared/components/editable_avatar.dart';
import 'package:stichsync/shared/components/image_picker_util.dart';
import 'package:stichsync/shared/components/text_edit_dialog.dart';
import 'package:stichsync/shared/components/toaster.dart';
import 'package:stichsync/views/home/inspirations/components/inspiration_post.dart';
import 'package:stichsync/views/home/inspirations/data_access/inspirations_service.dart';

class Me extends StatefulWidget {
  const Me({super.key});

  @override
  State<Me> createState() => _MeState();
}

class _MeState extends State<Me> {
  File? avatarFile;
  late List<InspirationPost> items;
  late Map<String, dynamic> userData;

  final accountService = GetIt.I<AccountService>();
  final crochetService = GetIt.instance.get<CrochetService>();
  
  _MeState() {
    items = [];
  }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future<void> updateUI() async{
    getProfile();
    setState(() {});
  }

  Future<void> getProfile() async {
    userData = await accountService.getUserData();
    if(userData["error"]){
      Toaster.toast(msg: "We're having troubles obtaining your account data. Make sure you have stable internet connection and try again.", type: ToastType.error);
    }
    else{
      //placeholders for now
        items = [
        InspirationPost(crochet: crochetService.get(1, 1)[0]),
        InspirationPost(crochet: crochetService.get(1, 1)[0]),
        InspirationPost(crochet: crochetService.get(1, 1)[0]),  
      ];
    }
  }

  Future<void> updateAvatar() async {
    avatarFile = await ImagePickerUtil.pickImageFromGallery();
    if(avatarFile != null){
      var result = await accountService.setAvatar(avatarFile!);
      if(result){
        Toaster.toast(msg: "Avatar updated.", type: ToastType.success);
        updateUI();
      }
      else{
        Toaster.toast(msg: "We couldn't update your avatar. Make sure you have stable internet connection and try again.", type: ToastType.error);
      }
    }
    else{
      Toaster.toast(msg: "Operation cancelled.", type: ToastType.message);
    }
  }

  Future<void> updateUsername() async {
    Future<String?> editedText = TextEditDialog(limit: 40, placeholder: userData["username"], title: 'Update username').show(context);
    editedText.then((text) async {
      if (text != null) {
        var result = await accountService.setUsername(text);
        if(result){
          Toaster.toast(msg: "Username updated", type: ToastType.success);
          updateUI();
        }
        else{
          Toaster.toast(msg: "We couldn't update your username. Make sure you have stable internet connection and try again.", type: ToastType.error);
        }
      }
    });
  }

  Future<void> updateEmail() async {
    Future<String?> editedText = TextEditDialog(limit: 40, placeholder: userData["email"], title: 'Update email').show(context);
    editedText.then((text) async {
      if (text != null) {
        var result = await accountService.setEmail(text);
        if(result){
          Toaster.toast(msg: "Check your inbox for the confirmation link.", type: ToastType.success);
          updateUI();
        }
        else{
          Toaster.toast(msg: "We couldn't update your email. Make sure you have stable internet connection and try again.", type: ToastType.error);
        }
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
        body: RefreshIndicator(
          onRefresh: () async {updateUI();},
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: FutureBuilder<void>(
                  future: getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      return EditableAvatar(
                        radius: 60,
                          imageUrl: userData["picUrl"],
                          onPressed: () => updateAvatar(),
                        );
                    }
                  },
                )
                ),
              ),
          
              const Center(
                  child: Text(
                    "Username",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                  ),
                ),
          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 8.0),
                child: FutureBuilder<void>(
                  future: getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        width: 1,
                        height: 1,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return EditableTextItem(
                        text: userData["username"],
                        onPressed: () => updateUsername(),
                      );
                    }
                  },
                )
              ),
          
              const Center(
                  child: Text(
                    "E-mail",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                  ),
                ),
          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 8.0),
                child: FutureBuilder<void>(
                  future: getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      return EditableTextItem(
                        text: userData["email"],
                        onPressed: () => updateEmail(),
                      );
                    }
                  },
                )
              ),
          
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                    child: Text(
                      "Your projects",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
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
          
              FutureBuilder<void>(
                  future: getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      if(items.isEmpty){
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: ElevatedButton(
                                onPressed: () => print("placeholder"),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    Text(
                                      "Create project",
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
                        );
                      }
                      else{
                        return HorizCarousel(items: items, optionsOver: CarouselOptions(
                            enableInfiniteScroll: false,
                            initialPage: 1,
                            enlargeCenterPage: true,
                          ),
                        );                     
                      }
                    }
                  },
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
        ),
      ),
    );
  }
}
