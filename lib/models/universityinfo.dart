import 'package:flutter/material.dart';

class UniversityInfo extends StatelessWidget {
  const UniversityInfo({
    super.key,
    required this.university,
  });
  final Map<String, dynamic> university;

  @override
  Widget build(BuildContext context) {
    Widget followButton() {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 25),
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            shape: MaterialStateProperty.all(LinearBorder.none),
          ),
          child: const Text("Follow"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(25),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 100,
                  child: Image.network(
                    university["image"],
                  ),
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                university["university"].toString(),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              followButton(),
            ],
          ),
        ),
      ),
    );
  }
}
