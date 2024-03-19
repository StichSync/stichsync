enum AttributeType { thickness, length, width, size, weight, height }

enum WeightAttributeType { weight }

enum LengthAttributeType { thickness, length, width, size, height }

enum AttributeUnit {
  milimeter,
  centimeter,
  meter,
  inch,
  foot,
  yard,
  gram,
  kilogram,
  ounce,
  pound,
}

enum ShortAttributeUnit { mm, cm, m, inch, ft, yd, g, kg, oz, lb }

enum WeightUnit { gram, kilogram, ounce, pound }

enum LengthUnit { milimeter, centimeter, meter, inch, foot, yard }

enum ShortWeightUnit { g, kg, oz, lb }

enum ShortLengthUnit { mm, cm, m, inch, ft, yd }

class AttributeEnum {
  AttributeType type;
  AttributeUnit unit;
  double quantity;
  AttributeEnum(this.type, this.unit, this.quantity);
}
