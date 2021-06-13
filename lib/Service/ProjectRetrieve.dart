import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpgroup/Model/Advertise/AdvertiseMode.dart';
import 'package:gpgroup/Model/AppVersion/Version.dart';
import 'package:gpgroup/Model/Income/Income.dart';
import 'package:gpgroup/Model/Loan/LoanInfo.dart';
import 'package:gpgroup/Model/Project/InnerData.dart';
import 'package:gpgroup/Model/Project/ProjectDetails.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';
import 'package:gpgroup/Model/Users/CustomerModel.dart';
import 'package:gpgroup/Model/Wallet/BrokerWallet.dart';
import 'package:rxdart/rxdart.dart';

class ProjectRetrieve{
  String? brokerId;
  String? customer;
  String?/*?*//*?*//*?*/ loadId;
  String? projectName;
  late int recordLimits ;
  String? adsId;
  setAds(String  ad){
    this.adsId = ad;
  }
  setBrokerId(String? id){
    this.brokerId = id;
  }
  setCustomer(String id){
    this.customer = id;
  }
  setPropertiesLoanRef(String? ref){
    this.loadId = ref;
  }
  setProjectName(String? name){
    this.projectName = name;
  }
  setRecordLimit(int limits){
    this.recordLimits = limits;
  }
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection("Project");
  final CollectionReference brokerReference = FirebaseFirestore.instance.collection('Broker');
  final CollectionReference infoReference = FirebaseFirestore.instance.collection('Info');
  final CollectionReference customerReference = FirebaseFirestore.instance.collection('Customer');
  final CollectionReference adsReference = FirebaseFirestore.instance.collection('Advertise');
  final CollectionReference loanReference = FirebaseFirestore.instance.collection('Loan');


  BrokerModel _SingleBrokerModel(DocumentSnapshot snapshot){

    return BrokerModel.of(snapshot);

  }
  Stream<BrokerModel> get SINGLEBROKERDATA{
    return  brokerReference.doc(brokerId).snapshots().map(_SingleBrokerModel);
  }
  List<AdvertiseModel> _advertise(QuerySnapshot querySnapshot){

    return querySnapshot.docs.map((e){
      return AdvertiseModel.of(e);
    }).toList();
  }
  Stream<List<AdvertiseModel>> get THREEADVERTISE{
    return adsReference.orderBy('IsActive',descending: false).limit(2).snapshots().map(_advertise);
  }
  Stream<ProjectAndAdvertise> BROKERDATAANDADVERTISE(){
    return Rx.combineLatest3(SINGLEBROKERDATA, THREEADVERTISE,BROKERSALESDETAILS, (BrokerModel brokerModel, List<AdvertiseModel> _adver,List<IncomeModel> _commission) {
      return ProjectAndAdvertise(brokerModel:  brokerModel, advertiseList:  _adver,commission: _commission);
    } );
  }
  List<SinglePropertiesLoanInfo> _listLoanData (QuerySnapshot querySnapshot){
    return querySnapshot.docs.map((e){
      return SinglePropertiesLoanInfo.of(e);
    }).toList();
  }
  Stream<List<SinglePropertiesLoanInfo>> get LOANINFO{
    return FirebaseFirestore.instance.collection('Loan').doc(projectName).collection(loadId!).orderBy("InstallmentDate",descending:false ).snapshots().map((_listLoanData));
  }

  List<IncomeModel> _brokerSales(QuerySnapshot snapshot){

    return  snapshot.docs.map((e) {
      // return IncomeModel.of(e);
      return IncomeModel(
          clientData: List.from(e['Transfer']),
          month: e.id,
          emiMonthTimestamp: e['MonthTimeStamp']
      );
    }).toList();
  }
  Stream<List<IncomeModel>> get BROKERSALESDETAILS{
    print(brokerId);
    return brokerReference.doc(brokerId).collection('Commission').orderBy("MonthTimeStamp",descending: false).snapshots().map(_brokerSales);
  }
  AppVersion appVersion(DocumentSnapshot snapshot){
    return AppVersion.of(snapshot);
  }
  Stream<AppVersion> get APPVERSION{
    return infoReference.doc('BrokerApp').snapshots().map(appVersion);
  }

  StreamController<List<CommissionCountModel?>> brokerCommissionController = BehaviorSubject<List<CommissionCountModel?>>();
  Stream<List<CommissionCountModel?>> get ACCOUNTCOMMISSION=>brokerCommissionController.stream;

  checkBrokercommission(List brokerPropertiesList)async{


    List<CommissionCountModel?> listOfCommissionCount = [];
    List<String?> listOfProject = [];
    List<List<Map<String,dynamic>>> allActiveClients =[];// each sub list contain same projects data
    for(int i=0;i<brokerPropertiesList.length;i++){
      if(!listOfProject.contains(brokerPropertiesList[i]['ProjectName'])){
        listOfProject.add(brokerPropertiesList[i]['ProjectName']);

      }
    }
    for(int j=0;j<listOfProject.length;j++){
      List<Map<String,dynamic>> _localData=[];
      for(int k=0;k<brokerPropertiesList.length;k++){
        if(listOfProject[j] ==brokerPropertiesList[k]['ProjectName'] ){
          _localData.add(brokerPropertiesList[k]);
        }
      }
      allActiveClients.insert(j, _localData);
    }

    for(int x =0;x<allActiveClients.length;x++){
      //EMIPending  true = emi is remaining and false = emi is paid
      CommissionCountModel? _commissionCountModel;
      List<SinglePropertiesLoanInfo> paidEmi = [];
      List<SinglePropertiesLoanInfo> remainingEmi=[];
      String?/*?*/ _localProjectName = allActiveClients[x].first['ProjectName'];
      for(int y=0;y<allActiveClients[x].length;y++){

        String localRef =allActiveClients[x][y]['LoanRef'];
        // paidEmi
        await loanReference.doc(_localProjectName).collection(localRef).where('EMIPending',isEqualTo: false).get().then((event) {

          event.docs.map((e) {
            SinglePropertiesLoanInfo _singlePropertiesLoanInfo =  SinglePropertiesLoanInfo.of(e);
            paidEmi.add(_singlePropertiesLoanInfo);

          }).toList();
        });

        // remainingEmi
        await loanReference.doc(_localProjectName).collection(localRef).where('EMIPending',isEqualTo: true).get().then((event) {

          event.docs.map((e) {
            SinglePropertiesLoanInfo _singlePropertiesLoanInfo =  SinglePropertiesLoanInfo.of(e);
            remainingEmi.add(_singlePropertiesLoanInfo);

          }).toList();
        });
        _commissionCountModel = CommissionCountModel.of(_localProjectName!, paidEmi, remainingEmi);
      }

      listOfCommissionCount.add(_commissionCountModel);
    }
    brokerCommissionController.sink.add(listOfCommissionCount);

  }
  List<BrokerWalletModel> walletTransaction(QuerySnapshot querySnapshot){
    return querySnapshot.docs.map((e) {
      return BrokerWalletModel.of(e);
    }).toList();
  }
  Stream<List<BrokerWalletModel>> get BROKERWALLETTRANSCATION{
    return brokerReference.doc(brokerId).collection('Wallet').orderBy('Time',descending:true ).limit(recordLimits).snapshots().map(walletTransaction);
  }
  Stream<BrokerWalletAndProfile> BROKERWALLETANDPROFILE(){
    return Rx.combineLatest2(BROKERWALLETTRANSCATION, SINGLEBROKERDATA, (List<BrokerWalletModel> brokerWalletModel,BrokerModel brokerModel) {
      return BrokerWalletAndProfile(brokerWalletModel: brokerWalletModel, brokerModel: brokerModel);
    } );
  }
  Stream<BookingDataModel> get CUSTOMERSINGLEPROPETIES{
    return loanReference.doc(projectName).collection(loadId!).doc('BasicDetails').snapshots().map(_bookingDataModel);
  }
  BookingDataModel _bookingDataModel(DocumentSnapshot snapshot){
    return  BookingDataModel.of(snapshot,loadId!);
  }
  Stream<BookingAndLoan> BOOKINGANDLOAN(){
    return Rx.combineLatest2(CUSTOMERSINGLEPROPETIES, LOANINFO, (BookingDataModel bookingDataModel, List<SinglePropertiesLoanInfo> loanData) {
      return BookingAndLoan(bookingData: bookingDataModel, loanData : loanData);
    } );
  }

  AdvertiseModel _advertiseSingle(DocumentSnapshot snapshot){
    return AdvertiseModel.of(snapshot);

  }
  Stream<AdvertiseModel> get SINGLEADVERTISE{
    return adsReference.doc(adsId).snapshots().map(_advertiseSingle);
  }
}