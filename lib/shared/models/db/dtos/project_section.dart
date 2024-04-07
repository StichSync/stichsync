class ProjectSection {
  String id;
  String title;
  // todo: we will add a pattern PDF link or sth in the future

  // foreign keys
  String projectId;
  ProjectSection({required this.id, required this.title, required this.projectId});
}
