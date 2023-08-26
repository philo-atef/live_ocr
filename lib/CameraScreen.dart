// ignore_for_file: import_of_legacy_library_into_null_safe
//flutter run --no-sound-null-safety
import 'dart:async';
import 'dart:io';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opencv_4/factory/colorspace/cvtcolor_factory.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:opencv/core/core.dart';
import 'package:opencv/core/imgproc.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv/core/core.dart';

import 'package:opencv_4/opencv_4.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:opencv/core/core.dart';
import 'package:opencv/core/imgproc.dart';
import 'package:opencv/opencv.dart';

import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

// Future<ui.Image> _convertImage(Mat mat) async {
//   List<int> bytes = await ImgProc.imencode('.png', mat);
//   ui.Codec codec = await ui.instantiateImageCodec(bytes);
//   ui.FrameInfo frameInfo = await codec.getNextFrame();
//   return frameInfo.image;
// }

class CameraScreen extends StatefulWidget {
const CameraScreen({Key? key}) : super(key: key);

@override
_CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
late CameraController _cameraController;
late Future<void> _initializeControllerFuture;
late int _imageCount;
late String _imagePath;
late String _directoryPath;

@override
void initState() {
super.initState();
SystemChrome.setPreferredOrientations([
DeviceOrientation.landscapeLeft,
DeviceOrientation.landscapeRight,
]);
_imageCount = 1;
_directoryPath = "";
_imagePath = "";
_setupCamera();
}
Uint8List convert1To3Channels(Uint8List originalData) {
  final int numPixels = originalData.length;
  final int numChannels = 3;
  final int newLength = numPixels * numChannels;

  final Uint8List newData = Uint8List(newLength);

  for (int i = 0; i < newLength; i += numChannels) {
    final int value = originalData[i ~/ numChannels];
    newData[i] = value;
    newData[i + 1] = value;
    newData[i + 2] = value;
  }

  return newData;
}
final TextRecognizer _textRecognizer =
      TextRecognizer( );
      
        bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String _text="";
   Future<void> processImage(InputImage inputImage) async {

    
    setState(() {
      _text = '';
    });
    final recognizedText = await _textRecognizer.processImage(inputImage).then((value) {
      _text=value.text;
      print(value.blocks[0].lines[0].recognizedLanguages);
      print("ww");
      print(value.blocks[0].lines[0]);
       print(value.text+" ocrReading");
    });

        if (mounted) {
      setState(() {});
    }
  }
var loaded=false;
late Uint8List pngBytes;
// Future<void> processImage2(XFile xFile) async {

//   var file=await File(xFile!.path).readAsBytes();
//           await  ImgProc.medianBlur(file , 9).then((value) async { 
//                  await  ImgProc.adaptiveThreshold(value, 255,ImgProc.adaptiveThreshGaussianC, ImgProc.threshBinary,  11, 2).then((value2) async { 

//                                          var _imagePath2 = '$_directoryPath/imgTemp$_imageCount.jpg';
//                   File x =await File(_imagePath2).writeAsBytes(value2) ;    
//                await ImgProc.dilate(value2, [1, 1]).then((value3)  async {
      
//                  print(value2.first.toString()+ " element");
          
//                  var dil = await ImgProc.erode(value3, [3, 3]);
//                  pngBytes= await  ImgProc.medianBlur(dil , 9);
//                  pngBytes=file;
//                   }); }); 
                
//                 });     
//           // pngBytes=value;
//         loaded = true;
//     //         final ui.Image result = await Future<ui.Image>.value(value);
//     //  value.toByteData(format: ui.ImageByteFormat.png) as Uint8List?;
      


//     //         ByteData byteData =  imageNew.toByteData(format: ui.ImageByteFormat.png) as ByteData;
//     // pngBytes = byteData.buffer.asUint8List() ;
//   // Save the byte list to a file

      
          

//   // Convert images to ui.Image
//   // return [
//   //   await _convertImage(final1),
//   //   await _convertImage(final2),
//   //   await _convertImage(final3),
//   // ];

// }
Future<void> processImage3(XFile xFile) async {
  var file=await File(xFile!.path).readAsBytes();
  loaded = true;
  pngBytes=file;
}
var initialized=false;
Future<void> _setupCamera() async {
final cameras = await availableCameras();
final firstCamera = cameras.first;_cameraController = CameraController(
  firstCamera,
  ResolutionPreset.max,
);

_initializeControllerFuture = _cameraController.initialize();

await _initializeControllerFuture;

setState(() { initialized=true;});

final directory = await getExternalStorageDirectory();
if (directory != null) {
  _directoryPath = "${directory.path}/ocr";
  await Directory(_directoryPath).create(recursive: true);
}

Timer.periodic(Duration(milliseconds: 500), (timer) async {
  if (!_cameraController.value.isInitialized) {
    return;
  }

  try {
    final image = await _cameraController.takePicture();
processImage3(image).then((value) async {    if(loaded){

    _imagePath = '$_directoryPath/img$_imageCount.jpg';

    await File(_imagePath).writeAsBytes(pngBytes).then((value) => print(_imagePath));
    
    var _imagePath2 = '$_directoryPath/imgcrop$_imageCount.jpg';
var cropped=await _resizePhoto(_imagePath);
var file=await File(cropped).readAsBytes();
    await File(_imagePath2).writeAsBytes(file).then((value) => print(_imagePath));

print("picHere");
// var c=await FlutterTesseractOcr.getTessdataPath();
//   final folder = Directory(c);

//   folder.list(recursive: true).forEach((entity) {
//     if (entity is File) {
//       print(entity.path);
//     }
//   });
// print(c+"ppppp");
    // var _ocrText = await FlutterTesseractOcr.extractText(_imagePath, language: "Segemnt2",       args: {
    //       "psm": "6"});
    // print(_ocrText+" OCRZZZZ");
    final inputImage = InputImage.fromFilePath(_imagePath2);
    await processImage(inputImage);

    setState(() {});

    _imageCount++;}});

  } catch (e) {
    print(e.toString()+"readError");
  }
});
}

@override
void dispose() {
      _canProcess = false;
    _textRecognizer.close();
_cameraController.dispose();
SystemChrome.setPreferredOrientations([
DeviceOrientation.portraitUp,
DeviceOrientation.portraitDown,
]);
super.dispose();
}

@override
Widget build(BuildContext context) {
final size = MediaQuery.of(context).size;
final deviceRatio = size.width / size.height;
return initialized? Stack(
  children: [
    Container(child:
    AspectRatio(
      aspectRatio: _cameraController.value.aspectRatio,
      child: CameraPreview(_cameraController),
    )),
    Positioned(
      top: size.height * 0.25,
      left: size.width * 0.21,
      width: size.width * 0.5*0.8,
      height: size.height * 0.5,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 4),
        ),
      ),
    ),
          Positioned(
            bottom: 10,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.16,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                _text,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),

],
):Container();
}


  Future<String> _resizePhoto(String filePath) async {
      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(filePath);

      int? width = properties.width;
      var offset = (properties.height! - properties.width!) / 2;

      File croppedFile = await FlutterNativeImage.cropImage(
          filePath, (width!/4).round(),(properties.height!/4).round(), (width!/2).round(), (properties.height!/2).round());

      return croppedFile.path;
  }
}