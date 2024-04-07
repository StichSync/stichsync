import 'package:stichsync/shared/models/db/enums/attribute_parameter.dart';
import 'package:stichsync/shared/models/db/enums/attribute_unit.dart';

class YarnAttribute {
  String? id;
  DateTime? createdAt;

  AttributeParameter? parameter; // eg: 'length'
  double? quantity; // eg: 100
  AttributeUnit? unit; // eg: meter

  // foreign keys
  String? projectYarnId;
  String? userId;
}
