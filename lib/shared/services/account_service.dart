import 'dart:io';
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

  Future<void> getUserData() async {
    userData = await supabase
      .from('UserProfile')
      .select('username, email, picUrl')
      .eq('userId', userId);
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

  Future<void> setUsername(String username) async {
    await supabase
      .from('UserProfile')
      .update({ 'username': username })
      .match({ 'userId': userId });    
  }

  Future<void> setEmail(String email) async {
    await supabase.auth.updateUser(
      UserAttributes(
        email: email,
      ),
    );
  }

  Future<void> setAvatar(File avatarFile) async {
    await supabase.storage.from('avatars').update(
      '$userId/avatar.jpg',
      avatarFile,
      fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
    );
  }
}