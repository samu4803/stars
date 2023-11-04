import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class NativeCamera extends StatefulWidget {
  const NativeCamera({super.key});

  @override
  State<NativeCamera> createState() => _NativeCameraState();
}

class _NativeCameraState extends State<NativeCamera> {
  CameraController? controller;
  IconData flash = Icons.flash_on;
  IconData cam = Icons.camera_rear;
  List<CameraDescription>? cameraList;
  CameraDescription? activeCamera;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeCamera().then((value) {
      setState(() {});
    });
  }

  Future<void> initializeCamera() async {
    cameraList = await availableCameras();
    await checkCamera();
  }

  Future<void> checkCamera() async {
    if (activeCamera == null || activeCamera == cameraList!.last) {
      activeCamera = cameraList!.first;
      controller = CameraController(activeCamera!, ResolutionPreset.max);
    } else {
      activeCamera = cameraList!.last;
      controller = CameraController(activeCamera!, ResolutionPreset.max);
    }
    await controller?.initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return SafeArea(
        child: CameraPreview(
          controller!,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() {
                        if (flash == Icons.flash_on) {
                          flash = Icons.flash_off;
                          controller!.setFlashMode(FlashMode.off);
                        } else {
                          flash = Icons.flash_on;
                          controller!.setFlashMode(FlashMode.always);
                        }
                      }),
                      icon: Icon(
                        flash,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (cam == Icons.camera_rear) {
                          cam = Icons.camera_front;
                        } else {
                          cam = Icons.camera_rear;
                        }
                        await checkCamera();
                        setState(() {});
                      },
                      icon: Icon(
                        cam,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 50,
                  child: IconButton(
                    onPressed: () async => await controller!
                        .takePicture()
                        .then((value) => Navigator.of(context).pop(value)),
                    icon: const Icon(
                      size: 75,
                      Icons.camera,
                      color: Colors.white,
                    ),
                  ))
            ],
          ),
        ),
      );
    }
  }
}
