import 'package:stichsync/shared/models/db/enums/attribute_parameter.dart';
import 'package:stichsync/shared/models/db/enums/attribute_unit.dart';

class YarnAttribute {
  late final String id;

  late AttributeParameter parameter; // eg: 'length'
  late double quantity; // eg: 100
  late AttributeUnit unit; // eg: meter

  // foreign keys
  late String projectYarnId;
}
