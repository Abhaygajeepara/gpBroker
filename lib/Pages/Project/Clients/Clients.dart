

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Project/ProjectDetails.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';
import 'package:gpgroup/Pages/Project/Loan/SingleLoan.dart';
import 'package:gpgroup/Service/ProjectRetrieve.dart';

import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:provider/provider.dart';

class BrokerClients extends StatefulWidget {
  // List<Map<String,dynamic>> Clientlist;
  // BrokerClients({@required this.Clientlist});
  @override
  _BrokerClientsState createState() => _BrokerClientsState();
}

class _BrokerClientsState extends State<BrokerClients> {
  int number ;
  bool isSearch = false;
  bool isSearchByName = false;
  String customerName;
  List<Map<String,dynamic>> searchList =[];
  List<Map<String,dynamic>> dataOfClient =[];
  bool cancelCustomer = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fontSize = size.height*0.015;
    final spaceVertical = size.height*0.01;
    final projectRetrieve = Provider.of<ProjectRetrieve>(context);
    searchFind( List<Map<String,dynamic>> dataList){
      print(isSearch);
      searchList = [];
      for(int i=0;i<dataList.length;i++){
        if(isSearchByName ){
          if(dataList[i].containsValue(customerName)){
            searchList.add(dataList[i]);
          }
        }
        else{
          if(dataList[i].containsValue(number)){
            searchList.add(dataList[i]);
          }
        }

      }
    }

    return Scaffold(
      appBar: commonAppbar(Container()),
      body: StreamBuilder<BrokerModel>(
          stream: projectRetrieve.SINGLEBROKERDATA,
          builder:(context,snapshot){
            if(snapshot.hasData){
              !cancelCustomer ?dataOfClient =snapshot.data.clients:dataOfClient= snapshot.data.closedBooking;
              return Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: size.width*0.03,vertical: size.height*0.01),
                    child: isSearchByName ? TextFormField(

                      onChanged: (val)=>customerName = val,
                      decoration: commoninputdecoration.copyWith(
                          labelText: AppLocalizations.of(context).translate('Search'),
                          suffixIcon: isSearch?IconButton(icon: Icon(Icons.close), onPressed: (){
                            setState(() {
                              isSearch = false;

                            });
                          }):

                          IconButton(icon: Icon(Icons.search), onPressed: (){
                            setState(() {
                              isSearch = true;
                              searchFind(dataOfClient);
                            });
                          })
                      ),

                    ):TextFormField(
                      maxLength: 10,
                      onChanged: (val)=>number = int.parse(val),
                      decoration: commoninputdecoration.copyWith(
                          labelText: AppLocalizations.of(context).translate('Search'),
                          suffixIcon: isSearch?IconButton(icon: Icon(Icons.close), onPressed: (){
                            setState(() {
                              isSearch = false;

                            });
                          }):

                          IconButton(icon: Icon(Icons.search), onPressed: (){
                            setState(() {
                              isSearch = true;
                              searchFind(dataOfClient);
                            });
                          })
                      ),

                    ),
                  ),
                  SizedBox(height: spaceVertical,),
                  SizedBox(height: spaceVertical,),
                  Row(
                    children: [
                      Checkbox(value: cancelCustomer, onChanged: (val){
                        setState(() {
                          cancelCustomer = val;
                         // allocate();

                        });
                      }),
                      Text(

                        AppLocalizations.of(context).translate('CancelBooking'),
                        style: TextStyle(
                          fontSize: fontSize,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: spaceVertical,),
                  Row(
                    children: [
                      Checkbox(value: isSearchByName, onChanged: (val){
                        setState(() {
                          isSearchByName = val;
                        });
                      }),
                      Text(
                        AppLocalizations.of(context).translate('SearchByName'),
                        style: TextStyle(
                          fontSize: fontSize,
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: spaceVertical,),
                  Expanded(
                      child:isSearch?ListView.builder(
                          itemCount: searchList.length,
                          itemBuilder: (context,index){
                            return Card(
                              child: ListTile(
                                title: Text("${searchList[index]['CustomerName']} (${searchList[index]['PhoneNumber']})"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(searchList[index]['ProjectName']),
                                    Text(searchList[index]['LoanRef'])
                                  ],
                                ),
                              ),
                            );
                          }):ListView.builder(
                          itemCount: dataOfClient.length,
                          itemBuilder: (context,index){
                            return Card(
                              child: ListTile(
                                onTap: ()async{
                                  await projectRetrieve.setProjectName(dataOfClient[index]['ProjectName']);
                                  await projectRetrieve.setLoanRef(dataOfClient[index]['LoanRef']);
                                  return    Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => SingleLoan(),
                                      transitionDuration: Duration(seconds: 0),
                                    ),
                                  );
                                },
                                title: Text("${dataOfClient[index]['CustomerName']} (${dataOfClient[index]['PhoneNumber']})"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(dataOfClient[index]['ProjectName']),
                                    Text(dataOfClient[index]['LoanRef'])
                                  ],
                                ),
                              ),
                            );
                          })
                  )
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
    );
  }
}

