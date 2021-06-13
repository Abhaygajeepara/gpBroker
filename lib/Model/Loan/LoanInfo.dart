import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Model/Income/Income.dart';
import 'package:rxdart/rxdart.dart';
class SinglePropertiesLoanInfo{
  String loanId;
  int emiId; // which emi
  Timestamp installmentDate;
  bool emiPending;
  String typeOfPayment;
  String ifsc = '';
  String  upiId = '';
  String bankAccountNumber= '';
  String payerName;
  String receiverName;
  String relation;
  int amount;
  int/*!*/ brokerCommission;
  Timestamp paymentTime;


  SinglePropertiesLoanInfo({
    /*required*/ required this.loanId,
    /*required*/ required  this.emiId,
    /*required*/ required this.installmentDate,
    /*required*/ required this.emiPending,
    /*required*/ required this.typeOfPayment,
    /*required*/ required this.ifsc,
    /*required*/ required this.upiId,
    /*required*/ required  this.bankAccountNumber,
    /*required*/ required  this.payerName,
    /*required*/ required this.receiverName,
    /*required*/ required this.relation,
    /*required*/ required this.amount,
    /*required*/ required this.paymentTime,
    /*required*/ required this.brokerCommission

  });
  factory SinglePropertiesLoanInfo.of(DocumentSnapshot snapshot){

    return  SinglePropertiesLoanInfo(
        loanId: snapshot['LoanId'],
        emiId: int.parse(snapshot.id),
        installmentDate: snapshot['InstallmentDate'],
        emiPending: snapshot['EMIPending'],
        typeOfPayment: snapshot['TypeOfPayment'],
        ifsc: snapshot['IFSC']??'',
        upiId: snapshot['UPIID']??'',
        bankAccountNumber: snapshot['BankAccountNumber']??'',
        payerName: snapshot['PayerName'],
        receiverName: snapshot['ReceiverName'],
        relation: snapshot['Relation'],
        amount: snapshot['Amount'],
        paymentTime: snapshot['PaymentDate'],
        brokerCommission: snapshot['BrokerMonthlyCommission']


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

class LoanBasicDetails{

  Timestamp cusBookingDate;
  Timestamp loanStartingDate;
  Timestamp loanEndingDate;

  bool isLoanOn;

  String customerId;
  int brokerCommission;
  String brokerReference;
  int squareFeet;
  int pricePerSquareFeet;
  int totalEMI;
  int perMonthEMI;
  List<Timestamp> completeEmi;
  List<Timestamp> remainingEmi;
  LoanBasicDetails({

    required  this.cusBookingDate,
    required  this.loanStartingDate,
    required this.loanEndingDate,
    required  this.isLoanOn,
    required  this.customerId,


    required this.brokerReference,
    required this.brokerCommission,
    required  this.squareFeet,
    required this.pricePerSquareFeet,
    required this.totalEMI,
    required this.perMonthEMI,
    /*required*/ required this.completeEmi,
    /*required*/ required this.remainingEmi

  });
  factory  LoanBasicDetails.of(DocumentSnapshot snap){

    return  LoanBasicDetails(

        cusBookingDate:snap['BookingDate'],
        loanStartingDate: snap['LoanStartingDate'],
        loanEndingDate: snap['LoanEndingDate'],
        isLoanOn:snap['LoanOn'],
        customerId: snap['CustomerId'].toString(),

        brokerReference:snap['BrokerReference'],
        brokerCommission: snap['BrokerCommission'],
        squareFeet:snap['SquareFeet'],
        pricePerSquareFeet:snap['PricePerSquareFeet'],
        perMonthEMI: snap['PerMonthEMI'],
        totalEMI: snap['EMIDuration'],
        completeEmi: List.from(snap['CompletedEMI']),
        remainingEmi: List.from(snap['RemainingEMI'])


    );
  }

}
class FullLoanDetails{
  List<SinglePropertiesLoanInfo> singlePropertiesLoanInfo;
  LoanBasicDetails loanBasicDetails;
  FullLoanDetails({
    /*required*/ required   this.singlePropertiesLoanInfo,
    required this.loanBasicDetails
  });
  factory FullLoanDetails.of( List<SinglePropertiesLoanInfo> singlePropertiesLoanInfo, LoanBasicDetails loanBasicDetails){
    return FullLoanDetails(loanBasicDetails:loanBasicDetails , singlePropertiesLoanInfo: singlePropertiesLoanInfo);
  }
}

class CommissionCountModel{
  String projectName;
  List<SinglePropertiesLoanInfo> paidEmi;
  List<SinglePropertiesLoanInfo> remainingEmi;
  CommissionCountModel({
    /*required*/ required this.projectName,
    /*required*/ required this.paidEmi,
    /*required*/ required this.remainingEmi,
  });
  factory CommissionCountModel.of(String projectName, List<SinglePropertiesLoanInfo> paidEmi,  List<SinglePropertiesLoanInfo> remainingEmi){
    return CommissionCountModel(projectName: projectName, paidEmi: paidEmi, remainingEmi: remainingEmi);
  }
}

class IncomeCountModel{
  String projectName;
  List<SinglePropertiesLoanInfo> paidEmi;
  List<SinglePropertiesLoanInfo> remainingEmi;
  List<SinglePropertiesLoanInfo> closedBookingPaidEmi;
  IncomeCountModel({
    /*required*/ /*required*/ /*required*/ required this.projectName,
    /*required*/ /*required*/ required this.paidEmi,
    /*required*/ /*required*/ /*required*/ required this.remainingEmi,
    /*required*/ /*required*/ /*required*/ required this.closedBookingPaidEmi,
  });
  factory IncomeCountModel.of(String projectName, List<SinglePropertiesLoanInfo> paidEmi,  List<SinglePropertiesLoanInfo> remainingEmi, List<SinglePropertiesLoanInfo> closedBookingPaidEmi){
    return IncomeCountModel(projectName: projectName, paidEmi: paidEmi, remainingEmi: remainingEmi,closedBookingPaidEmi: closedBookingPaidEmi);
  }
}

