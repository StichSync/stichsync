import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stichsync/shared/models/crochet_model.dart';
import 'package:stichsync/shared/models/db/dtos/project.dart';
import 'package:stichsync/shared/models/db/dtos/project_section.dart';
import 'package:stichsync/shared/models/db/dtos/project_yarn.dart';
import 'package:stichsync/shared/models/db/dtos/project_tool.dart';
import 'package:stichsync/shared/models/db/dtos/yarn_attribute.dart';
import 'package:stichsync/shared/models/db/enums/attribute_parameter.dart';
import 'package:stichsync/shared/models/db/enums/attribute_unit.dart';
import 'package:stichsync/shared/models/db/enums/tool.dart';
import 'package:stichsync/shared/services/account_service.dart';
import 'package:stichsync/shared/services/router/router.dart';
import 'package:stichsync/views/home/inspirations/components/inspiration_post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProjectService {
  late final SupabaseClient supabase;
  final accountService = GetIt.I<AccountService>();

  ProjectService() {
    supabase = Supabase.instance.client;
  }

  Future<CrochetModel?> getNewestProject() async {
    try {
      var data = await supabase
          .from("Project")
          .select()
          .match({'softDeleted': false, "userId": accountService.getUserId()})
          .order('createdAt', ascending: false)
          .limit(1);
      if (data.isNotEmpty) {
        var username = await supabase.from("UserProfile").select().match({"userId": accountService.getUserId()});
        CrochetModel crochet = CrochetModel(
            id: data[0]["id"],
            createdAt: DateTime.parse(data[0]["createdAt"]),
            name: data[0]["title"],
            description: data[0]["description"],
            mediaUrl: "https://placehold.co/600x400/png",
            upvoteCount: 0,
            downvoteCount: 0,
            saveCount: 0,
            authorNickname: username[0]["username"]);
        return crochet;
      }
      return null;
    } on Exception {
      return null;
    }
  }

  Future<List<GestureDetector>?> getUserProject(String id) async {
    try {
      var data = await supabase
          .from("Project")
          .select()
          .match({'softDeleted': false, "userId": id}).order('createdAt', ascending: false);
      if (data.isNotEmpty) {
        List<GestureDetector> list = [];
        var username = await supabase.from("UserProfile").select().match({"userId": accountService.getUserId()});
        for (var i = 0; i < data.length; i++) {
          CrochetModel crochet = CrochetModel(
              id: data[i]["id"],
              createdAt: DateTime.parse(data[i]["createdAt"]),
              name: data[i]["title"],
              description: data[i]["description"],
              mediaUrl: "https://placehold.co/600x400/png",
              upvoteCount: 0,
              downvoteCount: 0,
              saveCount: 0,
              authorNickname: username[0]["username"]);
          list.add(
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => router.go('/project/${crochet.id}'),
              child: InspirationPost(crochet: crochet),
            ),
          );
        }
        return list;
      }
      return null;
    } on Exception {
      return null;
    }
  }

  Future<String> addProject() async {
    try {
      List<Map<String, dynamic>> project = await supabase.from('Project').insert({
        'title': "Untitled",
        'description': "",
        'userId': accountService.getUserId(),
      }).select();
      return project[0]["id"];
    } catch (e) {
      return "";
    }
  }

  Future<String> saveProject(Project projectData, String id) async {
    try {
      List<Map<String, dynamic>> project =
          await supabase.from('Project').select().match({'id': id, "softDeleted": false});
      if (project[0]["title"] != projectData.title || project[0]["description"] != projectData.description) {
        await supabase
            .from('Project')
            .update({'title': projectData.title, "description": projectData.description}).match(
          {'id': id},
        );
      }

      List<Map<String, dynamic>> sections = await supabase
          .from('ProjectSection')
          .select()
          .match({'projectId': id, "softDeleted": false}).order('index', ascending: true);
      for (var i = 0; i < projectData.sections.length; i++) {
        if (sections.length > i) {
          if (projectData.sections[i].title != sections[i]["title"]) {
            await supabase.from('ProjectSection').update({'title': projectData.sections[i].title}).match(
              {'projectId': id, "index": sections[i]["index"]},
            );
          }
        } else {
          await supabase.from('ProjectSection').insert({
            'title': projectData.sections[i].title,
            'projectId': id,
            'userId': accountService.getUserId(),
            'index': i
          });
        }
      }
      if (sections.length > projectData.sections.length) {
        for (var i = projectData.sections.length; i < sections.length; i++) {
          await supabase.from('ProjectSection').update({'softDeleted': true}).match(
            {'projectId': id, "index": sections[i]["index"]},
          );
        }
      }

      List<Map<String, dynamic>> tools = await supabase
          .from('ProjectTool')
          .select()
          .match({'projectId': id, "softDeleted": false}).order('index', ascending: true);
      for (var i = 0; i < projectData.tools.length; i++) {
        if (tools.length > i) {
          if (projectData.tools[i].tool.toString().split(".")[1] != tools[i]["tool"]) {
            await supabase.from('ProjectTool').update({
              'tool': projectData.tools[i].tool,
              "size": projectData.tools[i].size,
              "unit": projectData.tools[i].unit,
              "parameter": projectData.tools[i].parameter
            }).match(
              {'projectId': id, "index": tools[i]["index"]},
            );
          }
        } else {
          await supabase.from('ProjectTool').insert({
            'tool': projectData.tools[i].tool.toString().split(".")[1],
            "size": projectData.tools[i].tool == Tool.scissors ? null : projectData.tools[i].size,
            "parameter": projectData.tools[i].tool == Tool.scissors
                ? null
                : projectData.tools[i].parameter.toString().split(".")[1],
            "unit":
                projectData.tools[i].tool == Tool.scissors ? null : projectData.tools[i].unit.toString().split(".")[1],
            'projectId': id,
            'userId': accountService.getUserId(),
            'index': i
          });
        }
      }
      if (tools.length > projectData.tools.length) {
        for (var i = projectData.tools.length; i < tools.length; i++) {
          await supabase.from('ProjectTool').update({'softDeleted': true}).match(
            {'projectId': id, "index": tools[i]["index"]},
          );
        }
      }

      List<Map<String, dynamic>> yarns = await supabase
          .from('ProjectYarn')
          .select()
          .match({'projectId': id, "softDeleted": false}).order('index', ascending: true);
      for (var i = 0; i < projectData.yarn.length; i++) {
        if (yarns.length > i) {
          if (projectData.yarn[i].title != yarns[i]["title"]) {
            await supabase.from('ProjectYarn').update({'title': projectData.yarn[i].title}).match(
              {'projectId': id, "index": yarns[i]["index"]},
            );
          }
          List<Map<String, dynamic>> yarnAttributes = await supabase
              .from('YarnAttribute')
              .select()
              .match({'projectYarnId': yarns[i]["id"], "softDeleted": false}).order('index', ascending: true);
          for (var j = 0; j < projectData.yarn[i].attributes.length; j++) {
            if (yarnAttributes.length > j) {
              if (projectData.yarn[i].attributes[j].parameter.toString().split(".")[1] !=
                      yarnAttributes[j]["parameter"] ||
                  projectData.yarn[i].attributes[j].quantity != yarnAttributes[j]["quantity"] ||
                  projectData.yarn[i].attributes[j].unit.toString().split(".")[1] != yarnAttributes[j]["unit"]) {
                await supabase.from('YarnAttribute').update({
                  'parameter': projectData.yarn[i].attributes[j].parameter.toString().split(".")[1],
                  "quantity": projectData.yarn[i].attributes[j].quantity,
                  "unit": projectData.yarn[i].attributes[j].unit.toString().split(".")[1],
                }).match(
                  {'projectYarnId': yarns[i]["id"], "index": yarnAttributes[j]["index"]},
                );
              }
            } else {
              await supabase.from('YarnAttribute').insert({
                'parameter': projectData.yarn[i].attributes[j].parameter.toString().split(".")[1],
                "quantity": projectData.yarn[i].attributes[j].quantity,
                "unit": projectData.yarn[i].attributes[j].unit.toString().split(".")[1],
                'projectYarnId': yarns[i]["id"],
                'userId': accountService.getUserId(),
                'index': j
              });
            }
          }
          if (yarnAttributes.length > projectData.yarn[i].attributes.length) {
            for (var j = projectData.yarn[i].attributes.length; j < yarnAttributes.length; j++) {
              await supabase.from('YarnAttribute').update({'softDeleted': true}).match(
                {'projectYarnId': yarns[i]["id"], "index": yarnAttributes[j]["index"]},
              );
            }
          }
        } else {
          List<Map<String, dynamic>> newYarn = await supabase.from('ProjectYarn').insert({
            'title': projectData.yarn[i].title,
            'projectId': id,
            'userId': accountService.getUserId(),
            'index': i
          }).select();
          for (var j = 0; j < projectData.yarn[i].attributes.length; j++) {
            await supabase.from('YarnAttribute').insert({
              'parameter': projectData.yarn[i].attributes[j].parameter.toString().split(".")[1],
              "quantity": projectData.yarn[i].attributes[j].quantity,
              "unit": projectData.yarn[i].attributes[j].unit.toString().split(".")[1],
              'projectYarnId': newYarn[0]["id"],
              'userId': accountService.getUserId(),
              'index': j
            });
          }
        }
      }
      if (yarns.length > projectData.yarn.length) {
        for (var i = projectData.yarn.length; i < yarns.length; i++) {
          await supabase
              .from('ProjectYarn')
              .update({"softDeleted": true}).match({'projectId': id, "index": yarns[i]["index"]});
        }
      }
      return "";
    } on Exception {
      return "";
    }
  }

  Future<Project?> fetchProjectData(String id) async {
    try {
      List<Map<String, dynamic>> projectData =
          await supabase.from('Project').select().match({'id': id, 'softDeleted': false});
      List<Map<String, dynamic>> sectionData = await supabase
          .from('ProjectSection')
          .select()
          .match({'projectId': id, 'softDeleted': false}).order('index', ascending: true);
      List<Map<String, dynamic>> toolsData = await supabase
          .from('ProjectTool')
          .select()
          .match({'projectId': id, 'softDeleted': false}).order('index', ascending: true);
      List<Map<String, dynamic>> yarnsData = await supabase
          .from('ProjectYarn')
          .select()
          .match({'projectId': id, 'softDeleted': false}).order('index', ascending: true);
      Project project = Project();
      project.description = projectData[0]["description"];
      project.title = projectData[0]["title"];
      for (var i = 0; i < sectionData.length; i++) {
        project.sections = [...project.sections, ProjectSection()];
        project.sections[i].title = sectionData[i]["title"];
      }
      for (var i = 0; i < toolsData.length; i++) {
        project.tools = [...project.tools, ProjectTool()];
        project.tools[i].parameter = toolsData[i]["tool"] != "scissors"
            ? AttributeParameter.values
                .firstWhere((e) => e.toString() == 'AttributeParameter.${toolsData[i]["parameter"]}')
            : null;
        project.tools[i].tool = Tool.values.firstWhere((e) => e.toString() == 'Tool.${toolsData[i]["tool"]}');
        project.tools[i].size = toolsData[i]["tool"] != "scissors" ? toolsData[i]["size"] : null;
        project.tools[i].unit = toolsData[i]["tool"] != "scissors"
            ? AttributeUnit.values.firstWhere((e) => e.toString() == 'AttributeUnit.${toolsData[i]["unit"]}')
            : null;
      }
      for (var i = 0; i < yarnsData.length; i++) {
        project.yarn = [...project.yarn, ProjectYarn()];
        project.yarn[i].title = yarnsData[i]["title"];
        List<Map<String, dynamic>> yarnAttributes = await supabase
            .from('YarnAttribute')
            .select()
            .match({'projectYarnId': yarnsData[i]["id"], 'softDeleted': false}).order('index', ascending: true);
        for (var j = 0; j < yarnAttributes.length; j++) {
          project.yarn[i].attributes = [...project.yarn[i].attributes, YarnAttribute()];
          project.yarn[i].attributes[j].parameter = AttributeParameter.values
              .firstWhere((e) => e.toString() == 'AttributeParameter.${yarnAttributes[j]["parameter"]}');
          project.yarn[i].attributes[j].unit =
              AttributeUnit.values.firstWhere((e) => e.toString() == 'AttributeUnit.${yarnAttributes[j]["unit"]}');
          project.yarn[i].attributes[j].quantity = yarnAttributes[j]["quantity"];
        }
      }
      return project;
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

  // Rest of the code is left for now, will need it in the future.

  // Future<String> setProjectImage(File file, String id) async {
  //   try {
  //     var userId = accountService.getUserId();
  //     if (!kIsWeb) {
  //       await supabase.storage.from('media').update(
  //             '$userId/projects/$id.jpg',
  //             file,
  //             fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
  //           );
  //     } else {
  //       XFile xFile = XFile(file.path);
  //       await supabase.storage.from('media').updateBinary(
  //             '$userId/projects/$id.jpg',
  //             await xFile.readAsBytes(),
  //             fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
  //           );
  //     }
  //     await supabase.from('Project').update({
  //       'mediaUrls': 'https://iaxqejougvvfhxqhpmre.supabase.co/storage/v1/object/public/media/$userId/projects/$id.jpg'
  //     }).match({'id': id}).select();
  //     return "https://iaxqejougvvfhxqhpmre.supabase.co/storage/v1/object/public/media/$userId/projects/$id.jpg";
  //   } on StorageException {
  //     try {
  //       var userId = accountService.getUserId();
  //       if (!kIsWeb) {
  //         await supabase.storage.from('media').upload(
  //               '$userId/projects/$id.jpg',
  //               file,
  //               fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
  //             );
  //       } else {
  //         XFile xFile = XFile(file.path);
  //         await supabase.storage.from('media').uploadBinary(
  //               '$userId/projects/$id.jpg',
  //               await xFile.readAsBytes(),
  //               fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
  //             );
  //       }
  //       await supabase.from('Project').update({
  //         'mediaUrls':
  //             'https://iaxqejougvvfhxqhpmre.supabase.co/storage/v1/object/public/media/$userId/projects/$id.jpg'
  //       }).match({'id': id}).select();
  //       return "https://iaxqejougvvfhxqhpmre.supabase.co/storage/v1/object/public/media/$userId/projects/$id.jpg";
  //     } catch (e) {
  //       return "";
  //     }
  //   }
  // }
}
