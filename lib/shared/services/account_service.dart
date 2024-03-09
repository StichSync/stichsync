import 'dart:io';
import 'package:stichsync/shared/components/toaster.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountService {
  late final SupabaseClient supabase;
  late final String userId;
  List<Map<String, dynamic>>? userData;

  AccountService() {
    supabase = Supabase.instance.client;
    userId = getUserId();
  }

  String getUserId() {
    return supabase.auth.currentUser?.id ?? '';
  }

  Future<bool> getUserData() async {
    try{
      userData = await supabase
        .from('UserProfile')
        .select('username, email, picUrl')
        .eq('userId', userId);
        return true;
        }
    catch (e) {
        return false;
    }
  }

  String getUsername() {
    return userData?[0]["username"] ?? '';
  }

  String getEmail() {
    return userData?[0]["email"] ?? '';
  }

  String getAvatarUrl() {
    return userData?[0]["picUrl"] ?? '';
  }

  Future<bool> setUsername(String username) async {
    try{
      await supabase
        .from('UserProfile')
        .update({ 'username': username })
        .match({ 'userId': userId });
        return true;
    }
    catch (e) {
        return false;
    }
  }

  Future<bool> setEmail(String email) async {
    try{
      await supabase.auth.updateUser(
        UserAttributes(
          email: email,
        ),
      );
      return true;
    }
    catch (e) {
        Toaster.toast(msg: "We couldn't update your email. Make sure you have stable internet connection and try again.", type: ToastType.error);
        return false;
    }
  }

  Future<bool> setAvatar(File avatarFile) async {
    try{
      await supabase.storage.from('avatars').update(
        '$userId/avatar.jpg',
        avatarFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );
      return true;
    }
    catch (e) {
        return false;
    }
  }
}