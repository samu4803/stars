import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stars/essentials/nativecamera.dart';
import 'package:stars/models/postboc.dart';

class PostButton extends StatefulWidget {
  const PostButton({super.key});
  @override
  State<PostButton> createState() => _PostButtonState();
}

class _PostButtonState extends State<PostButton> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(eccentricity: 0.1),
        padding: (const EdgeInsets.only(right: 0)),
        alignment: Alignment.center,
        fixedSize: const Size.fromRadius(25),
      ),
      onPressed: () async {
        await showDialog(
            barrierColor: Colors.transparent,
            context: context,
            builder: (ctx) {
              return const Dialog(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                insetPadding:
                    EdgeInsets.only(left: 150, right: 150, bottom: 100),
                alignment: Alignment.bottomCenter,
                child: _PostOption(),
              );
            });
      },
      child: Icon(
        Icons.add,
        color: Theme.of(context).textTheme.displaySmall!.color,
      ),
    );
  }
}

class _PostOption extends StatelessWidget {
  const _PostOption();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      verticalDirection: VerticalDirection.up,
      children: [
        IconButton(
          onPressed: () async {
            //  Get an image from the Camera
            final image = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) {
                  return const NativeCamera();
                },
              ),
            );
            //  Post Menu
            _post(
                contentPost: image,
                parentContext: () {
                  return context;
                });
          },
          icon: Icon(
            FontAwesome5.camera,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        IconButton(
          onPressed: () async {
            // Get image from a file manager
            final FilePickerResult? nativeFolder =
                await FilePicker.platform.pickFiles(
              allowMultiple: false,
              type: FileType.media,
            );
            late final XFile? image;
            if (nativeFolder != null) {
              image = XFile(nativeFolder.files.first.path!);
            } else {
              image = null;
            }
            //  Post menu
            _post(
                contentPost: image,
                parentContext: () {
                  return context;
                });
          },
          icon: Icon(
            FontAwesome5.photo_video,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        IconButton(
          onPressed: null,
          icon: Icon(
            FontAwesome5.poll,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  void _post({
    required XFile? contentPost,
    required Function parentContext,
  }) {
    if (contentPost != null) {
      showDialog(
          barrierDismissible: false,
          context: parentContext(),
          builder: (ctx) {
            return PostBox(
                contentPost: contentPost, parentContext: parentContext);
          });
    }
  }
}
