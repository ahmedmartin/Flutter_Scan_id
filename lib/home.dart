import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
//import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan_id/text_model.dart';




class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }

}

class _Home extends State<Home>{

  File ?image;
  String ?text;
  bool wait = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50,),
            image!=null ? Image.file(image!,width: MediaQuery.of(context).size.width,height:MediaQuery.of(context).size.height/3 ,):Container(),
            wait?CircularProgressIndicator():Container(),
            SizedBox(height: 20,),
            text!=null ?Text(text!,style: TextStyle(fontSize: 20),):Container()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.photo_camera_outlined,color: Colors.white,size: 30,),
        backgroundColor: Colors.black,
        onPressed:(){
          picked_image();
        } ,
      ),
    );
  }

 Future picked_image()async{
    try {
      final photo = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (photo == null) return;
      //print(photo.path);
      File temp = File(photo.path);
      setState(() {
        image = temp;
      });
      // if we need get data from our phone photo
      //temp = (await testCompressAndGetFile(temp, temp.absolute.path+'.jpg'))!;
      print(await getFileSize(temp.path, 1));

      api_scantext(temp.path);
   //--------detect arabic but not power------------
   //  setState(() {
   //    text = '';
   //    wait=true;
   //  });
   //  String temp_text = await FlutterTesseractOcr.extractText(photo.path,language: 'ara',
   //      args: {
   //        "psm": "4",
   //        "preserve_interword_spaces": "1",
   //      });
   //  setState(() {
   //    text = temp_text;
   //    wait = false;
   //  });
   //-------------------------
    }on PlatformException catch(e){
      print(e.toString());
    }

   //plugin_scanText();
  }
   //------------detect english only---------------------------------
  // Future plugin_scanText() async {
  //
  //   setState(() {
  //     wait=true;
  //   });
  //
  //   final inputImage = InputImage.fromFile(image!);
  //   final textDetector = GoogleMlKit.vision.textDetector();
  //   final RecognisedText recognisedText = await textDetector.processImage(inputImage);
  //   String temp_text = '';//recognisedText.text;
  //
  //   for (TextBlock block in recognisedText.blocks) {
  //     for (TextLine line in block.lines) {
  //       for (TextElement element in line.elements) {
  //         temp_text+=' '+element.text;
  //       }
  //       temp_text+='\n';
  //     }
  //   }
  //   setState(() {
  //     text = temp_text;
  //     wait = false;
  //   });

// //---------------------------------------------------

    // final GoogleVisionImage visionImage = GoogleVisionImage.fromFile(image!);
    // final TextRecognizer textRecognizer = GoogleVision.instance.textRecognizer();
    // try {
    //   if(textRecognizer != null)
    //   final VisionText visionText = await textRecognizer.processImage(visionImage);
    // }catch(e){
    //   print(e.toString());
    // }
    // String temp_text ='';//=visionText.text!;
    // for (TextBlock block in visionText.blocks) {
    //   //final List<RecognizedLanguage> languages = block.recognizedLanguages;
    //   //print(languages);
    //   for (TextLine line in block.lines) {
    //     // Same getters as TextBlock
    //     for (TextElement element in line.elements) {
    //       temp_text+=' '+temp_text;
    //     }
    //     temp_text+='\n';
    //   }
    // }
  //   setState(() {
  //     text = temp_text;
  //     wait = false;
  //   });
  // }


  api_scantext(String path)async{

    setState(() {
      wait=true;
      text='';
    });

    //------------10 requests every 10 minutes------------------
    // String temp_text = '';
    // text_model ?model ;
    // var formData = FormData.fromMap({
    //   'language': 'ara',
    //   'file': await MultipartFile.fromFile(path)
    // });
    //  final response = await Dio().post('https://api.ocr.space/parse/image',data: formData,
    //      options: Options(headers: {'apikey':'440cfcd6a188957'})); //helloworld
    //
    //  if(response.statusCode==200)
    //   model =  text_model.fromJson(response.data);
    //  else
    //    temp_text = response.statusMessage.toString();
    //
    //  if(model!.parsedResults != null) {
    //   // print(model!.parsedResults![0].parsedText);
    //    //model.parsedResults!.forEach((element) {temp_text+=element.parsedText!+'\n';});
    //    temp_text = model.parsedResults![0].parsedText!;
    //  }else{
    //    temp_text = response.data;
    //  }

    //-------------3 times ber day -----------------------------------------------------------

    String temp_text = '';
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(path),
      //'apiKey':'5HYvuEDrQW3ACN5b1jz1zNLYd4tMCbfdDEdxBiFkyKfN'
           //   GX4Ljip12Xd6JQyZrDBbxtMjyaQR91qX8eZoTzijFQ1y
    });
    final response = await Dio().post('https://api.optiic.dev/process',data: formData);

    if(response.statusCode==200)
      temp_text = response.data['text'];
    else
      print(response.statusMessage.toString());


    setState(() {
      text = temp_text;
      wait = false;
    });
  }

  // get file size
  getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
  }

  // decries file size
  Future<File?> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 88,
      rotate: 180,
    );

    print(file.lengthSync());
    print(result?.lengthSync());

    return result;
  }

}