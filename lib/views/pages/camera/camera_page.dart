import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras;

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController controller;

  Future<void> prepareCamera() async {
    cameras = await availableCameras();

    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    prepareCamera();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
      ),
      body: !controller.value.isInitialized
          ? Container()
          : AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller)),
    );
  }
}
