import 'package:stichsync/shared/enumerated/attribute_enums.dart';

class AttributeClass {
  AttributeType type;
  AttributeUnit unit;
  double quantity;
  AttributeClass(this.type, this.unit, this.quantity);
}
