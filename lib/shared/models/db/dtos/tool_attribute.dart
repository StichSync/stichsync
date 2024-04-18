import 'package:stichsync/shared/models/db/enums/attribute_parameter.dart';
import 'package:stichsync/shared/models/db/enums/attribute_unit.dart';
import 'package:stichsync/shared/models/db/enums/tool.dart';

class ToolAttribute {
  String? id;
  DateTime? createdAt;
  Tool? tool;

  // null for tools for which attribute doesnt matter.
  // Example: scissors
  double? size;
  AttributeUnit? unit;
  AttributeParameter? parameter;
  // ^ only size units, determined by users locale settings (mm for europeans, in for americans, etc)
  // for now lets have 'mm' as default

  // foreign keys
  String? projectToolId;
  String? userId;
}
