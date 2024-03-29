import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stichsync/shared/components/toaster.dart';
import 'package:stichsync/shared/models/user_profile_model.dart';
import 'package:stichsync/views/home/inspirations/components/inspiration_post.dart';
import 'package:stichsync/views/home/inspirations/data_access/inspirations_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AccountService {
  late final SupabaseClient supabase;
  final crochetService = GetIt.instance.get<CrochetService>();

  AccountService() {
    supabase = Supabase.instance.client;
  }

  String getUserId() {
    return supabase.auth.currentUser?.id ?? '';
  }

  Future<String> getUserNameFromId(String id) async {
    var response = await supabase.from('userProfile').select('username').eq("Id", id);
    return response[0]["username"];
  }

  Future<UserProfileModel> getUserData() async {
    var userId = getUserId();
    var response = await supabase.from('UserProfile').select('username, email, picUrl').eq('userId', userId);
    var projects = crochetService.getProjectsFromData(await supabase.from('Project').select().eq('userId', userId));

    return UserProfileModel(
      email: response[0]["email"],
      username: response[0]["username"],
      picUrl: response[0]["picUrl"],
      posts: await projects,
    );
  }

  Future<bool> setUsername(String username) async {
    try {
      var userId = getUserId();
      await supabase.from('UserProfile').update({'username': username}).match({'userId': userId});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setEmail(String email) async {
    try {
      await supabase.auth.updateUser(
        UserAttributes(
          email: email,
        ),
      );
      return true;
    } catch (e) {
      Toaster.toast(
          msg: "We couldn't update your email. Make sure you have stable internet connection and try again.",
          type: ToastType.error);
      return false;
    }
  }

  Future<bool> setAvatar(File avatarFile) async {
    try {
      var userId = getUserId();
      if (!kIsWeb) {
        await supabase.storage.from('avatars').update(
              '$userId/avatar.jpg',
              avatarFile,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
            );
      } else {
        XFile file = XFile(avatarFile.path);
        await supabase.storage.from('avatars').updateBinary(
              '$userId/avatar.jpg',
              await file.readAsBytes(),
              fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
            );
      }
      await supabase.from('UserProfile').update({
        'picUrl': 'https://iaxqejougvvfhxqhpmre.supabase.co/storage/v1/object/public/avatars/$userId/avatar.jpg'
      }).match({'userId': userId});
      return true;
    } on StorageException {
      try {
        var userId = getUserId();

        if (!kIsWeb) {
          await supabase.storage.from('avatars').upload(
                '$userId/avatar.jpg',
                avatarFile,
                fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
              );
        } else {
          XFile file = XFile(avatarFile.path);
          await supabase.storage.from('avatars').uploadBinary(
                '$userId/avatar.jpg',
                await file.readAsBytes(),
                fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
              );
        }
        await supabase.from('UserProfile').update({
          'picUrl': 'https://iaxqejougvvfhxqhpmre.supabase.co/storage/v1/object/public/avatars/$userId/avatar.jpg'
        }).match({'userId': userId});
        return true;
      } catch (e) {
        return false;
      }
    }
  }
}
