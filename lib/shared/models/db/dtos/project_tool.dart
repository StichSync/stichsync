import 'package:stichsync/shared/models/db/dtos/tool_attribute.dart';

class ProjectTool {
  String? id;
  DateTime? createdAt;

  String? title;

  // virtual
  ToolAttribute? attribute;

  // foreign keys
  String? projectId;
  String? userId;
}
