
import 'package:flutter/material.dart';
import 'package:gpgroup/Pages/Project/BrokerSalesDetails.dart';
import 'package:gpgroup/Pages/Project/Clients/Clients.dart';
import 'package:gpgroup/Pages/Setting/Lang/Lang.dart';
import 'package:gpgroup/Service/Auth/LoginAuto.dart';
import 'package:gpgroup/Service/ProjectRetrieve.dart';

import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
final projectRetrieve = Provider.of<ProjectRetrieve>(context);
    final size = MediaQuery.of(context).size;
    final spaceHor =size.width*0.01;
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              child:Image.asset('assets/vrajraj.png') ),
          ListTile(
            onTap: ()async{
              Navigator.pop(context);
                  Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => BrokerClients( ),
                  transitionDuration: Duration(seconds: 0),
                ),
              );



            },
            title: Row(

              children: [
                Icon(Icons.group),
                SizedBox(width: spaceHor,),
                Text(AppLocalizations.of(context).translate('Customers'))
              ],
            ),
          ),
          ListTile(
            onTap: ()async{
              Navigator.pop(context);
                  Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => BrokerCommission(),
                  transitionDuration: Duration(seconds: 0),
                ),
              );

              // return Navigator.push(context,MaterialPageRoute(builder: (context)=>Home() ));

            },
            title: Row(

              children: [
                Icon(Icons.group),
                SizedBox(width: spaceHor,),
                Text(AppLocalizations.of(context).translate('Income'))
              ],
            ),
          ),
          ListTile(
            onTap: (){
              Navigator.pop(context);
                  Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => SelectLanguage(),
                  transitionDuration: Duration(seconds: 0),
                ),
              );

              // return Navigator.push(context,MaterialPageRoute(builder: (context)=>Home() ));

            },
            title: Row(

              children: [
                Icon(Icons.group),
                SizedBox(width: spaceHor,),
                Text(AppLocalizations.of(context).translate('Language'))
              ],
            ),
          ),
          ListTile(
            onTap: ()async{
              Navigator.pop(context);
              await LogInAndSignIn().signouts(projectRetrieve.brokerId);

              // return Navigator.push(context,MaterialPageRoute(builder: (context)=>Home() ));

            },
            title: Row(

              children: [
                Icon(Icons.exit_to_app),
                SizedBox(width: spaceHor,),
                Text(AppLocalizations.of(context).translate('LogOut'))
              ],
            ),
          ),

         
        ],
      ),
    );
  }
}
