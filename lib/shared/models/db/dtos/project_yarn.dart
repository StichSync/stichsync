import 'package:stichsync/shared/models/db/dtos/yarn_attribute.dart';

class ProjectYarn {
  String? id;
  DateTime? createdAt;
  String? title;

  // todo: in future we will add brand related parameters here

  // virtual
  List<YarnAttribute> attributes = List<YarnAttribute>.empty();

  // foreign keys
  String? projectId;
  String? userId;
}
