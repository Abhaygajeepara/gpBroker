import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/Widgets/AppDrawer.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Income/Income.dart';
import 'package:gpgroup/Model/Project/ProjectDetails.dart';

import 'package:gpgroup/Model/User.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';
import 'package:gpgroup/Pages/Project/Wallet/Wallet.dart';
import 'package:gpgroup/Service/Auth/LoginAuto.dart';
import 'package:gpgroup/Service/ProjectRetrieve.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  String brokerID;
  String token ;
  bool loading = true;
  List<IncomeModel> _data;
  int receivedCommission = 0;
  int totalCommission = 0;
  int remainingCommission =0;
  String currentMonth;
  DateTime now = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prfs();
     currentMonth  ="${now.month}-${now.year}";

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];

      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];

      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }
  Future prfs()async {
  token =await _firebaseMessaging.getToken();
   await preferences.then((SharedPreferences prefs) async{
        brokerID =  prefs.getString('BrokerId');

   });
  if(brokerID != ""){
    setState(() {
      loading = false;
    });
  }

  }



  @override
  Widget build(BuildContext context) {
  
  final projectRetrieve = Provider.of<ProjectRetrieve>(context);


  final size = MediaQuery.of(context).size;
 projectRetrieve.setBrokerId(brokerID);

    return Scaffold(
      appBar: CommonAppbar(
          Row(
            children: [


              IconButton(icon: Icon(Icons.account_balance_wallet), onPressed: ()async{
                projectRetrieve.setRecordLimit(10);
                return    Navigator.push(
                    context,
                    PageRouteBuilder(
                    pageBuilder: (_, __, ___) => BrokerWallet (),
                transitionDuration: Duration(seconds: 0),
                ));
              }
              ),
              IconButton(icon: Icon(Icons.exit_to_app), onPressed: ()async{
                await LogInAndSignIn().signouts(brokerID);
              }
              ),
            ],
          )
      ),
      body: loading ?CircularLoading(): StreamBuilder<ProjectAndAdvertise>(
          stream: projectRetrieve.BROKERDATAANDADVERTISE(),
          builder:(context,snapshot){
            if(snapshot.hasData){

           //   findCurrentMonth(snapshot.data.commission,currentMonth);
              return SingleChildScrollView(
                child: Column(
                  children: [
                    CarouselSlider.builder(
                        options: CarouselOptions(

                          // height: 400,
                          aspectRatio: 16/9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,

                          scrollDirection: Axis.horizontal,
                        ),
                        itemCount: snapshot.data.advertiseList.length,
                        itemBuilder: (BuildContext context,index){
                          return Card(
                            child: snapshot.data.advertiseList.length <=0?
                             Image.asset('assets/defaultads.png')
                            :Column(
                              children: [
                                Expanded(
                                  child: Image.network(
                                    snapshot.data.advertiseList[index].imageUrl.first,
                                    width: size.width,
                                    height:size.height *0.3 ,
                                    fit:BoxFit.fill,


                                  ),
                                ),
                                AutoSizeText(
                                  snapshot.data.advertiseList[index].description,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.width*0.05
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                    ),
                    SizedBox(height: size.height *0.01,),
                  Text(brokerID),
                    Text(AppLocalizations.of(context).translate('Language'))

                  ],
                ),
              );
            }
            else if(snapshot.hasError){
              return Container(child: Center(
                child: Text(
                  snapshot.error.toString(),
                  //CommonAssets.snapshoterror.toString(),
                  style: TextStyle(
                    color: CommonAssets.errorColor
                ),),
              ));
            }
            else{
              return CircularLoading();
            }
          } ),
      drawer: AppDrawer(),
    );
  }
}
// void findCurrentMonth(List<IncomeModel> querySnapshot,String desiredMonth){
//   print(querySnapshot.length);
//   _data =querySnapshot;
//   // _data.sort((a,b)=>a.emiMonthTimestamp.toString().compareTo(b.emiMonthTimestamp.toString()));
//  // String currentMonth  ="${now.month}-${now.year}";
//   int _index = querySnapshot.indexWhere((element) => element.month == desiredMonth);
//
//   if( _index != -1){
//     print(_data[0].month);
//     _data.insert(0, _data[_index]);
//     _data.removeAt(_index);
//
//   }
//   calculate(_data[0]);
// }
// void calculate(IncomeModel brokerSaleDetails){
//   receivedCommission = 0;
//   totalCommission = 0;
//   remainingCommission =0;
//   for(int i=0;i<brokerSaleDetails.clientData.length;i++){
//     totalCommission =totalCommission + brokerSaleDetails.clientData[i]['Commission'];
//     print(totalCommission);
//     if(brokerSaleDetails.clientData[i]['IsPay']){
//       receivedCommission =  receivedCommission+ brokerSaleDetails.clientData[i]['Commission'];
//     }else{
//       remainingCommission = remainingCommission+brokerSaleDetails.clientData[i]['Commission'];
//     }
//
//   }
// }