import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stars/models/universityinfo.dart';
import 'package:stars/providers/backend.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});
  static const name = "search";
  @override
  ConsumerState<Search> createState() => _SocialState();
}

class _SocialState extends ConsumerState<Search> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? universities;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? searchedUniversities;
  Widget thisPage(List<QueryDocumentSnapshot<Map<String, dynamic>>>? data) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      itemBuilder: (ctx, index) {
        return Column(
          children: [
            Card(
              child: ListTile(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => UniversityInfo(
                      university: data[index].data(),
                    ),
                  ),
                ),
                title: Text(
                  data[index].data()["university"].toString(),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                leading: Image.network(
                  data[index].data()["image"],
                  cacheHeight: 35,
                  cacheWidth: 35,
                ),
              ),
            ),
          ],
        );
      },
      itemCount: data!.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ref.watch(unversityProvider).when(
        data: (data) {
          universities = data;
          return Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                    color: Colors.white),
                margin: const EdgeInsets.all(10),
                child: TextField(
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: "Search",
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    searchedUniversities = universities!.where((element) {
                      if (element.data()["university"].toString().startsWith(
                            RegExp(
                              value,
                              caseSensitive: false,
                              dotAll: true,
                            ),
                          )) {
                        return true;
                      }
                      return false;
                    }).toList();
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: searchedUniversities == null
                    ? thisPage(
                        universities,
                      )
                    : thisPage(
                        searchedUniversities,
                      ),
              ),
            ],
          );
        },
        error: (obj, stackTrace) {
          return const Center(
            child: Text("There is no internet"),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
