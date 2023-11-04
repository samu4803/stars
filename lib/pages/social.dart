import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stars/models/mediadescription.dart';
import 'package:stars/pages/search.dart';
import 'package:stars/providers/backend.dart';

late double _postWidth;

class Social extends ConsumerStatefulWidget {
  const Social({super.key});
  static const name = "Social";
  @override
  ConsumerState<Social> createState() => _SocialState();
}

class _SocialState extends ConsumerState<Social> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> totalPosts = [];

  final postController = ScrollController();
  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    postController.addListener(postListener);
  }

  void postListener() async {
    if (postController.position.pixels ==
        postController.position.maxScrollExtent) {
      final newPost = await ref.watch(mediaPostProvider.notifier).newPosts();
      if (newPost.isNotEmpty) {
        totalPosts = [...totalPosts, ...newPost];
        setState(() {});
      }
    }
  }

  Widget mediaShow() {
    return Scrollbar(
      child: ListView.builder(
        controller: postController,
        itemCount: totalPosts.length + 1,
        itemBuilder: (context, index) {
          if (index == totalPosts.length) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              Image.network(
                totalPosts[index].data()["imageUrl"],
                width: _postWidth,
                height: _postWidth,
                fit: BoxFit.fitWidth,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress?.expectedTotalBytes == null) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) {
                              return MediaDescription(
                                image: Image.network(
                                  totalPosts[index].data()["imageUrl"],
                                ),
                                description: totalPosts[index]
                                    .data()["description"]
                                    .toString(),
                              );
                            },
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          child,
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
                          const Divider(),
                        ],
                      ),
                    );
                  }
                  return SizedBox(
                      width: _postWidth,
                      height: _postWidth,
                      child: const Center(child: CircularProgressIndicator()));
                },
              ),
            ],
          );
        },
        key: const PageStorageKey(Key("Posts")),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _postWidth = MediaQuery.of(context).size.width;
    //flutter riverpo for more info
    final test = ref.watch(mediaPostProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CheckOut",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 25,
          ),
        ),
        titleTextStyle: Theme.of(context).textTheme.titleSmall,
        // backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Search(),
                )),
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("THere is technical error"),
            );
          }
          if (totalPosts.isEmpty) {
            totalPosts = snapshot.data
                as List<QueryDocumentSnapshot<Map<String, dynamic>>>;
          }
          return RefreshIndicator(
            onRefresh: () async {
              totalPosts.clear();
              ref.refresh(mediaPostProvider.notifier).getPosts();
              return Future.delayed(Duration.zero);
            },
            child: mediaShow(),
          );
        },
        future: totalPosts.isEmpty ? test.getPosts() : null,
      ),
    );
  }
}
