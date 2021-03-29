import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpgroup/Model/Advertise/AdvertiseMode.dart';
import 'package:gpgroup/Model/AppVersion/Version.dart';
import 'package:gpgroup/Model/Income/Income.dart';
import 'package:gpgroup/Model/Loan/LoanInfo.dart';
import 'package:gpgroup/Model/Project/ProjectDetails.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';
import 'package:rxdart/rxdart.dart';

class ProjectRetrieve{
  String brokerId;
  String customer;
  String loadId;
  String projectName;
  setBrokerId(String id){
    this.brokerId = id;
  }
  setCustomer(String id){
    this.customer = id;
  }
  setLoanRef(String ref){
    this.loadId = ref;
  }
  setProjectName(String name){
    this.projectName = name;
  }
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection("Project");
  final CollectionReference brokerReference = FirebaseFirestore.instance.collection('Broker');
  final CollectionReference infoReference = FirebaseFirestore.instance.collection('Info');
  final CollectionReference customerReference = FirebaseFirestore.instance.collection('Customer');
  final CollectionReference adsReference = FirebaseFirestore.instance.collection('Advertise');


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
    return FirebaseFirestore.instance.collection('Loan').doc(projectName).collection(loadId).orderBy("InstallmentDate",descending:false ).snapshots().map((_listLoanData));
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
}