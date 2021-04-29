
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';

// Widget CommonAppbarForHome(BuildContext context){
//   return AppBar(
//     title : Text(CommonAssets.apptitle,style: TextStyle(color: Colors.white),),
//     backgroundColor: CommonAssets.AppbarColor,
//
//   );
// }
Widget CommonAppbar(String appTitle,Widget appwidget){
  return AppBar(
    title : Text(appTitle,style: TextStyle(color: Colors.white),),
  iconTheme:IconThemeData(color: Colors.white) ,
    actions: [
      appwidget
    ],
  );
}