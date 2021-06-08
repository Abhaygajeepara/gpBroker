

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';
import 'package:gpgroup/Pages/Project/Loan/SingleLoan.dart';
import 'package:gpgroup/Service/ProjectRetrieve.dart';

import 'package:gpgroup/app_localization/app_localizations.dart';

import 'package:provider/provider.dart';

class BrokerClients extends StatefulWidget {
  // BrokerModel brokerModel;
  //
  // BrokerClients({@required this.brokerModel});
  @override
  _BrokerClientsState createState() => _BrokerClientsState();
}

class _BrokerClientsState extends State<BrokerClients> {

  int number ;
  // bool isSearch = false;
  // bool isSearchByName = false;
  String customerName;
  bool cancelCustomer = false;
  List<Map<String,dynamic>> dataOfClient =[];
  List<Map<String,dynamic>> searchList =[];
  List<String> activeProjectsList =[]; // contains name of different project name
  List<String> closedProjectsList =[]; // contains name of different project name
  List<List<Map<String,dynamic>>> allActiveClients =[];
  List<List<Map<String,dynamic>>> allClosedClients =[];
  int selectedProjectIndex =0;
  List<Map<String,dynamic>> demoLoanRef =[];
  BrokerModel brokerModel;
bool loading = true;

  projectWishData()async{
    activeProjectsList =[];
    closedProjectsList=[];
    allActiveClients =[];
    allClosedClients =[];


    List<Map<String,dynamic>> localActiveClients =brokerModel.clients;
    List<Map<String,dynamic>> localCancelClients =brokerModel.closedBooking;

    for(int i=0;i<localActiveClients.length;i++){

      if(!activeProjectsList.contains(localActiveClients[i]['ProjectName'])){
        activeProjectsList.add(localActiveClients[i]['ProjectName']);
      }
    }
    for(int x=0;x<localCancelClients.length;x++){
      if(!closedProjectsList.contains(localCancelClients[x]['ProjectName'])){
        closedProjectsList.add(localCancelClients[x]['ProjectName']);
      }
    }


    for(int j=0;j<activeProjectsList.length;j++){
      List<Map<String,dynamic>> _localData=[];
      for(int k=0;k<localActiveClients.length;k++){
        if(activeProjectsList[j] ==localActiveClients[k]['ProjectName'] ){
          _localData.add(localActiveClients[k]);
        }
      }
      allActiveClients.insert(j, _localData);
    }

    for(int y=0;y<closedProjectsList.length;y++){
      List<Map<String,dynamic>> _localData=[];
      for(int z=0;z<localCancelClients.length;z++){
        if(closedProjectsList[y] ==localCancelClients[z]['ProjectName'] ){
          _localData.add(localCancelClients[z]);

        }
      }
      allClosedClients.insert(y, _localData);
    }
    activeProjectsList.insert(0, "All");
    closedProjectsList.insert(0, "All");
    allActiveClients.insert(0, localActiveClients);
    allClosedClients.insert(0, localCancelClients);

    dataOfClient=allActiveClients[selectedProjectIndex];
  }

  allocate(){
    if(cancelCustomer){

      dataOfClient = allClosedClients[selectedProjectIndex];

    }
    else{
      dataOfClient = allActiveClients[selectedProjectIndex];
    }

  }

  assignData(BrokerModel _brokerModel)async{
    brokerModel =  _brokerModel;
    demoLoanRef =brokerModel.clients;
    await  ProjectRetrieve().checkBrokercommission(demoLoanRef);
   await projectWishData();
    await allocate();
    if(mounted){
      setState(() {
        loading = false;
      });
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  @override

  Widget build(BuildContext context) {



    List<String> projectList =cancelCustomer?closedProjectsList:activeProjectsList;
    final _projectRetrieve = Provider.of<ProjectRetrieve>(context);
    final size = MediaQuery.of(context).size;
    final fontSize = size.height*0.015;
    final spaceVertical = size.height*0.01;
    final projectRetrieve = Provider.of<ProjectRetrieve>(context);
    //  projectRetrieve.setBroker('Mutant');
    // searchFind(){
    //   print(isSearch);
    //   searchList = [];
    //   for(int i=0;i<dataOfClient.length;i++){
    //     if(isSearchByName ){
    //       if(dataOfClient[i].containsValue(customerName)){
    //         searchList.add(dataOfClient[i]);
    //       }
    //     }
    //     else{
    //       if(dataOfClient[i].containsValue(number)){
    //         searchList.add(dataOfClient[i]);
    //       }
    //     }
    //
    //   }
    // }

    return Scaffold(
        appBar: CommonAppbar(
            AppLocalizations.of(context).translate('Clients'),
            Container()),
        body:StreamBuilder<BrokerModel>(
            stream: _projectRetrieve.SINGLEBROKERDATA,
            builder: (context,brokerSnapshot){
              if(brokerSnapshot.hasData){
                assignData(brokerSnapshot.data);
                return loading?CircularLoading(): Padding(
                  padding:  EdgeInsets.symmetric(horizontal: size.width*0.03,vertical: size.height*0.01),
                  child:

                  Column(
                    children: [

                      // isSearchByName ? TextFormField(
                      //
                      //   onChanged: (val){
                      //     if(val.isEmpty){
                      //       setState(() {
                      //         isSearch = false;
                      //       });
                      //     }
                      //     setState(() {
                      //       customerName = val;
                      //     });
                      //   },
                      //
                      //   decoration: commoninputdecoration.copyWith(
                      //       labelText: AppLocalizations.of(context).translate('Search'),
                      //       suffixIcon: isSearch?IconButton(icon: Icon(Icons.close), onPressed: (){
                      //         setState(() {
                      //           isSearch = false;
                      //
                      //         });
                      //       }):
                      //
                      //       IconButton(icon: Icon(Icons.search), onPressed: (){
                      //         setState(() {
                      //           isSearch = true;
                      //           searchFind();
                      //         });
                      //       })
                      //   ),
                      //
                      // ):TextFormField(
                      //   maxLength: 10,
                      //   onChanged: (val){
                      //     if(val.isEmpty){
                      //       setState(() {
                      //         isSearch = false;
                      //       });
                      //     }
                      //     setState(() {
                      //       number = int.parse(val);
                      //     });
                      //   },
                      //   decoration: commoninputdecoration.copyWith(
                      //       labelText: AppLocalizations.of(context).translate('Search'),
                      //       suffixIcon: isSearch?IconButton(icon: Icon(Icons.close), onPressed: (){
                      //         setState(() {
                      //           isSearch = false;
                      //
                      //         });
                      //       }):
                      //
                      //       IconButton(icon: Icon(Icons.search), onPressed: (){
                      //         setState(() {
                      //           isSearch = true;
                      //           searchFind();
                      //         });
                      //       })
                      //   ),
                      //
                      // ),
                      // SizedBox(height: spaceVertical,),
                      // Row(
                      //   children: [
                      //     Row(
                      //       children: [
                      //         Switch(value: cancelCustomer, onChanged: (val){
                      //           setState(() {
                      //             cancelCustomer = val;
                      //             selectedProjectIndex=0;
                      //             allocate();
                      //
                      //           });
                      //         }),
                      //
                      //         Text(
                      //
                      //           AppLocalizations.of(context).translate('CancelBooking'),
                      //           style: TextStyle(
                      //             fontSize: fontSize,
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //
                      //
                      //     Row(
                      //       children: [
                      //         Switch(value: isSearchByName, onChanged: (val){
                      //           setState(() {
                      //             isSearchByName = val;
                      //           });
                      //         }),
                      //         Text(
                      //           AppLocalizations.of(context).translate('SearchByName'),
                      //           style: TextStyle(
                      //             fontSize: fontSize,
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ],
                      // ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Switch(value: cancelCustomer, onChanged: (val){
                            setState(() {
                              cancelCustomer = val;
                              selectedProjectIndex=0;
                              allocate();

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
                      Container(
                        height: size.height*0.06,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: projectList.length,
                            itemBuilder: (context,index){
                              return Container(
                                width: size.width/4,
                                child: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      selectedProjectIndex = index;
                                    });
                                  },
                                  child: Card(

                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: selectedProjectIndex==index?CommonAssets.selectedBorderColors:CommonAssets.unselectedBorderColors
                                        ),
                                        borderRadius: BorderRadius.circular(20.0)

                                    ),
                                    color: selectedProjectIndex==index?Theme.of(context).primaryColor:CommonAssets.unSelectedItem,
                                    child: Center(child: AutoSizeText(
                                      projectList[index],
                                      style: TextStyle(
                                          color:selectedProjectIndex==index? CommonAssets.buttonTextColor:CommonAssets.unSelectedTextColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.height*0.02
                                      ),
                                    )),
                                  ),
                                ),
                              );
                            }),
                      ),

                      SizedBox(height: spaceVertical,),



                      Container(
                        height: size.height*0.5,
                          child:ListView.builder(
                              itemCount: dataOfClient.length,
                              itemBuilder: (context,index){

                                return Card(
                                  child: ListTile(
                                    onTap: ()async{
                                      await projectRetrieve.setProjectName(dataOfClient[index]['ProjectName']);
                                      await projectRetrieve.setPropertiesLoanRef(dataOfClient[index]['LoanRef']);
                                      return    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (_, __, ___) => LoanInfo(),
                                          transitionDuration: Duration(seconds: 0),
                                        ),
                                      );
                                    },
                                    title: Text("${dataOfClient[index]['LoanRef']} "),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(dataOfClient[index]['ProjectName']),
                                        // Text(dataOfClient[index]['PhoneNumber'].toString())
                                      ],
                                    ),
                                  ),
                                );
                              })
                      )
                    ],
                  ),
                );
              }
              else if (brokerSnapshot.hasError) {
                return Container(
                  child: Center(
                    child: Text(
                      //brokerSnapshot.error.toString(),
                      CommonAssets.snapshoterror,
                      style: TextStyle(color: CommonAssets.errorColor),
                    ),
                  ),
                );
              } else {
                return Container(
                    height: size.height,
                    child: Center(child: CircularLoading()));
              }
            })
    );
  }
}
