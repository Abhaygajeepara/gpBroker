import 'package:flutter/cupertino.dart';

class CommercialArcadeModel{
  int totalFloor;
  //List<int> shops;
  int differentialValue;
  int staring;
  int shops;
  Map<String, dynamic> toMap() {
    return {
      'TotalFloor': totalFloor, // floor number
      'TotalShop': shops,// length = number of shop
      'DifferentialValue':differentialValue,
      'Staring':staring
    };}
CommercialArcadeModel({/*required*/ required this.totalFloor,/*required*/ required this.shops, /*required*/ required this.differentialValue, /*required*/ required  this.staring});
}