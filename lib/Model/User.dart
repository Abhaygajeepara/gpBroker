import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class  UserData{
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
  String currentToken;
  UserData({
    this.id,
     this.name,
     this.number,
     this.alterNativeNumber,
      this.image,
     this.password,
      this.isActiveUser,
     this.clients,
     this.remainingEmi,
     this.notificationKey,
    this.currentToken
  });

  factory UserData.of(DocumentSnapshot snapshot ){
    return UserData(
        id: snapshot.data()['Id'],
        name: snapshot.data()['Name'],
        number: snapshot.data()['PhoneNumber'],
        alterNativeNumber: snapshot.data()['AlterNativeNumber'],
        image: snapshot.data()['ProfileUrl'],
        isActiveUser: snapshot.data()['IsActive'],
        password: snapshot.data()['Password'],
        remainingEmi:  List.from(snapshot.data()['RemainingEMI']),
        clients: List.from(snapshot.data()['ClientsList']),
        notificationKey: List.from(snapshot.data()['NotificationKey'])
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