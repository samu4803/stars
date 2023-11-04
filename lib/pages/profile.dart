import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stars/models/addprofile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _SocialState();
}

class _SocialState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: const Text("SignOut"),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return const AddProfile();
                }));
              },
              child: const Text("profile"))
        ],
      ),
    );
  }
}
