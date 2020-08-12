import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String qrCodeResult = "Not Yet Scanned";
  String qrHash = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scannar"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Result",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              qrCodeResult,
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),
            FlatButton(
              padding: EdgeInsets.all(15.0),
              onPressed: () async {
                try {
                  String cameraScanResult = await BarcodeScanner.scan();
                  var scanResultJson = json.decode(cameraScanResult);
                  print(scanResultJson["hash"]);
                  setState(() { 
                    this.qrHash = scanResultJson["hash"];
                    this.qrCodeResult = "Wait while processing";
                  }
                  );
                } on PlatformException catch (e) {
                  if (e.code == BarcodeScanner.CameraAccessDenied) {
                    setState(() {
                      this.qrCodeResult = 'The user did not grant the camera permission!';
                    });
                  } else {
                    setState(() => this.qrCodeResult = 'Unknown error: $e');
                  }
                } on FormatException{
                  setState(() => this.qrCodeResult = 'null (User returned using the "back"-button before scanning anything. Result)');
                } catch (e) {
                  setState(() => this.qrCodeResult = 'Unknown error: $e');
                }
                var currentData = new DateTime.now();
                var location = new Location();
                String latitude = "";
                String longitude = "";
                try {
                  await location.getLocation().then((onValue) {
                    print(onValue.latitude.toString() + "," + onValue.longitude.toString());
                    longitude = onValue.longitude.toString();
                    latitude = onValue.latitude.toString();
                          
                  });
                } catch (e) {
                  print(e);
                  if (e.code == 'PERMISSION_DENIED') {
                    print("PERMISSION_DENIED");
                  }
                } 
                print(currentData);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String headers = prefs.get("signin_headers");
                String imagePath = prefs.get("imagePath");
                var jsonHeaders = json.decode(headers);
                // Map data = {
                //   "hash": "46fa1be6379a8b03629551ce9ec74664f79edece",
                //   "longitude": "31.329484800000003",
                //   "latitude": "29.8549248",
                // };
                Map data;
                var jsonResponse = null;
                var response;
                print("IMAGE-PATH: ${imagePath}");
                if (imagePath == null) {
                  print("WITHOUT IMAGE");
                  data = {
                    "lat": "${latitude}", // "-90.984722"
                    "long": "${longitude}",// "10.807222"
                  };
                  jsonResponse = null;
                  response = await http.post("https://a-tracker.herokuapp.com/sessions/${qrHash}/attend",//
                    body: data, 
                    headers: {
                      "access-token" :jsonHeaders["access-token"],
                      "client": jsonHeaders["client"],
                      "uid" : jsonHeaders["uid"]
                    }
                  );
                } else {
                  print("USING FACE");
                  Map<String, String> headers = {
                      "access-token" :jsonHeaders["access-token"],
                      "client": jsonHeaders["client"],
                      "uid" : jsonHeaders["uid"]
                  };
                  print("Headers: ${headers}");
                  Uri apiUrl = Uri.parse('https://a-tracker.herokuapp.com/sessions/${qrHash}/attend');
                  final mimeTypeData =
                      lookupMimeType(imagePath, headerBytes: [0xFF, 0xD8]).split('/');

                  // Intilize the multipart request
                  final imageUploadRequest = http.MultipartRequest('POST', apiUrl);
                  imageUploadRequest.headers.addAll(headers);
                  print("MultiPartRequest: ${imageUploadRequest}");
                  print("MultiPartRequest Headers: ${imageUploadRequest.headers}");
                  // Attach the file in the request
                  final file = await http.MultipartFile.fromPath(
                      'captured_face', imagePath,
                      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

                  imageUploadRequest.files.add(file);
                  imageUploadRequest.fields['lat'] = latitude;
                  imageUploadRequest.fields['long'] = longitude;

                  try {
                    final streamedResponse = await imageUploadRequest.send();
                    response = await http.Response.fromStream(streamedResponse);
                  } catch (e) {
                    print(e);
                    return null;
                  }

                }
                
                print("headerFromScan:acTOk ${jsonHeaders["access-token"]}");
                print("headerFromScan:Client ${jsonHeaders["client"]}");
                print("headerFromScan:UID ${jsonHeaders["uid"]}");//https://gp-qrcode.herokuapp.com/api/qrcodes/attend

                print("status: ${response.statusCode}");
                if(response.statusCode == 200) {
                  print("QR CODE KDA TMMMMM");
                  jsonResponse = json.decode(response.body);
                  print("statusVVV: ${jsonResponse['verified']}");
                  if (jsonResponse['verified'] == true) {
                    setState(() => this.qrCodeResult = "Success");
                    print("SUCCESS");
                    showAlertDialog(context, "You attend successfully"); 
                  } else {
                    setState(() => this.qrCodeResult = jsonResponse['failure_message']);
                  }    
                } else {
                  print('Wrong Hash code');
                  print('status: ${response.statusCode}');
                  // print('message: ${response.message}');
                  setState(() => this.qrCodeResult = 'Wrong Hash code');
                }
                prefs.remove("imagePath");
              },
              child: Text(
                "Open Scanner",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blue, width: 3.0),
                  borderRadius: BorderRadius.circular(20.0)),
            )
          ],
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context, String resText) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pushNamed(context, '/home');
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(""),
    content: Text(resText),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


// Future<void> _showMyDialog(context) async {
//   return showDialog<void>(
//     context: context,
//     barrierDismissible: false, // user must tap button!
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('AlertDialog Title'),
//         content: SingleChildScrollView(
//           child: ListBody(
//             children: <Widget>[
//               Text('This is a demo alert dialog.'),
//               Text('Would you like to approve of this message?'),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           FlatButton(
//             child: Text('Okay'),
//             onPressed: () {
//               Navigator.pushNamed(context, '/home');
//             },
//           ),
//         ],
//       );
//     },
//   );
// }