import 'dart:io';
import 'package:stichsync/shared/components/toaster.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountService {
  late final SupabaseClient supabase;

  AccountService() {
    supabase = Supabase.instance.client;
  }

  String getUserId() {
    return supabase.auth.currentUser?.id ?? '';
  }

  Future<Map<String, dynamic>> getUserData() async {
    try{
      var userId = getUserId();
      var response = await supabase
        .from('UserProfile')
        .select('username, email, picUrl')
        .eq('userId', userId);

        return {
          "username": response[0]["username"] ?? "",
          "email": response[0]["email"] ?? "",
          "picUrl": response[0]["picUrl"] ?? "",
          "error": false
          };
        }
    catch (e) {
        return {
          "username": "",
          "email": "",
          "picUrl": "",
          "error": true
        };
    }
  }

  Future<bool> setUsername(String username) async {
    try{
      var userId = getUserId();
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
      var userId = getUserId();
      await supabase.storage.from('avatars').update(
        '$userId/avatar.jpg',
        avatarFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );
      return true;
    }
    on StorageException {
      try{
        var userId = getUserId();

        await supabase.storage.from('avatars').upload(
          '$userId/avatar.jpg',
          avatarFile,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

        await supabase
        .from('UserProfile')
        .update({ 'picUrl': 'https://iaxqejougvvfhxqhpmre.supabase.co/storage/v1/object/public/avatars/$userId/avatar.jpg' })
        .match({ 'userId': userId });
        return true;
      }
      catch (e) {
          return false;
      }
    }
  }
}