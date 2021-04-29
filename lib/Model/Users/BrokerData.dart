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
  List<RemainingEmiModel> remainingEmi;
  int totalRemainingEmi;
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
    @required this.totalRemainingEmi,
    @required this.notificationKey,
    @required this.closedBooking,
    @required this.walletBalance

  });

  factory BrokerModel.of(DocumentSnapshot snapshot ){
    int totalRemainingEMI = 0;
    List data = List.from(snapshot['RemainingEMI']);
    List<RemainingEmiModel> remainingEMIList = [];
    data.map((e)  {
      RemainingEmiModel remainingEmiModel = RemainingEmiModel.of(e);
      totalRemainingEMI = totalRemainingEMI +remainingEmiModel.pendingEmi;
      remainingEMIList.add(remainingEmiModel);
    }).toList();
    return BrokerModel(
        id: snapshot.data()['Id'],
        name: snapshot.data()['Name'],
        number: snapshot.data()['PhoneNumber'],
        alterNativeNumber: snapshot.data()['AlterNativeNumber'],
        image: snapshot.data()['ProfileUrl'],
        isActiveUser: snapshot.data()['IsActive'],
        password: snapshot.data()['Password'],
        remainingEmi:  remainingEMIList,
        totalRemainingEmi: totalRemainingEMI,
        clients: List.from(snapshot.data()['ClientsList']),
        notificationKey: List.from(snapshot.data()['NotificationKey']),
        closedBooking: List.from(snapshot.data()['ClosedBooking']),
        walletBalance: snapshot.data()['WalletBalance']
    );
  }
}
class RemainingEmiModel{
  String projectName;
  String loanRef;
  int pendingEmi;
  RemainingEmiModel({
    @required this.projectName,
    @required this.loanRef,
    @required this.pendingEmi
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