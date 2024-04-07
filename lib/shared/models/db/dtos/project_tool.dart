import 'package:stichsync/shared/models/db/dtos/tool_attribute.dart';

class ProjectTool {
  String id;
  String title;

  // virtual
  ToolAttribute? attribute;

  // foreign keys
  String projectId;
  ProjectTool({required this.id, required this.title, required this.projectId, this.attribute});
}
