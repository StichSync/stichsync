import 'package:stichsync/shared/models/db/dtos/yarn_attribute.dart';

class ProjectYarn {
  late final String id;
  late String title;

  // todo: in future we will add brand related parameters here

  // virtual
  late List<YarnAttribute> attributes;

  // foreign keys
  late String projectId;
}
