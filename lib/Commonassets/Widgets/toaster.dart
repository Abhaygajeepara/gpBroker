import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';

Widget toaster(String msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      //backgroundColor: Colors.red,
      textColor: CommonAssets.normalTextColor,
      fontSize: 16.0
  );
}