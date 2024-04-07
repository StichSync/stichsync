import 'package:stichsync/shared/models/db/enums/attribute_parameter.dart';
import 'package:stichsync/shared/models/db/enums/attribute_unit.dart';

class YarnAttribute {
  final String id;

  AttributeParameter parameter; // eg: 'length'
  double quantity; // eg: 100
  AttributeUnit unit; // eg: meter

  // foreign keys
  String projectYarnId;

  YarnAttribute(
      {required this.id,
      required this.parameter,
      required this.quantity,
      required this.unit,
      required this.projectYarnId});
}
