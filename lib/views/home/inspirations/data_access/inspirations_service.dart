import 'package:stichsync/shared/models/crochet_model.dart';

class CrochetService {
  // returning mock crochets for now
  List<CrochetModel> get(int pageSize, int pageNumber) {
    List<CrochetModel> crochets = [];

    int startIndex = (pageNumber - 1) * pageSize;

    for (int i = startIndex; i < startIndex + pageSize; i++) {
      CrochetModel crochet = CrochetModel(
        id: 'id_$i',
        createdAt: DateTime.now().subtract(Duration(days: i * 2)),
        name: 'Crochet Name $i',
        description: 'Description for Crochet $i',
        mediaUrl: 'https://placehold.co/600x400/png',
        upvoteCount: i * 3,
        downvoteCount: i * 2,
        saveCount: i,
        authorNickname: 'Author $i',
      );
      crochets.add(crochet);
    }

    return crochets;
  }
}
