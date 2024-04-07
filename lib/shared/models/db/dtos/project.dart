import 'package:stichsync/shared/models/db/dtos/project_section.dart';
import 'package:stichsync/shared/models/db/dtos/project_tool.dart';
import 'package:stichsync/shared/models/db/dtos/project_yarn.dart';

// note:
// project is a data struct that saves knitting pattern and related metadata.
// project can be published as (todo: 'Post') ,
// then it becomes visible to the public and content recommendation logic vectors are applied
class Project {
  String id;
  // btw: all entities will have createdAt in database
  // adding it here since it is actually useful to be accessible in frontend
  DateTime createdAt;

  String title;
  String description;

  // virtual
  List<ProjectSection> sections;
  List<ProjectTool> tools;
  List<ProjectYarn> yarn;

  // foreign keys
  String userId; // author id
  Project(
      {required this.id,
      required this.createdAt,
      required this.title,
      required this.description,
      required this.sections,
      required this.tools,
      required this.yarn,
      required this.userId});
}
