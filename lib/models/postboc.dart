import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stars/providers/backend.dart';

class PostBox extends ConsumerStatefulWidget {
  const PostBox({
    super.key,
    required this.contentPost,
    required this.parentContext,
  });
  final Function parentContext;
  final XFile? contentPost;
  @override
  ConsumerState<PostBox> createState() => _PostBocState();
}

class _PostBocState extends ConsumerState<PostBox> {
  final descriptionController = TextEditingController();
  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shadowColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.file(
            File(widget.contentPost!.path),
            height: 250,
            width: 250,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              ref.watch(
                postDataToFireBase(
                  PostFile(
                    image: widget.contentPost!,
                    description: descriptionController.text.toString(),
                  ),
                ),
              );
              Navigator.popUntil(
                  widget.parentContext(), (route) => route.isFirst);
            },
            child: const Text("Post"),
          ),
        ],
      ),
    );
  }
}
