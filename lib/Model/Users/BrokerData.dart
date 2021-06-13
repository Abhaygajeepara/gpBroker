import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class  BrokerModel{
  String? id;
  String? name;
  int? number;
  int? alterNativeNumber;
  String? image;
  bool?/*?*/ isActiveUser;
  String? password;
  List<Map<String,dynamic>> clients;
  List<RemainingEmiModel> remainingEmi;
  int totalRemainingEmi;
  List<String> notificationKey;
  List<Map<String,dynamic>> closedBooking;
  int? walletBalance;
  BrokerModel({
    /*required*/ required this.id,
    /*required*/ required this.name,
    /*required*/ required this.number,
    /*required*/ required this.alterNativeNumber,
    /*required*/ required  this.image,
    /*required*/ required this.password,
    /*required*/ required  this.isActiveUser,
    /*required*/ required this.clients,
    /*required*/ required this.remainingEmi,
    /*required*/ required this.totalRemainingEmi,
    /*required*/ required this.notificationKey,
    /*required*/ required this.closedBooking,
    /*required*/ required this.walletBalance

  });

  factory BrokerModel.of(DocumentSnapshot snapshot ){
    int totalRemainingEMI = 0;
    List data = List.from(snapshot['RemainingEMI']);
    List<RemainingEmiModel> remainingEMIList = [];
    data.map((e)  {
      RemainingEmiModel remainingEmiModel = RemainingEmiModel.of(e);
      totalRemainingEMI = totalRemainingEMI +remainingEmiModel.pendingEmi!;
      remainingEMIList.add(remainingEmiModel);
    }).toList();
    return BrokerModel(
        id: snapshot['Id'],
        name: snapshot['Name'],
        number: snapshot['PhoneNumber'],
        alterNativeNumber: snapshot['AlterNativeNumber'],
        image: snapshot['ProfileUrl'],
        isActiveUser: snapshot['IsActive'],
        password: snapshot['Password'],
        remainingEmi:  remainingEMIList,
        totalRemainingEmi: totalRemainingEMI,
        clients: List.from(snapshot['ClientsList']),
        notificationKey: List.from(snapshot['NotificationKey']),
        closedBooking: List.from(snapshot['ClosedBooking']),
        walletBalance: snapshot['WalletBalance']
    );
  }
}
class RemainingEmiModel{
  String? projectName;
  String? loanRef;
  int? pendingEmi;
  RemainingEmiModel({
    /*required*/ required this.projectName,
    /*required*/ required this.loanRef,
    /*required*/ required this.pendingEmi
  });
  factory RemainingEmiModel.of(Map<String,dynamic> data){
    return RemainingEmiModel(projectName: data['ProjectName'], loanRef: data['LoanRef'], pendingEmi: data['TotalPendingEmi']);
  }
}
// fields of database
// "LoanId":loanId,
// "Property":"${projectName}/${innerCollection}/${allocatedNumber}",
// "Commission":brokerageList[i],
// "CustomerId":cusPhoneNumber,
// "BookingDate":bookingDate,
// "EMIDate":_emi[i],
// "CustomerName":customerName,
// "IsPay":false,
//ClientsList [LoanRef,]ProjectName,PhoneNumber,CustomerName
//ClosedBooking