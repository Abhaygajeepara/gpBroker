import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gpgroup/Model/Advertise/AdvertiseMode.dart';
import 'package:gpgroup/Model/Income/Income.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';

class  ProjectNameList{
   String projectName;
  String address;
  String landmark;
  String description;
  String typeofBuilding;
  List<String> englishRules;
  List<String> gujaratiRules;
  List<String> hindiRules;
  List<String> reference;
  List<Map<String,dynamic>> Structure;
  List<String> imagesUrl;
  bool isSiteOn;
int siteVisit;

  ProjectNameList({
    @required  this.projectName,
   @required  this.address,
    @required this.landmark,
    @required this.description,
    @required  this.typeofBuilding,
    @required  this.englishRules,
    @required this.gujaratiRules,
    @required this.hindiRules,
    @required this.reference,
    @required this.Structure,
    @required this.imagesUrl,
    @required this.isSiteOn,
    @required this.siteVisit

  });
  factory ProjectNameList.of(DocumentSnapshot snapshot){
    return ProjectNameList(
      projectName: snapshot.id,
      address: snapshot.data()['Address'],
      landmark: snapshot.data()['Landmark'],
      description: snapshot.data()['Description'],
      typeofBuilding: snapshot.data()['TypeofBuilding'],
      englishRules:List.from( snapshot.data()['EnglishRules']),
      gujaratiRules: List.from( snapshot.data()['GujaratiRules']),
      hindiRules: List.from( snapshot.data()['HindiRules']),
      reference: List.from( snapshot.data()['Reference']),
      Structure: List.from(snapshot.data()['Structure']),
      imagesUrl : List.from(snapshot.data()['ImageUrl']),
      isSiteOn: snapshot.data()['IsSiteOn'],
      siteVisit: snapshot.data()['SiteVisit']


    );
  }
}

class ProjectAndAdvertise{
  BrokerModel brokerModel;
    List<AdvertiseModel> advertiseList;
  List<IncomeModel> commission;
    ProjectAndAdvertise({@required this.brokerModel,@required this.advertiseList,@required this.commission});
    factory ProjectAndAdvertise.of(  BrokerModel brokerModels,  List<AdvertiseModel> _advertiseList, List<IncomeModel> _commission){
      return ProjectAndAdvertise(brokerModel: brokerModels, advertiseList: _advertiseList,commission: _commission);
    }
}