import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/Widgets/AppDrawer.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Project/ProjectDetails.dart';

import 'package:gpgroup/Model/User.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prfs();
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
    preferences.then((SharedPreferences prefs) {
      setState(() {
        brokerID = prefs.getString('BrokerId');
        loading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
  
  final projectRetrieve = Provider.of<ProjectRetrieve>(context);


  final size = MediaQuery.of(context).size;
 projectRetrieve.setBrokerId(brokerID);

    return Scaffold(
      appBar: commonappBar(IconButton(icon: Icon(Icons.exit_to_app), onPressed: ()async{
        await LogInAndSignIn().signouts(brokerID);
      })),
      body: loading ?CircularLoading(): StreamBuilder<ProjectAndAdvertise>(
          stream: projectRetrieve.BROKERDATAANDADVERTISE(),
          builder:(context,snapshot){
            if(snapshot.hasData){
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
                            child: Column(
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
