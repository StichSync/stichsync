enum AttributeType { thickness, length, width, size, weight, height }
enum WeightAttributeType { weight }
enum LengthAttributeType { thickness, length, width, size, height }

enum AttributeUnit { milligram, gram, kilogram, ounce, pound, milimeter, centimeter, meter, inch, foot, yard }
enum WeightUnit { gram, kilogram, ounce, pound }
enum LengthUnit { milimeter, centimeter, meter, inch, foot, yard }
enum ShortWeightUnit { g, kg, oz, lb }
enum ShortLengthUnit { mm, cm, m, inch, ft, yd }


class AttributeInput{
  AttributeType type;
  AttributeUnit unit;
  double quantity;
  AttributeInput(this.type, this.unit, this.quantity);
}
