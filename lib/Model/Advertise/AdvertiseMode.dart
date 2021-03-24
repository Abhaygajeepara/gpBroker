import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdvertiseModel {
  String id;
  String description;
  List<String> imageUrl;
  bool isActive;
  AdvertiseModel({
    @required this.id,
    @required this.description,
    @required this.imageUrl,
    @required this.isActive

  });

  factory AdvertiseModel.of(DocumentSnapshot snapshot)
  {
    return AdvertiseModel(
        id: snapshot.id,
        description: snapshot.data()['Description'],
        imageUrl: List.from(snapshot.data()['ImageUrl']),
      isActive: snapshot.data()['IsActive']
        );
  }
}