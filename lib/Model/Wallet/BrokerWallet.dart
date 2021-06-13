import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';

class BrokerWalletModel{
  int? amount;
  Timestamp transactionTime;
  int?/*?*/ walletBalanceAtTimeOfTransfer;
  bool? isMoneyAddToWallet;
  String? reasonOfTransfer;
  BrokerWalletModel({
    /*required*/ /*required*/ /*required*/ /*required*/ /*required*/ required this.amount,
    /*required*/ required this.transactionTime,
    /*required*/ /*required*/ required this.walletBalanceAtTimeOfTransfer,
    /*required*/ required this.isMoneyAddToWallet,
    /*required*/ /*required*/ /*required*/ /*required*/ required this.reasonOfTransfer,

});
  factory BrokerWalletModel.of(DocumentSnapshot snapshot){
    return BrokerWalletModel(
        amount: snapshot['Amount'],
        transactionTime: snapshot['Time'],
        walletBalanceAtTimeOfTransfer: snapshot['WalletBalance'],
        isMoneyAddToWallet: snapshot['IsAdd'],
        reasonOfTransfer: snapshot['Reason']);
  }
}

class BrokerWalletAndProfile{
  List<BrokerWalletModel> brokerWalletModel;
  BrokerModel brokerModel;
  BrokerWalletAndProfile({
    /*required*/ /*required*/ /*required*/ /*required*/ required this.brokerWalletModel,
    /*required*/ /*required*/ /*required*/ /*required*/ required this.brokerModel,

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