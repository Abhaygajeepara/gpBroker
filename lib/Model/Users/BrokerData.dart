import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class  BrokerModel{
  String id;
  String name;
  int number;
  int alterNativeNumber;
  String image;
  bool isActiveUser;
  String password;
  List<Map<String,dynamic>> clients;
  List remainingEmi;
  List<String> notificationKey;
  List<Map<String,dynamic>> closedBooking;
  int walletBalance;
  BrokerModel({
    @required this.id,
    @required this.name,
    @required this.number,
    @required this.alterNativeNumber,
    @required  this.image,
    @required this.password,
    @required  this.isActiveUser,
    @required this.clients,
    @required this.remainingEmi,
    @required this.notificationKey,
    @required this.closedBooking,
    @required this.walletBalance

  });

  factory BrokerModel.of(DocumentSnapshot snapshot ){
    return BrokerModel(
        id: snapshot.data()['Id'],
        name: snapshot.data()['Name'],
        number: snapshot.data()['PhoneNumber'],
        alterNativeNumber: snapshot.data()['AlterNativeNumber'],
        image: snapshot.data()['ProfileUrl'],
        isActiveUser: snapshot.data()['IsActive'],
        password: snapshot.data()['Password'],
        remainingEmi:  List.from(snapshot.data()['RemainingEMI']),
        clients: List.from(snapshot.data()['ClientsList']),
        notificationKey: List.from(snapshot.data()['NotificationKey']),
        closedBooking: List.from(snapshot.data()['ClosedBooking']),
        walletBalance: snapshot.data()['WalletBalance']
    );
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