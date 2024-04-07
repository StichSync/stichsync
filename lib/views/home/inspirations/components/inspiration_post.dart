import 'package:flutter/material.dart';
import 'package:stichsync/shared/models/crochet_model.dart';

class InspirationPost extends StatefulWidget {
  final CrochetModel crochet;

  const InspirationPost({super.key, required this.crochet});

  @override
  State<InspirationPost> createState() => _InspirationPostState();
}

class _InspirationPostState extends State<InspirationPost> {
  @override
  Widget build(BuildContext context) {
    double textSizeS = MediaQuery.of(context).size.width / 50;
    double textSizeM = MediaQuery.of(context).size.width / 40;
    double textSizeL = MediaQuery.of(context).size.width / 25;
    return GestureDetector(
      child: Wrap(
        children: [
          Card(
            margin: const EdgeInsets.only(
              top: 32.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Column(
              children: <Widget>[
                if (widget.crochet.mediaUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    child: Image.network(
                      widget.crochet.mediaUrl,
                      width: 600,
                      height: 260,
                      fit: BoxFit.cover,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.crochet.name,
                        style: TextStyle(fontSize: textSizeL),
                      ),
                      Text(
                        widget.crochet.description,
                        style: TextStyle(fontSize: textSizeM),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          const Icon(Icons.thumb_up),
                          Text('${widget.crochet.upvoteCount}', style: TextStyle(fontSize: textSizeM)),
                          const Icon(Icons.thumb_down),
                          Text('${widget.crochet.downvoteCount}', style: TextStyle(fontSize: textSizeM)),
                          const Icon(Icons.bookmark),
                          Text('${widget.crochet.saveCount}', style: TextStyle(fontSize: textSizeM)),
                        ],
                      ),
                      Text(
                        'Created by: ${widget.crochet.authorNickname}',
                        style: TextStyle(fontSize: textSizeS),
                      ),
                      Text(
                        'Date: ${widget.crochet.createdAt.toLocal()}',
                        style: TextStyle(fontSize: textSizeS),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
