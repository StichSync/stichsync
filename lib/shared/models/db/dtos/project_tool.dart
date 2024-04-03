import 'package:stichsync/shared/models/db/dtos/tool_attribute.dart';

class ProjectTool {
  late final String id;
  late String title;

  // virtual
  late ToolAttribute? attribute;

  // foreign keys
  late String projectId;
}
