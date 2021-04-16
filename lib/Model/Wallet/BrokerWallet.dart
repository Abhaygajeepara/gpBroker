import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';

class BrokerWalletModel{
  int amount;
  Timestamp transactionTime;
  int walletBalanceAtTimeOfTransfer;
  bool isMoneyAddToWallet;
  String reasonOfTransfer;
  BrokerWalletModel({
    @required this.amount,
    @required this.transactionTime,
    @required this.walletBalanceAtTimeOfTransfer,
    @required this.isMoneyAddToWallet,
    @required this.reasonOfTransfer,

});
  factory BrokerWalletModel.of(DocumentSnapshot snapshot){
    return BrokerWalletModel(
        amount: snapshot.data()['Amount'],
        transactionTime: snapshot.data()['Time'],
        walletBalanceAtTimeOfTransfer: snapshot.data()['WalletBalance'],
        isMoneyAddToWallet: snapshot.data()['IsAdd'],
        reasonOfTransfer: snapshot.data()['Reason']);
  }
}

class BrokerWalletAndProfile{
  List<BrokerWalletModel> brokerWalletModel;
  BrokerModel brokerModel;
  BrokerWalletAndProfile({
    @required this.brokerWalletModel,
    @required this.brokerModel,

});
  factory BrokerWalletAndProfile.of(List<BrokerWalletModel> brokerWalletModel,BrokerModel brokerModel){
    return BrokerWalletAndProfile(brokerWalletModel: brokerWalletModel, brokerModel: brokerModel);
  }
}
/*
* "Amount",
            "Time",
            "WalletBalance",
            "IsAdd",
            "Reason"
* */