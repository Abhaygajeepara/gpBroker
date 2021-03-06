import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class InnerData{
  String name; // structure number
  List<BookingDataModel> cusList;
  List<int>soldList;

  InnerData({/*required*/ /*required*/ required this.name, /*required*/ required this.cusList, /*required*/ required this.soldList});
  factory InnerData.of(String nameOfStructure,QuerySnapshot snapshot){

    List<BookingDataModel> cusLists = [];
    List<int> soldLists = [];
      for(int i  =0;i<snapshot.docs.length;i++){

          cusLists.add(BookingDataModel.of(snapshot.docs[i],''));
          snapshot.docs[i]['IsLoanOn'] == true?soldLists.add(int.parse(snapshot.docs[i].id)):null;
      }
    return InnerData(
        name: nameOfStructure.toString(),
      cusList: cusLists,
      soldList: soldLists
    );
  }
}

class BookingDataModel{
  //String id;
  Timestamp cusBookingDate;
  Timestamp loanStartingDate;
  Timestamp loanEndingDate;
  // String customerName;
  bool/*!*/ isLoanOn;
  String loanReferenceCollectionName;
  String customerId;
  int brokerCommission;
  String brokerReference;
  //List<Map<String ,dynamic>> allCustomer;
  int squareFeet;
  int/*!*/ pricePerSquareFeet;
  int totalEMI;
  int perMonthEMI;
  String part;
  String propertiesNumber;




  BookingDataModel({
    //  @required this.id,
    /*required*/ required  this.cusBookingDate,
    /*required*/ required  this.loanStartingDate,
    /*required*/ required this.loanEndingDate,
    /*required*/ required  this.isLoanOn,
    /*required*/ required  this.customerId,
    //@required this.customerName,
    /*required*/ required  this.loanReferenceCollectionName,
    /*required*/ required this.brokerReference,
    //@required this.allCustomer,
    /*required*/ required this.brokerCommission,
    /*required*/ required  this.squareFeet,
    /*required*/ required this.pricePerSquareFeet,
    /*required*/ required this.totalEMI,
    /*required*/ required this.perMonthEMI,
    /*required*/ required this.part,
    /*required*/ required this.propertiesNumber

  });
  factory  BookingDataModel.of(DocumentSnapshot snap,String loanRef){

    return  BookingDataModel(
      //  id: snap.id.toString(),
        cusBookingDate:snap['BookingDate'],
        loanStartingDate: snap['LoanStartingDate'],
        loanEndingDate: snap['LoanEndingDate'],
        isLoanOn:snap['LoanOn'],
        customerId: snap['CustomerId'].toString(),
        //customerName: snap['CustomerName'],
        loanReferenceCollectionName:loanRef,
        brokerReference:snap['BrokerReference'],
        //allCustomer: List.from(snap['AllCustomer']),
        brokerCommission: snap['BrokerCommission'],
        squareFeet:snap['SquareFeet'],
        pricePerSquareFeet:snap['PricePerSquareFeet'],
        perMonthEMI: snap['PerMonthEMI'],
        totalEMI: snap['EMIDuration'],
        propertiesNumber: snap['PropertiesNumber'],
        part: snap['Part']



    );
  }

}


// class ApartMentInnerData{
//   String name; // structure number
//   List<FlatsPerFloor> numberOfFlats;
//
//   ApartMentInnerData({this.name,this.numberOfFlats});
//   factory ApartMentInnerData.of(String nameOfStructure,QuerySnapshot snapshot){
//     List<List<DocumentSnapshot>> flatsList = [];
//     List<FlatsPerFloor> flatsPerFloorList = [];
//
//     int maxFloor = (int.parse(snapshot.docs.last.id)/100).round();
//     for(int i=0;i<maxFloor;i++) {
//       flatsList.add([]);
//     }
//
//     // List<List<String>> _floor =[];
//     // List<String> _flats = List();
//
//
//   // int predictedFloor =0;
//   for(int i =0;i<snapshot.docs.length;i++){
//     // print('i: $i, length: ${snapshot.docs.length}');
//     int currentFloor = (int.parse(snapshot.docs[i].id)/100).round()-1;
//     flatsList[currentFloor].add(snapshot.docs[i]);
//       // if(currentFloor != predictedFloor){
//       //
//       //   print("change = ${i}");
//       //
//       //   _flats =[];
//       //   flatsList=[];
//       // }
//       // if (predictedFloor ==  currentFloor){
//       //   print("same = ${i}");
//       //   _flats.add(snapshot.docs[i].id);
//       //   flatsList.add(snapshot.docs[i]);
//       //   print(flatsList);
//       // }
//       // else{
//       //   // print("same = ${i}");
//       //
//       //   predictedFloor = currentFloor;
//       //
//       //   _floor.add(_flats);
//       //
//       //
//       //   _flats.add(snapshot.docs[i].id);
//       // }
//
//
//
//
//   }
//
//   for(int i=0;i<flatsList.length;i++) {
//     flatsPerFloorList.add(FlatsPerFloor.of(flatsList[i]));
//   }
//  // print(_floor);
//
//     // int flatPerFloor =int.parse(snapshot.docs.last.id.substring(snapshot.docs.last.id.length-1));
//     // double predictedFloor = snapshot.docs.length / flatPerFloor;
//     // int numberFlorr = predictedFloor.toInt();
//     // // List<CustomerData> innerdata;
//     // int start =0;
//     // int end =flatPerFloor;
//     // for( int i=0;i<numberFlorr;i++){
//     //   flatsList =[];
//     //   for(int j = start; j<end; j++){
//     //     flatsList.add(snapshot.docs[j]);
//     //   }
//     //   start  = end;
//     //   end =  end+flatPerFloor;
//     //   flatsPerFloorList.add(FlatsPerFloor.of(flatsList));
//     // }
//
//     return ApartMentInnerData(
//         name: nameOfStructure.toString(),
//         numberOfFlats: flatsPerFloorList
//     );
//   }
// }
// class FlatsPerFloor{
//   List<CustomerData> cusLists;
//   FlatsPerFloor({this.cusLists});
//   factory FlatsPerFloor.of(List<DocumentSnapshot> flats){
//     List<CustomerData> cusLists = [];
//     for(int i  =0;i<flats.length;i++){
//       // CustomerData data= CustomerData.of(snapshot.docs[i]);
//       cusLists.add(CustomerData.of(flats[i]));
//     }
//     return FlatsPerFloor(
//       cusLists: cusLists
//     );
//   }
//
//
// }
//
//
// class MixedUseStrcuture{
//   List<InnerData> commercialList;
//   List<MixedUsedApartment> mixapartmentList;
//   MixedUseStrcuture({this.commercialList,this.mixapartmentList});
//   factory MixedUseStrcuture.of(List<QuerySnapshot>  commercialRefs,List<QuerySnapshot> buildingRef){
//
//     List<InnerData> _commercialList = List();
//     List<MixedUsedApartment> _mixapartmentList=List();
//     for(int i =0;i<commercialRefs.length;i++){
//       _commercialList.add(InnerData.of('s', commercialRefs[i]));
//
//     }
//     print(buildingRef.length);
//     for(int j=0;j<buildingRef.length ;j++){
//       _mixapartmentList.add(MixedUsedApartment.of('s', buildingRef[j]));
//     }
//     return MixedUseStrcuture(
//     commercialList: _commercialList,
//       mixapartmentList: _mixapartmentList
//
//     );
//   }
// }
// class MixedUsedApartment{
//   String apartmentName;
//   List<FlatsPerFloor> flatsPerFloor;
//   MixedUsedApartment({this.apartmentName,this.flatsPerFloor});
//   MixedUsedApartment.of(String buildingName,QuerySnapshot snapshot){
//       // print(buildingName);
//       // print(snapshot.docs.first.id);
//   }
// }