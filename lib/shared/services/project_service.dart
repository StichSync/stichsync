import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stichsync/shared/constants/pattern_section.dart';
import 'package:stichsync/shared/services/account_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProjectService {
  late final SupabaseClient supabase;
  final accountService = GetIt.I<AccountService>();

  ProjectService() {
    supabase = Supabase.instance.client;
  }

  // Future<bool> addSection() async {
  //   try {
  //     var result = await supabase.from("Schema").insert({});
  //   } on StorageException {

  //   }
  // }

  Future<List<Map<String, dynamic>>?> getNewestProjects() async {
    try {
      var projects = await supabase.from('Project').select().order("createdAt", ascending: false).limit(6);
      return projects;
    } on Exception {
      return null;
    }
  }

  Future<String> addProject() async {
    try {
      List<Map<String, dynamic>> project = await supabase.from("Project").insert({
        'mediaUrls': "https://placehold.co/600x400/png",
        'name': "Untitled",
        'description': "Description",
        "userId": accountService.getUserId()
      }).select();

      return project[0]["id"];
    } on Exception {
      return "";
    }
  }

  Future<String> saveProject(List<DatabasePatternSectionEnum> projectList, String id) async {
    try {
      List<Map<String, dynamic>> schemas = await supabase.from('Schema').select().eq('projectId', id);
      schemas.sort((a, b) => a["index"].compareTo(b["index"]));
      List<String> updatedIds = [];
      for (var i = 0; i < projectList.length; i++) {
        List<String> updatedAttribIds = [];
        if (i < schemas.length) {
          await setSectionImage(File(projectList[i].mediaUrl[0]), schemas[i]["id"]);
          List<Map<String, dynamic>> attributes =
              await supabase.from('IngredientAttribute').select().eq('schemaId', schemas[i]["id"]);
          attributes.sort((a, b) => a["index"].compareTo(b["index"]));
          if (projectList[i].name != schemas[i]["name"] || projectList[i].description != schemas[i]["description"]) {
            var updated = await supabase.from('Schema').update({
              'name': projectList[i].name,
              'description': projectList[i].description,
            }).match({'projectId': id, 'index': schemas[i]["index"]}).select();
            updatedIds.add(updated[0]["id"]);
          }
          for (var j = 0; j < projectList[i].attributes.length; j++) {
            if (j < attributes.length) {
              if (projectList[i].attributes[j].quantity != attributes[j]["quantity"] ||
                  projectList[i].attributes[j].type != attributes[j]["type"] ||
                  projectList[i].attributes[j].unit != attributes[j]["unit"]) {
                var updatedAttrib = await supabase.from('IngredientAttribute').update({
                  'quantity': projectList[i].attributes[j].quantity,
                  'type': projectList[i].attributes[j].type,
                  'unit': projectList[i].attributes[j].unit,
                }).match({'schemaId': schemas[i]["id"], 'index': attributes[j]["index"]}).select();
                updatedAttribIds.add(updatedAttrib[0]["id"]);
              }
            } else {
              await supabase.from("IngredientAttribute").insert(
                {
                  "userId": accountService.getUserId(),
                  "schemaId": schemas[i]["id"],
                  'quantity': projectList[i].attributes[j].quantity,
                  'type': projectList[i].attributes[j].type,
                  'unit': projectList[i].attributes[j].unit,
                  "index": j
                },
              );
            }
            if (projectList[i].attributes.length < attributes.length) {
              for (var i = 0; i < attributes.length; i++) {
                {
                  if (!updatedAttribIds.contains(attributes[i]["id"])) {
                    await supabase.from('IngredientAttribute').delete().match({'id': attributes[i]["id"]});
                  }
                }
              }
            }
          }
        } else {
          var schema = await supabase.from("Schema").insert(
            {
              "userId": accountService.getUserId(),
              "projectId": id,
              "name": projectList[i].name,
              "mediaUrls": ["https://placehold.co/600x400/png"],
              "description": projectList[i].description,
              "index": i
            },
          ).select();
          for (var j = 0; j < projectList[i].attributes.length; j++) {
            await supabase.from("IngredientAttribute").insert(
              {
                "userId": accountService.getUserId(),
                "schemaId": schema[0]["id"],
                'quantity': projectList[i].attributes[j].quantity,
                'type': projectList[i].attributes[j].type,
                'unit': projectList[i].attributes[j].unit,
                "index": j
              },
            );
          }
        }
      }
      if (projectList.length < schemas.length) {
        for (var i = 0; i < schemas.length; i++) {
          {
            if (!updatedIds.contains(schemas[i]["id"])) {
              await supabase.from('Schema').delete().match({'id': schemas[i]["id"]});
            }
          }
        }
      }
      return "";
    } on Exception {
      return "";
    }
  }

  Future<List<Map<String, dynamic>>?> updateProject(String name, String description, String mediaUrl, String id) async {
    try {
      var updated = await supabase
          .from('Project')
          .update({'name': name, 'description': description, 'mediaUrls': mediaUrl}).match({'id': id}).select();
      return updated;
    } on Exception {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchProjectData(String id) async {
    try {
      List<Map<String, dynamic>> data = await supabase.from('Project').select().eq('id', id);
      return data;
    } on Exception {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getProject(String id) async {
    try {
      final data = await supabase.from("Project").select().eq('id', id);
      return data;
    } on Exception {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchSectionData(String id) async {
    try {
      final data = await supabase.from('Schema').select().eq('projectId', id);
      if (data.toString() == "[]") {
        List<Map<String, dynamic>> section = await supabase.from("Schema").insert({
          "userId": accountService.getUserId(),
          "projectId": id,
          "name": "Untitled",
          "mediaUrls": [
            "https://media.discordapp.net/attachments/873967772839837716/1221697234958155786/image-41.png?ex=66138536&is=66011036&hm=c3184f8bbb5b98115fe8aae3ad5c73966c87411c1e41852cc493dce1d5f4f48a&=&format=webp&quality=lossless"
          ],
          "description": "Description",
          "index": 0
        }).select();
        return section;
      } else {
        data.sort((a, b) => a["index"].compareTo(b["index"]));
        return data;
      }
    } on Exception {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchAttributeData(String id) async {
    try {
      final data = await supabase.from('IngredientAttribute').select().eq('schemaId', id);
      if (data.toString() == "[]") {
        List<Map<String, dynamic>> section = await supabase.from("IngredientAttribute").insert({
          "userId": accountService.getUserId(),
          "schemaId": id,
          "quantity": 0,
          "type": "thickness",
          "unit": "milimeter",
          "index": 0,
        }).select();
        return section;
      } else {
        data.sort((a, b) => a["index"].compareTo(b["index"]));
        return data;
      }
    } on Exception {
      return null;
    }
  }

  Future<String> setProjectImage(File file, String id) async {
    try {
      var userId = accountService.getUserId();
      if (!kIsWeb) {
        await supabase.storage.from('media').update(
              '$userId/projects/$id.jpg',
              file,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
            );
      } else {
        XFile xFile = XFile(file.path);
        await supabase.storage.from('media').updateBinary(
              '$userId/projects/$id.jpg',
              await xFile.readAsBytes(),
              fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
            );
      }
      await supabase.from('Project').update({
        'mediaUrls': 'https://iaxqejougvvfhxqhpmre.supabase.co/storage/v1/object/public/media/$userId/projects/$id.jpg'
      }).match({'id': id}).select();
      return "https://iaxqejougvvfhxqhpmre.supabase.co/storage/v1/object/public/media/$userId/projects/$id.jpg";
    } on StorageException {
      try {
        var userId = accountService.getUserId();
        if (!kIsWeb) {
          await supabase.storage.from('media').upload(
                '$userId/projects/$id.jpg',
                file,
                fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
              );
        } else {
          XFile xFile = XFile(file.path);
          await supabase.storage.from('media').uploadBinary(
                '$userId/projects/$id.jpg',
                await xFile.readAsBytes(),
                fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
              );
        }
        await supabase.from('Project').update({
          'mediaUrls':
              'https://iaxqejougvvfhxqhpmre.supabase.co/storage/v1/object/public/media/$userId/projects/$id.jpg'
        }).match({'id': id}).select();
        return "https://iaxqejougvvfhxqhpmre.supabase.co/storage/v1/object/public/media/$userId/projects/$id.jpg";
      } catch (e) {
        return "";
      }
    }
  }

  Future<String> setSectionImage(File file, String id) async {
    try {
      var userId = accountService.getUserId();
      if (!kIsWeb) {
        await supabase.storage.from('media').update(
              '$userId/patterns/$id.jpg',
              file,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
            );
      } else {
        XFile xFile = XFile(file.path);
        await supabase.storage.from('media').updateBinary(
              '$userId/patterns/$id.jpg',
              await xFile.readAsBytes(),
              fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
            );
      }
      return "https://iaxqejougvvfhxqhpmre.supabase.co/storage/v1/object/public/media/$userId/patterns/$id.jpg";
    } on StorageException {
      try {
        var userId = accountService.getUserId();
        if (!kIsWeb) {
          await supabase.storage.from('media').upload(
                '$userId/patterns/$id.jpg',
                file,
                fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
              );
        } else {
          XFile xFile = XFile(file.path);
          await supabase.storage.from('media').uploadBinary(
                '$userId/patterns/$id.jpg',
                await xFile.readAsBytes(),
                fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
              );
        }
        await supabase.from('Schema').update({
          'mediaUrls': [
            'https://iaxqejougvvfhxqhpmre.supabase.co/storage/v1/object/public/media/$userId/patterns/$id.jpg'
          ]
        }).match({'id': id}).select();
        return "https://iaxqejougvvfhxqhpmre.supabase.co/storage/v1/object/public/media/$userId/patterns/$id.jpg";
      } catch (e) {
        return "";
      }
    }
  }
}
