import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/Widgets/AppDrawer.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Income/Income.dart';
import 'package:gpgroup/Model/Project/ProjectDetails.dart';

import 'package:gpgroup/Model/User.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';
import 'package:gpgroup/Pages/Ad/SingleAds.dart';
import 'package:gpgroup/Pages/Project/Loan/SingleLoan.dart';
import 'package:gpgroup/Pages/Project/Wallet/Wallet.dart';
import 'package:gpgroup/Pages/Project/ZoomImage.dart';
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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  String? brokerID;
   String? token ;
  bool loading = true;
  List<IncomeModel>? _data;
  int receivedCommission = 0;
  int totalCommission = 0;
  int remainingCommission =0;
  String? currentMonth;
  late BrokerModel profileData;
  DateTime now = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prfs();
     currentMonth  ="${now.month}-${now.year}";
    notification();
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     final notification = message['notification'];
    //
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //
    //     final notification = message['data'];
    //
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //   },
    // );
    // _firebaseMessaging.requestNotificationPermissions(
    //     const IosNotificationSettings(sound: true, badge: true, alert: true));
  }
  Future notification()async{
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      // TODO: handle the received notifications
    } else {
      print('User declined or has not accepted permission');
    }
  }
  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
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
  final fontSize= size.height *0.02;
  final titleFontSize= size.height *0.02;
  final spaceVertical = size.height *0.01;
  final fontWeight = FontWeight.bold;
 projectRetrieve.setBrokerId(brokerID);

    return Scaffold(
      appBar: CommonAppbar(
          AppLocalizations.of(context).translate('Vrajraj')+' '+AppLocalizations.of(context).translate('Corporation'),
          Row(
            children: [


              IconButton(icon: Icon(Icons.account_balance_wallet), onPressed: ()async{
                projectRetrieve.setRecordLimit(10);
                    Navigator.push(
                    context,
                    PageRouteBuilder(
                    pageBuilder: (_, __, ___) => BrokerWallet (),
                transitionDuration: Duration(seconds: 0),
                ));
              }
              ),
              IconButton(icon: Icon(Icons.person), onPressed: (){
                    AwesomeDialog(
                  context: context,

                  dialogType: DialogType.INFO,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Dialog Title',
                  body:loading?CircularLoading():   Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('BrokerName'),

                        style: TextStyle(
                            fontWeight: fontWeight,
                            fontSize: titleFontSize
                        ),
                      ),
                      SizedBox(height: spaceVertical,),
                      Text(
                        profileData.name!,
                        style: TextStyle(
                            fontSize: fontSize
                        ),
                      ),
                      SizedBox(height: spaceVertical,),
                      Text(
                        AppLocalizations.of(context).translate('MobileNumber'),
                        style: TextStyle(
                            fontWeight: fontWeight,
                            fontSize: titleFontSize
                        ),
                      ),
                      SizedBox(height: spaceVertical,),
                      Text(
                        profileData.number.toString(),
                        style: TextStyle(
                            fontSize: fontSize
                        ),
                      ),
                      Text(
                        profileData.alterNativeNumber.toString(),
                        style: TextStyle(
                            fontSize: fontSize
                        ),
                      ),
                      SizedBox(height: spaceVertical,),
                    ],
                  ),
                  // btnCancelOnPress: () {},
                  // btnOkOnPress: () {},
                )..show();
              }),
            ],
          )
      ),
      body: loading ?CircularLoading(): StreamBuilder<ProjectAndAdvertise>(
          stream: projectRetrieve.BROKERDATAANDADVERTISE(),
          builder:(context,snapshot){
            if(snapshot.hasData){
            profileData  = snapshot.data!.brokerModel;

           //   findCurrentMonth(snapshot.data.commission,currentMonth);
              return Column(
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
                      itemCount: snapshot.data!.advertiseList.length,
                      itemBuilder: (ctx, index, realIdx){
                        return snapshot.data!.advertiseList.length <=0?
                         Image.asset('assets/default.jpg')
                        :GestureDetector(
                          onTap: () {
                            projectRetrieve.setAds(snapshot.data!.advertiseList[index].id);
                            Navigator.push(context, PageRouteBuilder(
                              //    pageBuilder: (_,__,____) => BuildingStructure(),
                              pageBuilder: (_, __, ___) => SingleAds(
                              ),
                              transitionDuration: Duration(
                                  milliseconds: 0),
                            ));
                            // Navigator.push(context, PageRouteBuilder(
                            //   //    pageBuilder: (_,__,____) => BuildingStructure(),
                            //   pageBuilder: (_, __, ___) => ImageZoom(
                            //       image: snapshot.data
                            //           .advertiseList[index].imageUrl),
                            //   transitionDuration: Duration(
                            //       milliseconds: 0),
                            // ));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: CachedNetworkImage(
                                  imageUrl:  snapshot.data!.advertiseList[index]
                                      .imageUrl.first,
                                  placeholder: (context, url) => Center(child: CircularLoading(),),
                                  errorWidget: (context, url, error) => Icon(Icons.error),

                                ),
                                // Image.network(
                                //   snapshot.data.advertiseList[index]
                                //       .imageUrl.first,
                                //   width: size.width,
                                //   height: size.height * 0.3,
                                //   fit: BoxFit.fill,
                                //
                                //
                                // ),
                              ),
                              AutoSizeText(
                                snapshot.data!.advertiseList[index]
                                    .description!,
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.05
                                ),
                              )
                            ],
                          ),
                        );
                      }
                  ),
                  SizedBox(height: spaceVertical,),
                  Divider(),
                  Column(
                    children: [
                      Text(
                          AppLocalizations.of(context).translate('Total')+' '+AppLocalizations.of(context).translate('RemainingEMI'),
                      style: TextStyle(
                        fontSize: size.height*0.03,
                        fontWeight: FontWeight.bold
                      ),

                      ),
                      SizedBox(height: spaceVertical,),
                      Text(
                        snapshot.data!.brokerModel.totalRemainingEmi.toString(),
                        style: TextStyle(
                            fontSize: size.height*0.025,

                        ),
                      )
                    ],
                  ),
                  Expanded(child: GridView.builder(
                      itemCount: snapshot.data!.brokerModel.remainingEmi.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 5),
                      ),
                      itemBuilder: (context,index){
                        return Card(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: CommonAssets.remainingAmountColor
                              ),
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: size.height*0.005,horizontal: size.width*0.01),
                            child: SingleChildScrollView(
                              child: ListTile(
                                onTap: ()async{
                                  int spalsh  =  snapshot.data!.brokerModel.remainingEmi[index].projectName!.indexOf("/");

                                  String _project =snapshot.data!.brokerModel.remainingEmi[index].projectName!.substring(0,spalsh);

                                  await projectRetrieve.setProjectName(_project,);
                                  await projectRetrieve.setPropertiesLoanRef(snapshot.data!.brokerModel.remainingEmi[index].loanRef);
                                 //  await _projectRetrieve.setPartOfSociety(widget.customerProperties[index]['Part'],widget.customerProperties[index]['PropertyNumber']);

                                  Navigator.push(context, PageRouteBuilder(
                                    pageBuilder: (_,__,___)=> LoanInfo(),
                                    transitionDuration: Duration(milliseconds: 0),
                                  ));
                                },
                                title: Text(snapshot.data!.brokerModel.remainingEmi[index].projectName!),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(snapshot.data!.brokerModel.remainingEmi[index].loanRef!),
                                    Text(snapshot.data!.brokerModel.remainingEmi[index].pendingEmi.toString()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),)

                ],
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