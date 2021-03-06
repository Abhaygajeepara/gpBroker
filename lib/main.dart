import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Model/AppVersion/Version.dart';

import 'package:gpgroup/Model/User.dart';
import 'package:gpgroup/Pages/splashScreen.dart';
import 'package:gpgroup/Service/Auth/LoginAuto.dart';
import 'package:gpgroup/Service/Lang/LangChange.dart';
import 'dart:isolate';

import 'package:gpgroup/Service/ProjectRetrieve.dart';
import 'package:gpgroup/Service/connectivity_service.dart';
import 'package:gpgroup/Wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:gpgroup/enum/connectivity_status.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize();
  runApp(Provider<ConnectivityService>.value(
    value: ConnectivityService(),
    child: Provider<LangChange>.value(
        value: LangChange(),
        child: MyApp()),
  ),
  );
}

class MyApp extends StatefulWidget {

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ReceivePort _port = ReceivePort();
  late SharedPreferences preferences;
  Locale? _oldLocale;
  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    waitting();
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState((){ });
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }
  waitting()async{
    // create a folder
   await ProjectRetrieve().storeFile();

    preferences = await SharedPreferences.getInstance();
    await preferences.setString('Version',"1.0.0");
    preferences.containsKey('Language')? preferences.getString('Language'):await preferences.setString('Language', "en_US");
    print('pref =${ preferences.getString('Language')}');
    if( preferences.getString('Language') == 'hi_IN'){
      print('select hindi');
      _oldLocale = Locale('hi', 'IN');
    }
    else if( preferences.getString('Language') == 'gu_IN'){
      _oldLocale = Locale('gu', 'IN');

      print('select gujarati');
    }
    else{
      _oldLocale = Locale('en', 'US');

      print('select english');
    }
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    final connectionProvider = Provider.of<ConnectivityService>(context);
    final lang = Provider.of<LangChange>(context);
    lang.out.listen((event) {_oldLocale = event;});
    lang.controller.add(_oldLocale);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return StreamBuilder<ConnectivityStatus>(
        stream: connectionProvider.CONNECTIONSTREAM,
        builder: (context,connectionSnapshot){
          if(connectionSnapshot.data == ConnectivityStatus.Cellular
              || connectionSnapshot.data == ConnectivityStatus.WiFi){
            return StreamBuilder<Locale?>(
                stream:   lang.out,
                builder: (context,local){
                  return StreamBuilder<AppVersion>(
                    stream: ProjectRetrieve().APPVERSION,
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        return Provider<ProjectRetrieve>.value(
                          value: ProjectRetrieve(),
                          child: MaterialApp(

                            color: Color(0xff0b4cbc),
                            title: 'Flutter Demo',
                            theme: ThemeData(
                              primaryColor:  Color(0xff079ff7),
                              buttonColor: Colors.black,
                              elevatedButtonTheme: ElevatedButtonThemeData(
                                style: ElevatedButton.styleFrom(
                                  primary: CommonAssets.registerTextColor,
                                ),),
                      backgroundColor: Colors.white,
                              //  primaryColor:  Colors.black.withOpacity(0.6),
                              bottomAppBarColor: Colors.lightBlue,

                            ),

                            supportedLocales: [
                              Locale('en', 'US'),
                              Locale('gu', 'IN'),
                              Locale('hi', 'IN'),
                            ],
                            locale: local.data,
                            // These delegates make sure that the localization data for the proper language is loaded
                            localizationsDelegates: [
                              // THIS CLASS WILL BE ADDED LATER
                              // A class which loads the translations from JSON files
                              AppLocalizations.delegate,
                              // Built-in localization of basic text for Material widgets
                              GlobalMaterialLocalizations.delegate,
                              // Built-in localization for text direction LTR/RTL
                              GlobalWidgetsLocalizations.delegate,
                            ],
                            // // Returns a locale which will be used by the app
                            // localeResolutionCallback: (locale, supportedLocales) {
                            //   // Check if the current device locale is supported
                            //   for (var supportedLocale in supportedLocales) {
                            //     if (supportedLocale.languageCode == locale.languageCode &&
                            //         supportedLocale.countryCode == locale.countryCode) {
                            //
                            //       return supportedLocale;
                            //     }
                            //   }
                            //   // If the locale of the device is not supported, use the first one
                            //   // from the list (English, in this case).
                            //   return supportedLocales.first;
                            // },
                            home: redirectWidget(snapshot.data!),
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
                        return MaterialApp(home:Scaffold(
                            body: CircularLoading() ));
                      }
                    },

                  );
                });
          } else{
            return MaterialApp(
              home: Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset('assets/NoInterNet.png'),
                    AutoSizeText(

                      "No Internet Connection Found",
                      maxLines: 4,
                      style: TextStyle(
                        fontSize: 25,

                      ),
                    )
                  ],
                ),
              ),
            );
          }
        });


  }
  Widget redirectWidget(AppVersion appVersion){
    final appcastURL =
       appVersion.download;
    final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);
    if(appVersion.active){
      if(preferences.getString('Version')== appVersion.version){
        return SplashPage();
      }else{
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(

                children: [
                  Image.asset('assets/vrajraj.png'),
                  SizedBox(height: 80,),
                  Text('Download New Version Of Application',
                  style: TextStyle(
                    fontSize: 18
                  ),
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton.icon(
                    icon: Icon(Icons.download,size: 40,),
                    style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                      shape: StadiumBorder()
                    ),
                    onPressed: ()async{
                      appDownload(appVersion);

                    }, label: Text('Download',style: TextStyle(
                    fontSize: 30,
                      color: CommonAssets.buttonTextColor
                  ),),
                  ),
                ],
              ),
            ),
          ),
        );
      }
     
    }
    else{
      return Scaffold(
        body:
        Center(
          child: SingleChildScrollView(
            child: Column(

              children: [
                Image.asset('assets/vrajraj.png'),
                SizedBox(height: 80,),
                Text('Broker Service Is Currently Stop',
                  style: TextStyle(
                      color: CommonAssets.errorColor,
                      fontSize:23
                  ),
                ),


              ],
            ),
          ),
        ),
      );
    }
  }

   appDownload(AppVersion appVersion) async{
     final storageRequest = await Permission.storage.request();
     if(storageRequest.isGranted){

       final path= await ProjectRetrieve().storeFile();
       Directory directory = Directory(path);

      final  s =  await FlutterDownloader.enqueue(
         url: appVersion.download,
         savedDir: directory.path,
         showNotification: true, // show download progress in status bar (for Android)
         openFileFromNotification: true, // click on notification to open downloaded file (for Android)
       );

     }else{
       openAppSettings();
     }
   }
}

