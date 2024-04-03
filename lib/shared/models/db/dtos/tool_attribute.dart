import 'package:stichsync/shared/models/db/enums/attribute_unit.dart';
import 'package:stichsync/shared/models/db/enums/tool.dart';

class ToolAttribute {
  late final String id;
  late Tool tool;

  // null for tools for which attribute doesnt matter.
  // Example: scissors
  late double? size;
  late AttributeUnit? unit = AttributeUnit.millimeter;
  // ^ only size units, determined by users locale settings (mm for europeans, in for americans, etc)
  // for now lets have 'mm' as default

  // foreign keys
  late String projectToolId;
}
