// ignore: file_names
import 'dart:io';
import 'package:stichsync/shared/services/account_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageCRUD {
  late final SupabaseClient supabase;

  ImageCRUD() {
    supabase = Supabase.instance.client;
  }

  Future<bool> setAvatar(File avatarFile) async {
    try {
      var userId = AccountService().getUserId();
      await supabase.storage.from('avatars').update(
            '$userId/avatar.jpg',
            avatarFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      return true;
    } on StorageException {
      try {
        var userId = AccountService().getUserId();

        await supabase.storage.from('avatars').upload(
              '$userId/avatar.jpg',
              avatarFile,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
            );

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
