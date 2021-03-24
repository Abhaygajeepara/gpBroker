import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gpgroup/Model/Loan/LoanInfo.dart';
import 'package:gpgroup/Model/Project/InnerData.dart';

class CustomerInfoModel{
  String customerName;
  int number;
 // List<Map<String,dynamic>> propertiesList;
 // List remainingEMIList;
  List<String> notificationKey;
  CustomerInfoModel({
    @required this.customerName,
    @required this.number,
 //   @required this.propertiesList,
   @required this.notificationKey,
  //  @required this.remainingEMIList
});
  factory CustomerInfoModel.of(DocumentSnapshot snapshot){
    return CustomerInfoModel(
        customerName: snapshot['CustomerName'],
        number: snapshot['CustomerPhoneNumber'],
       // propertiesList: List.from(snapshot['Properties']),
        notificationKey: List.from(snapshot['NotificationKey']),
        //remainingEMIList: List.from(snapshot['RemainingEMI'])

    );
  }
}
//Part,ProjectName,PropertyNumber,LoanRef
class BookingAndLoan{
  BookingDataModel bookingData;
  List<SinglePropertiesLoanInfo> loanData;
  BookingAndLoan({@required this.bookingData,@required this.loanData});
  factory BookingAndLoan.of( BookingDataModel _bookingData,List<SinglePropertiesLoanInfo> _loanData){
   return BookingAndLoan(bookingData: _bookingData, loanData: _loanData);
  }
}
