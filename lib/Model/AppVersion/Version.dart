import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AppVersion{
  String version;
  String download;
  bool active;
  AppVersion({
    /*required*/ required this.active,
    /*required*/ required this.download,
    /*required*/ /*required*/ required this.version
});
  factory AppVersion.of(DocumentSnapshot snapshot){
    return AppVersion(
        active: snapshot['Service'],
        download: snapshot['DownloadLink'],
        version: snapshot['Version']
    );
  }
}