import 'package:flutter/material.dart';

class MediaDescription extends StatefulWidget {
  const MediaDescription({
    super.key,
    required this.image,
    required this.description,
  });
  final Image image;
  final String description;
  @override
  State<MediaDescription> createState() => _MediaDescriptionState();
}

class _MediaDescriptionState extends State<MediaDescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: widget.image,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.thumb_up),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.comment),
              ),
            ],
          ),
          Text(widget.description),
          Container(
            margin: const EdgeInsets.all(25),
            color: Colors.blue,
            child: const TextField(
              decoration: InputDecoration(labelText: "Comment"),
            ),
          ),
        ],
      ),
    );
  }
}
