
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IncomeModel{
  String month ;
  Timestamp emiMonthTimestamp;
  List<Map<String,dynamic>> clientData;
  IncomeModel({
    /*required*/ /*required*/ /*required*/ /*required*/ required this.clientData,
    /*required*/ required this.month,
    /*required*/ required this.emiMonthTimestamp,
  });
  factory IncomeModel.of(DocumentSnapshot e){
    return IncomeModel(
        clientData: List.from(e['Transfer']),
        month: e.id,
        emiMonthTimestamp: e['MonthTimeStamp']
    );
  }
}
// PerMonthEMI only for income
// Commission  fields of database
// "LoanId":loanId,
// "Property":"${projectName}/${innerCollection}/${allocatedNumber}",
// "Commission":brokerageList[i],
// "CustomerId":cusPhoneNumber,
// "BookingDate":bookingDate,
// "EMIDate":_emi[i],
// "CustomerName":customerName,
// "IsPay":false,

// expense
// "Expense":expense,
// "Amount":amount,
// "Description":description,
// "Date":expenseDate
class IncomeAndExpanse{
  List<IncomeModel> income;
  List<IncomeModel> expanse;
  IncomeAndExpanse({
    /*required*/ /*required*/ required this.income,
    /*required*/ required this.expanse,
  });
  factory IncomeAndExpanse.of(List<IncomeModel> _income,List<IncomeModel> _expnase){
    return IncomeAndExpanse(income:_income , expanse: _expnase);
  }
}