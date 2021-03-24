
import 'package:flutter/material.dart';
import 'package:gpgroup/Pages/Project/BrokerSalesDetails.dart';
import 'package:gpgroup/Pages/Project/Clients/Clients.dart';

import 'package:gpgroup/app_localization/app_localizations.dart';

class AppDrawer extends StatefulWidget {

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final spaceHor =size.width*0.01;
    return Drawer(
      child: ListView(
        children: [

          ListTile(
            onTap: ()async{
              Navigator.pop(context);
              return   await Navigator.push(
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
              return   await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => BrokerSalesDetails(),
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

         
        ],
      ),
    );
  }
}
