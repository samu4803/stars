import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stars/essentials/basicpairedwidgets.dart';
import 'package:stars/essentials/nativecamera.dart';
import 'package:stars/providers/backend.dart';

class AddProfile extends ConsumerStatefulWidget {
  const AddProfile({super.key});

  @override
  ConsumerState<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends ConsumerState<AddProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController collegeController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  Uint8List? profilePhoto;
  bool updating = false;

  Map<String, bool> favoriteTag = {
    "game": false,
    "music": false,
    "industry": false,
    "school": false,
    "college": false,
    "phone": false,
    "computer": false,
    "mobile": false,
    "sports": false,
    "nintendo": false,
  };
  Future<Uint8List> assetImage() async {
    final asset = await rootBundle.load("assets/defaultProfile.png");
    return asset.buffer.asUint8List();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    collegeController.dispose();
  }

  @override
  void initState() {
    super.initState();
    assetImage().then((value) {
      profilePhoto = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.transparent,
                        foregroundImage: profilePhoto == null
                            ? null
                            : MemoryImage(profilePhoto!),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              final image = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) {
                                    return const NativeCamera();
                                  },
                                ),
                              ) as XFile?;
                              if (image != null) {
                                profilePhoto = await image.readAsBytes();

                                setState(() {});
                              }
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              final image = await FilePicker.platform.pickFiles(
                                allowCompression: true,
                                allowMultiple: false,
                                type: FileType.image,
                              );
                              if (image != null) {
                                profilePhoto = image.files.first.bytes!;
                                setState(() {});
                              }
                            },
                            icon: const Icon(
                              Icons.photo,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BasicPairedWidgets.textFormFieldWithText(
                    context: context,
                    controller: nameController,
                    validator: (value) {
                      if (value == null) {
                        return "Enter a name";
                      } else if (value.contains(RegExp(r"[0-9]"))) {
                        return "Name should contain ateleast a character";
                      } else if (value.length <= 3) {
                        return "Name should be atleast 4 characters long";
                      }
                      return null;
                    },
                    text: "Name",
                    hint: "name",
                    border: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BasicPairedWidgets.textFormFieldWithText(
                    context: context,
                    controller: collegeController,
                    validator: (value) {
                      if (value == null) {
                        return "Enter your college name";
                      } else if (value.contains(RegExp(r"[0-9]"))) {
                        return "Name should contain only letters";
                      } else if (value.length <= 3) {
                        return "College name should be atleast 4 characters long";
                      }
                      return null;
                    },
                    text: "College",
                    hint: "college",
                    border: true,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tags",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runAlignment: WrapAlignment.start,
                      children: [
                        for (int i = 0; i < favoriteTag.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: RawChip(
                              showCheckmark: false,
                              selectedColor:
                                  Theme.of(context).colorScheme.secondary,
                              label: Text(
                                favoriteTag.keys.toList()[i],
                              ),
                              selected: favoriteTag.values.toList()[i],
                              onSelected: (value) => setState(() {
                                favoriteTag.update(
                                    favoriteTag.keys.toList()[i], (v) => value);
                              }),
                            ),
                          )
                      ],
                    ),
                  ],
                ),
                updating == true
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              updating = true;
                            });
                            final updated = await ref.watch(
                              addUserProfile(
                                UserProfileInfo(
                                  name: nameController.text,
                                  college: collegeController.text,
                                  imageByte: profilePhoto!,
                                  tags: favoriteTag.keys.toList().where(
                                    (element) {
                                      if (favoriteTag[element] == true) {
                                        return true;
                                      }
                                      return false;
                                    },
                                  ).toList(),
                                ),
                              ).future,
                            );
                            if (updated && mounted) {
                              Navigator.of(context).maybePop();
                            } else {
                              setState(() {
                                updating = false;
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Error"),
                                      content: const Text(
                                          "Somthing went wrong.Please try again."),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop,
                                          child: const Text("Okay"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });
                            }
                          }
                          setState(() {
                            updating = false;
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          "update",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
