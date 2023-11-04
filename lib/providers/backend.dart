import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/v4.dart';

final postDataToFireBase = FutureProvider.family(
  (
    ref,
    PostFile files,
  ) async {
    final database = FirebaseFirestore.instance.collection(
      "Global",
    );
    final storage = FirebaseStorage.instance.ref().child(
          files.image.name,
        );
    await storage.putFile(
      File(files.image.path),
    );
    final imageUrl = await storage.getDownloadURL();
    final id = const UuidV4().generate();
    await database.doc(id).set(
      {
        "id": id,
        "imageUrl": imageUrl,
        "imageName": files.image.name,
        "postedDate": Timestamp.now().toDate(),
        "description": files.description,
      },
    );
    return;
  },
);

class PostFile {
  PostFile({
    required this.image,
    required this.description,
  });
  final XFile image;
  final String description;
}

// final provider = StateNotifierProvider<Notifier, dynamic>(
//   (ref) {
//     return Notifier();
//   },
// );

// class Notifier extends StateNotifier<dynamic> {
//   Notifier() : super([]);
// }
final mediaPostProvider = StateNotifierProvider<MediaPostNotifier,
        List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
    (ref) => MediaPostNotifier());
CollectionReference<Map<String, dynamic>>? _content;
int _noOfPosts = 0;

class MediaPostNotifier
    extends StateNotifier<List<QueryDocumentSnapshot<Map<String, dynamic>>>> {
  MediaPostNotifier() : super([]);
  Future<List> getPosts() async {
    _noOfPosts = 5;
    _content = FirebaseFirestore.instance.collection("Global");
    final posts = await _content!
        .orderBy("imageName")
        .limit(
          _noOfPosts,
        )
        .get();
    posts.docs.shuffle();
    state = [...posts.docs];
    return state;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> newPosts() async {
    final posts = await _content!
        .orderBy("imageName")
        .limit(
          _noOfPosts += 5,
        )
        .get();
    final postTable = posts.docs;
    postTable.removeWhere(
      (element) => state.any((e) {
        if (element.data()["id"] == e.data()["id"]) {
          return true;
        }
        return false;
      }),
    );
    postTable.shuffle();
    state = [...state, ...postTable];
    return postTable;
  }
}

final unversityProvider = FutureProvider((ref) async {
  final universities = FirebaseFirestore.instance.collection("Universities");
  final university = await universities.get();
  return university.docs;
});

final addUserProfile =
    FutureProvider.family((ref, UserProfileInfo userDetails) async {
  final String userId = const UuidV4().generate();
  final profileStorage =
      FirebaseStorage.instance.ref("UserProfile").child(userId);
  try {
    await profileStorage.putData(userDetails.imageByte);
    final profileUrl = await profileStorage.getDownloadURL();
    await FirebaseFirestore.instance.collection("UserProfile").doc(userId).set({
      "id": userId,
      "name": userDetails.name,
      "college": userDetails.college,
      "tags": userDetails.tags,
      "profilePic": profileUrl,
    });
  } on FirebaseException {
    return false;
  }

  return true;
});

class UserProfileInfo {
  UserProfileInfo({
    required this.name,
    required this.college,
    required this.imageByte,
    required this.tags,
  });
  final Uint8List imageByte;
  final String name;
  final String college;
  final List<String> tags;
}
