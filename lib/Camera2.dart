import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class Camera2 extends StatefulWidget {
  @override
  Camera2State createState() => Camera2State();
}

class Camera2State extends State<Camera2> {
  dynamic _scanResults;
  late CameraController _camera;
  var initialized=false;
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.back;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<CameraDescription> _getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
            (CameraDescription camera) => camera.lensDirection == dir,
          ),
    );
  }

  void _initializeCamera() async {
    _camera = CameraController(
      await _getCamera(_direction),
      defaultTargetPlatform == TargetPlatform.iOS
          ? ResolutionPreset.low
          : ResolutionPreset.veryHigh,
    );
    await _camera.initialize().then((value) => initialized=true);
    _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;
      _isDetecting = true;
      try {
        // await doSomethingWith(image)
        print(image.format);

      } catch (e) {
        // await handleExepction(e)
        print("EROOOOOOOOOOOR"+e.toString());
      } finally {
        _isDetecting = false;
      }
    });
  }
  Widget build(BuildContext context) {final size = MediaQuery.of(context).size;
final deviceRatio = size.width / size.height;
  return  initialized? Stack(
  children: [
    AspectRatio(
      aspectRatio: _camera.value.aspectRatio,
      child: CameraPreview(_camera),
    ),
    Positioned(
      top: size.height * 0.25,
      left: size.width * 0.25,
      width: size.width * 0.5,
      height: size.height * 0.5,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 4),
        ),
      ),
    ),
  ],
):Container();
  }
}