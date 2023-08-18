import 'dart:ui';

import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code/view/test.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'dart:io';

import 'package:shimmer/shimmer.dart'; // Import for File class


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String data = "";
  GlobalKey qrImageKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool Pr_autoValidate = false;

  void _saveQrToGallery() async {
    RenderRepaintBoundary boundary =
    qrImageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    final result = await ImageGallerySaver.saveImage(buffer);
    if (result['isSuccess']) {
      Fluttertoast.showToast(
        msg: "QR code downloaded successfully. Please check your gallery.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black, // Changed the background color to black
        textColor: Colors.white,
        fontSize: 16.0,
        webShowClose: true, // Kept the close button for web
        webBgColor: "#333333", // Kept the background color for web

      );      print("QR code saved to gallery");
    } else {
      // Show an error message
      print("Failed to save QR code to gallery");
      Fluttertoast.showToast(
        msg: "Failed",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black, // Changed the background color to black
        textColor: Colors.white,
        fontSize: 16.0,
        webShowClose: true, // Kept the close button for web
        webBgColor: "#333333", // Kept the background color for web

      );
    }
  }

  Future<void> _shareQrCodeImage() async {
    if (data.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill the text before sharing.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
        webShowClose: true,
        webBgColor: "#333333",
      );
      return;
    }

    RenderRepaintBoundary boundary =
    qrImageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    try {
      await Share.file(
        'QR Code Image',
        'QR_Code.png',
        buffer,
        'image/png',
        text: 'Check out this QR code!, Developed By Umair Hashmi @iam.umairimran@gmail.com',
      );
    } catch (e) {
      print("Error sharing: $e");
    }
  }




  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //when tap anywhere on screen keyboard dismiss
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(

          centerTitle: true,
          toolbarHeight: 42,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF000000),
                  Color(0xFF000000),
                  Color(0xFF000000),
                  Color(0xFF000000),
                ],
              ),
            ),
          ),
          title: Shimmer.fromColors(

          baseColor: Colors.white,
          highlightColor: Colors.cyanAccent,

          child: Text(
            "Custom QR Generator",
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              letterSpacing: .5,
            ),
          ),
        ),
          elevation: 7.0,

        ),



        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF000000),
                  Color(0xFF000000),
                  Color(0xFF000000),
                  Color(0xFF000000),

                ],
                stops: [0.1, 0.5, 0.7, 0.9],
              ),
            ),
            //color: Colors.black,
            padding: const EdgeInsets.all(16.0),



            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [


                  RepaintBoundary(
                    key: qrImageKey,
                    child: QrImage(
                      data: data,
                      version: QrVersions.auto,
                      size: 230.0,
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      errorCorrectionLevel: QrErrorCorrectLevel.Q,
                    ),
                  ),



                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 200,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Type the Data",
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: Colors.black38,
                            fontWeight: FontWeight.normal,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          // contentPadding: EdgeInsets.all(PrHeight * 0.010),
                        ),
                        style: TextStyle(  // Add this part to change the input text color
                          color: Colors.black,  // Set the desired text color here
                        ),
                        onChanged: (value) {
                          setState(() {
                            data = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your data';
                          }
                          return null;
                        },
                      ),

                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async{

                          if (_formKey.currentState!.validate()){
                            if (data.isNotEmpty) {
                              // Generate QR code and save to gallery
                              _saveQrToGallery();
                            }
                          }
                          else {
                            Pr_autoValidate = true;
                          }



                        },


                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5), // <-- Radius
                            ),
                            backgroundColor: Colors.cyanAccent),
                        child:
                        Text(
                          "Gen QR Code",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              //fontWeight: FontWeight.w600,
                              letterSpacing: .5)
                        ),
                      )),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Share the generated QR code image
                         await _shareQrCodeImage();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: Colors.cyanAccent, // Choose a color for the Share button
                      ),
                      child: Text(
                        "Share",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
