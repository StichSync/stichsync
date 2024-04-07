import 'package:stichsync/shared/models/db/dtos/yarn_attribute.dart';

class ProjectYarn {
  String id;
  String title;

  // todo: in future we will add brand related parameters here

  // virtual
  List<YarnAttribute> attributes;

  // foreign keys
  String projectId;
  ProjectYarn({required this.id, required this.title, required this.projectId, required this.attributes});
}
