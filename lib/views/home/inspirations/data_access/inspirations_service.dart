import 'package:stichsync/shared/models/crochet_model.dart';
import 'package:stichsync/views/home/inspirations/components/inspiration_post.dart';

class CrochetService {
  List<InspirationPost> getProjectsFromData(List<Map<String, dynamic>> data) {
    List<InspirationPost> crochets = [];

    for (int i = 0; i < data.length; i++) {
      CrochetModel crochet = CrochetModel(
        id: data[i]["id"],
        createdAt: DateTime.parse(data[i]["createdAt"]),
        name: data[i]["name"],
        description: data[i]["description"],
        mediaUrl: data[i]["mediaUrls"],
        upvoteCount: i * 3,
        downvoteCount: i * 2,
        saveCount: i,
        authorNickname: "Autor",
      );
      crochets.add(
        InspirationPost(crochet: crochet),
      );
    }

    return crochets;
  }
}
