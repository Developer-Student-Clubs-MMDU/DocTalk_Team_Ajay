import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var widgetColor = const Color.fromRGBO(67, 44, 129, 1.0);
var linearColor = const [
  Color.fromRGBO(206, 159, 252, 1.0),
  Color.fromRGBO(115, 103, 240, 1.0)
];
var cardColor = const Color.fromRGBO(220, 198, 242, 1.0);

void snackBarMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}
String device = '';
void setDevice(String id){
  device = id;
  print("set device id is $device to $id");
}
void setColor(Color color, BuildContext context, String selectedDevice) async {
  try {
    var res = await http.post(
      Uri.http(selectedDevice, '/colour'), // Updated Uri
      body: {
        "r": color.red.toString(),
        "g": color.green.toString(),
        "b": color.blue.toString()
      },
    );
    if (res.statusCode != 200) {
      snackBarMessage(context, "Device Error setting color");
    }
  } catch (e) {
    print(e);
    snackBarMessage(context, "Connection Error");
  }
}


class Config {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;
  }
}