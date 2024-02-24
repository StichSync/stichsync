import 'package:flutter/material.dart';
import 'package:stichsync/shared/models/crochet.dart';

class InspirationPost extends StatefulWidget {
  final Crochet crochet;

  const InspirationPost({super.key, required this.crochet});

  @override
  State<InspirationPost> createState() => _InspirationPostState();
}

class _InspirationPostState extends State<InspirationPost> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
                width: double.infinity,
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
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  widget.crochet.description,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Icon(Icons.thumb_up),
                    Text('${widget.crochet.upvoteCount}'),
                    const Icon(Icons.thumb_down),
                    Text('${widget.crochet.downvoteCount}'),
                    const Icon(Icons.bookmark),
                    Text('${widget.crochet.saveCount}'),
                  ],
                ),
                Text(
                  'Created by: ${widget.crochet.authorNickname}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'Date: ${widget.crochet.createdAt.toLocal()}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
