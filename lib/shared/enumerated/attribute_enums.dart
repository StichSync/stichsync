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

Map<AttributeUnit, ShortAttributeUnit> attributeUnitMap = {
  AttributeUnit.milimeter: ShortAttributeUnit.mm,
  AttributeUnit.centimeter: ShortAttributeUnit.cm,
  AttributeUnit.meter: ShortAttributeUnit.m,
  AttributeUnit.inch: ShortAttributeUnit.inch,
  AttributeUnit.foot: ShortAttributeUnit.ft,
  AttributeUnit.yard: ShortAttributeUnit.yd,
  AttributeUnit.gram: ShortAttributeUnit.g,
  AttributeUnit.kilogram: ShortAttributeUnit.kg,
  AttributeUnit.ounce: ShortAttributeUnit.oz,
  AttributeUnit.pound: ShortAttributeUnit.lb,
};

Map<String, String> stringAttributeUnitMap = {
  "milimeter": "mm",
  "centimeter": "cm",
  "meter": "m",
  "inch": "inch",
  "foot": "ft",
  "yard": "yd",
  "gram": "g",
  "kilogram": "kg",
  "ounce": "oz",
  "pound": "lb",
};

enum WeightUnit { gram, kilogram, ounce, pound }

enum ShortWeightUnit { g, kg, oz, lb }

enum LengthUnit { milimeter, centimeter, meter, inch, foot, yard }

enum ShortLengthUnit { mm, cm, m, inch, ft, yd }
