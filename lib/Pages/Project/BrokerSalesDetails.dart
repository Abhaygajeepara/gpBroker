import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Loan/LoanInfo.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';

import 'package:gpgroup/Pages/Project/Loan/SingleLoan.dart';
import 'package:gpgroup/Service/ProjectRetrieve.dart';

import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:provider/provider.dart';
class BrokerCommission extends StatefulWidget {
  @override
  _BrokerCommissionState createState() => _BrokerCommissionState();
}

class _BrokerCommissionState extends State<BrokerCommission> {

  bool loading = true;
  DateTime now = DateTime.now();
  int desireMonth ;
  int desireYear ;
  List<SinglePropertiesLoanInfo> desireMonthRemaining=[];
  List<SinglePropertiesLoanInfo> desireMonthPaid=[];
  // index
  int projectIndex =0;
  int subIndex =0;
  int totalAmount=0;
  int remainingAmount=0;
  int paidAmount=0;
  List monthList = [1,2,3,4,5,6,7,8,9,10,11,12];
  // index end
  setData(ProjectRetrieve _projectRetrieve,List clients)async{

    await _projectRetrieve.checkBrokercommission(clients);

  }
  setDesiredMonthData(CommissionCountModel _commissionData)async{
    desireMonthRemaining=[];
    desireMonthPaid=[];
    totalAmount=0;
    remainingAmount=0;
    paidAmount=0;
    for(int j=0;j<_commissionData.remainingEmi.length;j++){
      int localMonth =_commissionData.remainingEmi[j].installmentDate.toDate().month;
      int localYear = _commissionData.remainingEmi[j].installmentDate.toDate().year  ;
      if(localMonth== desireMonth && localYear == desireYear){
        totalAmount = totalAmount +_commissionData.remainingEmi[j].brokerCommission;
        remainingAmount = remainingAmount +_commissionData.remainingEmi[j].brokerCommission;
        desireMonthRemaining.add(_commissionData.remainingEmi[j]);


      }
    }
    for(int k=0;k<_commissionData.paidEmi.length;k++){
      int localMonth =_commissionData.paidEmi[k].installmentDate.toDate().month;
      int localYear = _commissionData.paidEmi[k].installmentDate.toDate().year  ;
      if(localMonth== desireMonth && localYear == desireYear){
        totalAmount = totalAmount +_commissionData.paidEmi[k].brokerCommission;
        paidAmount = paidAmount +_commissionData.paidEmi[k].brokerCommission;
        desireMonthPaid.add(_commissionData.paidEmi[k]);


      }
    }

    print(desireMonthPaid);

    // setState(() {
    //   loading =false;
    // });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    desireMonth = now.month;
    desireYear = now.year;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final _projectRetrieve = Provider.of<ProjectRetrieve>(context);

    List<String> subScroll = [
      '${desireMonth}-${desireYear}',
      AppLocalizations.of(context).translate('RemainingEMI'),
      AppLocalizations.of(context).translate('PaidEMI'),

    ];
    Widget selectDate(){
      final size = MediaQuery.of(context).size;

      showDialog(
          context: context,
          builder: (context){
            return Container(

              child: AlertDialog(

                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButtonFormField(
                        decoration: commoninputdecoration.copyWith(
                            labelText: AppLocalizations.of(context)
                                .translate('Month')),
                        value: desireMonth,
                        onChanged: (val){
                          setState(() {
                            desireMonth = val;

                          });
                        },
                        items: monthList.map((e){
                          return DropdownMenuItem(
                              value: e,
                              child: Row(
                                children: [
                                  Text(e.toString())
                                ],

                              )
                          );
                        }).toList(),
                      ),
                      SizedBox(height: size.height*0.02,),
                      TextFormField(

                        initialValue: desireYear.toString(),
                        onChanged: (val)=>desireYear =int.parse( val),
                        decoration: commoninputdecoration.copyWith(
                            labelText: AppLocalizations.of(context)
                                .translate('Year')),

                      )
                    ],
                  )
              ),
            );
          }
      );
    }
    final size = MediaQuery.of(context).size;
    final dividerheight = size.height*0.01;
    return Scaffold(
      appBar: CommonAppbar(
        AppLocalizations.of(context).translate('Income'),
          IconButton(icon: Icon(Icons.date_range), onPressed: (){
            selectDate();
          })),
      body: StreamBuilder<BrokerModel>(
          stream: _projectRetrieve.SINGLEBROKERDATA,
          builder: (context,brokerSnapshot){
            if(brokerSnapshot.hasData){
              setData(_projectRetrieve, brokerSnapshot.data.clients);

              return StreamBuilder<List<CommissionCountModel>>(
                  stream: _projectRetrieve.ACCOUNTCOMMISSION,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      if(snapshot.data.length>0){
                        setDesiredMonthData(snapshot.data[projectIndex]);
                      }
                      //padding:  EdgeInsets.symmetric(horizontal: size.width*0.01,vertical: size.height*0.01),
                      return snapshot.data.length<=0?
                      Center(child: Text(
                        AppLocalizations.of(context).translate('NoData'),
                        style: TextStyle(
                            color: CommonAssets.errorColor,
                            fontSize: size.height*0.05
                        ),
                      ),):
                      RefreshIndicator(
                        onRefresh: ()async{
                          setData(_projectRetrieve, brokerSnapshot.data.clients);
                          setState(() {

                          });
                        },
                        child: Padding(
                          padding:  EdgeInsets.fromLTRB(0,size.height*0.01,0,0 ),
                          child: Column(
                            children: [
                              Container(
                                height: size.height*0.07,
                                // decoration: BoxDecoration(
                                //   boxShadow: [
                                //     BoxShadow(
                                //       color: Colors.white,
                                //       offset: Offset(0.0, 1.0), //(x,y)
                                //       blurRadius: 1.0,
                                //     ),
                                //   ],
                                // ),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context,index){
                                      return GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            projectIndex = index;
                                          });
                                        },
                                        child: Container(
                                            width: size.width/3,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color:projectIndex!=index? Colors.transparent:Theme.of(context).primaryColor,
                                                ),


                                              ),

                                            ),
                                            child: Center(child: Text(snapshot.data[index].projectName,
                                              style: TextStyle(
                                                  color:projectIndex!=index? CommonAssets.normalTextColor:Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.height*0.02
                                              ),
                                            ),
                                            )),
                                      );
                                    }),
                              ),
                              Divider(height: dividerheight,),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.01),
                                // decoration: BoxDecoration(
                                //   boxShadow: [
                                //     BoxShadow(
                                //       color: Colors.white,
                                //       offset: Offset(0.0, 1.0), //(x,y)
                                //       blurRadius: 1.0,
                                //     ),
                                //   ],
                                // ),
                                height:  size.height*0.07,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: subScroll.length,
                                    itemBuilder: (context,index){
                                      return GestureDetector(
                                        onTap: (){
                                          setState(() {

                                            subIndex = index;
                                          });
                                        },
                                        child: Container(
                                            width: size.width/3,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: subIndex!=index? Colors.transparent:Theme.of(context).primaryColor,
                                                )
                                              )
                                            ),
                                            child: Center(child: Text(subScroll[index],
                                              style: TextStyle(
                                                  color:subIndex!=index? CommonAssets.normalTextColor:Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.height*0.02
                                              ),
                                            ),
                                            )),
                                      );
                                    }),
                              ),
                              Divider(height: dividerheight,),
                              Expanded(
                                  child: redirectWidget(snapshot.data[projectIndex],_projectRetrieve,context)
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    else if (snapshot.hasError) {
                      return Container(
                        child: Center(
                          child: Text(
                            snapshot.error.toString(),
                            // CommonAssets.snapshoterror,
                            style: TextStyle(color: CommonAssets.errorColor),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                          height: size.height,
                          child: Center(child: CircularLoading()));
                    }
                  });
            }
            else if (brokerSnapshot.hasError) {
              return Container(
                child: Center(
                  child: Text(
                    brokerSnapshot.error.toString(),
                    // CommonAssets.snapshoterror,
                    style: TextStyle(color: CommonAssets.errorColor),
                  ),
                ),
              );
            } else {
              return Container(
                  height: size.height,
                  child: Center(child: CircularLoading()));
            }
          }),
    );
  }

  redirectWidget(CommissionCountModel commissionCountModel,ProjectRetrieve _projectRetrieve,BuildContext context) {

    String projectName = commissionCountModel.projectName;
    if(subIndex ==0){
      return  selectedMomthData( _projectRetrieve, projectName);
    }
    else if(subIndex ==1){
      // remainingEmi;
      return EMIWidget(commissionCountModel.remainingEmi,false,_projectRetrieve,projectName);
    }
    else{
      // padiEmi;
      return EMIWidget(commissionCountModel.paidEmi,true,_projectRetrieve,projectName);
    }
  }

  selectedMomthData(
      ProjectRetrieve _projectRetrieve,String projectName){
    final size =MediaQuery.of(context).size;
    final fontSize = size.height*0.02;
    final spcaeVertical  = size.height*0.01;
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: EMIWidget(desireMonthRemaining,false,_projectRetrieve,projectName)),
              Expanded(child: EMIWidget(desireMonthPaid,true,_projectRetrieve,projectName))
            ],
          ),
        ),
        Padding(
          padding:  EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.01),
          child: Container(
              padding: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.01),
              decoration: BoxDecoration(
                color:  Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10.0),

              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Text(
                          AppLocalizations.of(context).translate('Total'),
                          style: TextStyle(
                              color: CommonAssets.AppbarTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context).translate('Income'),
                          style: TextStyle(
                              color: CommonAssets.AppbarTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize
                          ),
                        ),

                        SizedBox(
                          height: spcaeVertical,
                        ),
                        Text(
                          totalAmount.toString(),
                          style: TextStyle(
                              color: CommonAssets.AppbarTextColor,

                              fontSize: fontSize
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Text(
                          AppLocalizations.of(context).translate('Received'),
                          style: TextStyle(
                              color: CommonAssets.AppbarTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context).translate('Income'),
                          style: TextStyle(
                              color: CommonAssets.AppbarTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize
                          ),
                        ),
                        SizedBox(
                          height: spcaeVertical,
                        ),
                        Text(
                          paidAmount.toString(),
                          style: TextStyle(
                              color: CommonAssets.AppbarTextColor,

                              fontSize: fontSize
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Text(
                          AppLocalizations.of(context).translate('Remaining'),
                          style: TextStyle(
                              color: CommonAssets.AppbarTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context).translate('Income'),
                          style: TextStyle(
                              color: CommonAssets.AppbarTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize
                          ),
                        ),

                        SizedBox(
                          height: spcaeVertical ,
                        ),
                        Text(
                          remainingAmount.toString(),
                          style: TextStyle(
                              color: CommonAssets.AppbarTextColor,

                              fontSize: fontSize
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
          ),
        )
      ],
    );
  }

  EMIWidget( List<SinglePropertiesLoanInfo> singlePropertiesLoanInfo,
      bool isPaidEmiData,ProjectRetrieve _projectRetrieve,String projectName){
    Color amountTextColor = isPaidEmiData?CommonAssets.receivedAmountColor:CommonAssets.remainingAmountColor;
    singlePropertiesLoanInfo.sort((a,b)=>a.installmentDate.compareTo(b.installmentDate));
    final size =MediaQuery.of(context).size;
    final labelFontSize = size.height*0.02;
    return ListView.builder(
        itemCount: singlePropertiesLoanInfo.length,
        itemBuilder: (context,index){
          return Card(
            child: ListTile(
                onTap: ()async{
                  // project is set on parent redirectWidget
                  await _projectRetrieve.setProjectName(projectName);
                  await _projectRetrieve.setPropertiesLoanRef(singlePropertiesLoanInfo[index].loanId);
                  Navigator.push(context, PageRouteBuilder(
                    //    pageBuilder: (_,__,____) => BuildingStructure(),
                    pageBuilder: (_,__,___)=> LoanInfo(),
                    transitionDuration: Duration(milliseconds: 0),
                  ));
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text(singlePropertiesLoanInfo[index].emiId.toString(),style: TextStyle(
                        color: amountTextColor
                    ),),),
                    Flexible(child: Text("₹"+singlePropertiesLoanInfo[index].brokerCommission.toString(),
                      style: TextStyle(
                          color: amountTextColor
                      ),
                    ),),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context).translate('LoanId'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: labelFontSize
                    ),
                    ),
                    Text(singlePropertiesLoanInfo[index].loanId.toString()),
                    Text(AppLocalizations.of(context).translate('EMIDate'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: labelFontSize
                      ),),
                    Text(singlePropertiesLoanInfo[index].installmentDate.toDate().toString().substring(0,16)),

                    isPaidEmiData?  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).translate('Payment')),
                        Text(singlePropertiesLoanInfo[index].paymentTime.toDate().toString().substring(0,16)),
                      ],
                    ):Container(),
                  ],
                )



            ),
          );
        });

  }



}
