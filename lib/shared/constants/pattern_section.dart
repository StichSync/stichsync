import 'package:stichsync/shared/constants/attribute.dart';

class PatternSectionEnum {
  String name;
  String description;
  List<String> mediaUrl;
  List<AttributeClass> attributes;
  PatternSectionEnum(this.name, this.description, this.mediaUrl, this.attributes);
}

class DatabasePatternSectionEnum {
  String name;
  String description;
  List<String> mediaUrl;
  List<DatabaseAttributeClass> attributes;
  DatabasePatternSectionEnum(this.name, this.description, this.mediaUrl, this.attributes);
}
