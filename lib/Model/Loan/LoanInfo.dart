import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
class SinglePropertiesLoanInfo{
  int emiId; // which emi
  Timestamp installmentDate;
  bool emiPending;
  String typeOfPayment;
  String ifsc;
  String  upiId;
  String bankAccountNumber;
  String payerName;
  String receiverName;
  String relation;
  int amount;
  Timestamp paymentTime;


  SinglePropertiesLoanInfo({
    @required  this.emiId,
  @required this.installmentDate,
    @required this.emiPending,
    @required this.typeOfPayment,
    @required this.ifsc,
    @required this.upiId,
    @required  this.bankAccountNumber,
    @required  this.payerName,
    @required this.receiverName,
  @required this.relation,
    @required this.amount,
    @required this.paymentTime

  });
  factory SinglePropertiesLoanInfo.of(DocumentSnapshot snapshot){

    return  SinglePropertiesLoanInfo(
      emiId: int.parse(snapshot.id),
      installmentDate: snapshot['InstallmentDate'],
      emiPending: snapshot['EMIPending'],
      typeOfPayment: snapshot['TypeOfPayment'],
      ifsc: snapshot['IFSC'],
      upiId: snapshot['UPIID'],
      bankAccountNumber: snapshot['BankAccountNumber'],
      payerName: snapshot['PayerName'],
      receiverName: snapshot['ReceiverName'],
      relation: snapshot['Relation'],
      amount: snapshot['Amount'],
      paymentTime: snapshot['PaymentDate']


    );
  }

}
// filed in database
// "InstallmentDate":_emi[i],
// "EMIPending":true,
// "TypeOfPayment":"",
// "IFSC":"",
// "UPIID":"",
// "BankAccountNumber":"",
// 'PayerName':"",
// "ReceiverName":"",
// "Relation":"",
// "Amount":0