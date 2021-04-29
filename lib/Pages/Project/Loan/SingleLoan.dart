import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/Widgets/toaster.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Loan/LoanInfo.dart';

import 'package:gpgroup/Model/Project/InnerData.dart';
import 'package:gpgroup/Model/Users/CustomerModel.dart';
import 'package:gpgroup/Pages/Project/Loan/PaidEmiDetails.dart';




import 'package:path_provider/path_provider.dart';

import 'package:gpgroup/Service/ProjectRetrieve.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:provider/provider.dart';

class LoanInfo extends StatefulWidget {

  @override
  _LoanInfoState createState() => _LoanInfoState();
}

class _LoanInfoState extends State<LoanInfo> {
  final  _formKey = GlobalKey<FormState>();

  bool emiPage = false;
  int totalEmi =  0;
  int paidEmi = 0;
  int remainingEmi = 0;
  int pageIndex =0;
  int emiAmount =0;
  List<SinglePropertiesLoanInfo> paidEmiData =[];
  List<SinglePropertiesLoanInfo> remainingEmiData =[];

  String pdfPath ;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final projectRetrieve = Provider.of<ProjectRetrieve>(context);

    final size = MediaQuery.of(context).size;

    // projectRetrieve.setProjectName('vrajraj', 'House');
    // projectRetrieve.setLoanRef('(1)vrajraj-0-2');
    //
    // projectRetrieve.setPartOfSociety('0', '2');
    calculation(List<SinglePropertiesLoanInfo> loanData,BookingDataModel bookingDataModel){
      remainingEmiData=[];
      paidEmiData =[];
      totalEmi =  0;
      paidEmi = 0;
      remainingEmi = 0;

      totalEmi = loanData.length;
      for(int i=0;i<loanData.length;i++){

        emiAmount = loanData[i].amount;
        int _paidAmount =0;
        int _remainingAmount = 0;
        int emiNumber =i+1;

        //   print(totalEmi);
        if(loanData[i].emiPending){
          remainingEmi = remainingEmi+1;
          remainingEmiData.add(loanData[i]);


        }
        else{
          paidEmi =paidEmi +1;
          paidEmiData.add(loanData[i]);

        }
        _paidAmount = emiNumber*emiAmount;
        _remainingAmount = (emiAmount*totalEmi)-(emiAmount * emiNumber);


      }

      loading = false;
    }

    return Scaffold(

      appBar: CommonAppbar(
        projectRetrieve.loadId,
          Container()),
      body:SingleChildScrollView(
        child: StreamBuilder<BookingAndLoan>(
            stream: projectRetrieve.BOOKINGANDLOAN(),
            builder: (context,snapshot){
              if(snapshot.hasData)
              {
                //  projectRetrieve.setPartOfSociety(snapshot.data.bookingData.part,snapshot.data.bookingData.propertiesNumber);
                calculation(snapshot.data.loanData,snapshot.data.bookingData);
                return !emiPage? propertiesInfo(snapshot.data):emiType(snapshot.data);

              }
              else if(snapshot.hasError) {
                return Container(
                  child: Center(
                    child: Text(
                      snapshot.error.toString(),
                      // CommonAssets.snapshoterror,
                      style: TextStyle(
                          color: CommonAssets.errorColor
                      ),
                    ),
                  ),
                );
              }
              else{
                return Container(
                    height: size.height,
                    child: Center(child: CircularLoading()));
              }
            }
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:  RaisedButton(
        shape: StadiumBorder(),
        onPressed: (){
          setState(() {
            emiPage = !emiPage;
            loading = true;

          });
        },
        child: Text(!emiPage ?
        AppLocalizations.of(context).translate('LoanInformation')
            :AppLocalizations.of(context).translate('PropertyInformation'),
          style: TextStyle(
              color: CommonAssets.buttonTextColor
          ),
        ),
      ),

    );
  }
  Widget emiType(BookingAndLoan snapshot){
    final size = MediaQuery.of(context).size;
    final fontSize = size.height*0.017;
    List<String> titleList =[
      AppLocalizations.of(context).translate('AllEMI')+"(${snapshot.loanData.length.toString()})",
      AppLocalizations.of(context).translate('PaidEMI')+"(${paidEmi})",
      AppLocalizations.of(context).translate('RemainingEMI')+"(${remainingEmi})"
    ];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height *0.01,horizontal: size.width *0.01),
      child: Container(
        height: size.height,
        child: Column(
          children: [
            Container(
              height: size.height*0.05,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: titleList.length,
                  itemBuilder: (context,index){
                    return Container(
                      width: size.width /3.3,
                      child: GestureDetector(
                          onTap: (){
                            setState(() {

                              pageIndex = index;
                              // print(pageIndex);
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: pageIndex == index? Theme.of(context).primaryColor:Colors.transparent
                                      )
                                  )
                              ),
                              child: Center(child: AutoSizeText(
                                titleList[index],
                                maxLines: 2,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize
                                ),
                              )))),
                    );
                  }),
            ),
            SizedBox(height: size.height*0.02,),
            Expanded(child: loanRedirectionWidget(snapshot))
          ],
        ),
      ),
    );
  }
  Widget loanRedirectionWidget(BookingAndLoan snapshot){
    print(pageIndex);
    if(pageIndex==1){
// paid  emi
      return loanInfo(paidEmiData);
    }
    else if(pageIndex == 2){
// remaining emi
      return loanInfo(remainingEmiData);
    }
    else  {
      // all emi

      return statement(snapshot);
    }
  }

  Widget statement(BookingAndLoan snapshot){
    final projectRetrieve = Provider.of<ProjectRetrieve>(context);

    final size= MediaQuery.of(context).size;
    final spaceVer = size.height*0.01;

    final fontSize  = size.height*0.02;
    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width *0.01),
        child: Column(

          children: [
            /*
         *  AppLocalizations.of(context).translate('AllEMI')+"(${snapshot.loanData.length.toString()})",
       AppLocalizations.of(context).translate('PaidEMI')+"(${paidEmi})",
       AppLocalizations.of(context).translate('RemainingEMI')+"(${remainingEmi})"*/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).translate('MonthlyEMI'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize
                  ),
                ),
                Flexible(child: Text(
                  emiAmount.toString(),
                  style: TextStyle(
                      fontSize: fontSize
                  ),
                ))

              ],
            ),
            Divider(color: CommonAssets.normalTextColor,),
            SizedBox(height: spaceVer,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).translate('AllEMI')+' '+AppLocalizations.of(context).translate('Amount'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize
                  ),
                ),
                Flexible(child: Text(
                  (emiAmount*snapshot.loanData.length).toString(),
                  style: TextStyle(
                      fontSize: fontSize
                  ),
                ))

              ],
            ),
            SizedBox(height: spaceVer,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).translate('Paid')+' '+AppLocalizations.of(context).translate('Amount'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize
                  ),
                ),
                Flexible(child: Text((emiAmount*paidEmi).toString(),
                  style: TextStyle(
                      fontSize: fontSize
                  ),))

              ],
            ),
            SizedBox(height: spaceVer,),
            Divider(color: CommonAssets.normalTextColor,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).translate('Remaining')+' '+AppLocalizations.of(context).translate('Amount'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize
                  ),),
                Flexible(child: Text((emiAmount*remainingEmi).toString(),
                  style: TextStyle(
                      fontSize: fontSize
                  ),))

              ],
            ),
            Divider(color: CommonAssets.normalTextColor,),
            SizedBox(height: spaceVer,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).translate('Previous')+' '+AppLocalizations.of(context).translate('EMI'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize
                  ),
                ),
                Flexible(child: Text(
                  paidEmiData.length>0?paidEmiData.last.installmentDate.toDate().toString().substring(0,10):"",
                  style: TextStyle(
                      fontSize: fontSize
                  ),
                ))

              ],
            ),
            SizedBox(height: spaceVer,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).translate('Next')+' '+AppLocalizations.of(context).translate('EMI'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize
                  ),
                ),
                Flexible(child: Text(
                  remainingEmiData.length>0?remainingEmiData.first.installmentDate.toDate().toString().substring(0,10):"",
                  style: TextStyle(
                    fontSize: fontSize,

                  ),))

              ],
            ),
            SizedBox(height: spaceVer*4,),

          ],
        ),
      ),
    );
    // return RaisedButton(
    //   onPressed: ()async{
    //     pdfPath =  await  GeneratePdf().createPdf(statementList,snapshot,projectRetrieve.projectName,projectRetrieve.partOfSociety);
    //     setState(() {
    //
    //     });
    //     return   await Navigator.push(
    //       context,
    //       PageRouteBuilder(
    //         pageBuilder: (_, __, ___) => PdfPreviewScreen(path: pdfPath,),
    //         transitionDuration: Duration(seconds: 0),
    //       ),
    //     );
    //   },
    // );

  }
  Widget loanInfo(List<SinglePropertiesLoanInfo> snapshot){
    final size = MediaQuery.of(context).size;

    Timestamp nowStamp = Timestamp.now();
    return Container(
      //  height: size.height *0.8,
      child: ListView.builder(
          itemCount: snapshot.length,
          itemBuilder: (context,emiIndex){
            final lateEmiIndex = nowStamp.compareTo(snapshot[emiIndex].installmentDate);
            print('asd${lateEmiIndex}');
            // if lateEmiIndex is -1 then emi is late

            Color borderColor =!snapshot[emiIndex].emiPending? CommonAssets.boxBorderColors:lateEmiIndex==1?CommonAssets.remainingEmiBoxBorderColors:CommonAssets.boxBorderColors;
            return Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: borderColor
                  )
              ),
              color: snapshot[emiIndex].emiPending ? CommonAssets.paidEmiCardColor:Colors.white,
              child: ListTile(
                onTap: (){

                  return  snapshot[emiIndex].emiPending?toaster(AppLocalizations.of(context).translate('RemainingEMI')):
                  Navigator.push(context, PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>PaidEmiDetails(singlePropertiesLoanInfo:  snapshot[emiIndex],),
                    transitionDuration: Duration(seconds: 0),
                  ),);


                },
                title: Text(snapshot[emiIndex].emiId.toString(),style: TextStyle(
                    fontWeight: FontWeight.bold
                ),),
                subtitle: Text(snapshot[emiIndex].installmentDate.toDate().toString().substring(0,10)),
              ),
            );
          }
      ),
    );
  }

  Widget propertiesInfo(BookingAndLoan snapshot) {
    final size = MediaQuery.of(context).size;
    final titileSize = size.height /size.width  *8 ;
    final mainTitileSize = size.height /size.width *16 ;
    final normatTextSize = size.height /size.width  *7;
    final fontWeight =FontWeight.bold;
    final  verticalSizeBox = size.height *0.05;
    final  expanedTileSpace =size.height *0.012;
    final fontSize = size.height *0.02;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Center(
                child: Text(
                  snapshot.bookingData.propertiesNumber.toString(),
                  style: TextStyle(
                      fontSize: mainTitileSize,
                      fontWeight: fontWeight
                  ),
                )
            ),
            Divider(color: Theme.of(context).dividerColor,thickness:2 ,),
            // customer information

            ExpansionTile(
              childrenPadding: EdgeInsets.all(8),
              title: Text(
                AppLocalizations.of(context).translate('BrokerInformation'),
                style: TextStyle(
                    fontSize: titileSize,
                    fontWeight: fontWeight
                ),
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('BrokerID'),
                      style: TextStyle(
                          fontSize: titileSize,
                          fontWeight: fontWeight
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: size.width *0.65,
                      child: new SingleChildScrollView(
                        scrollDirection: Axis.horizontal,//.horizontal
                        child: new Text(
                          snapshot.bookingData.brokerReference,
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: titileSize,

                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: expanedTileSpace,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('BrokerCommission'),
                      style: TextStyle(
                          fontSize: titileSize,
                          fontWeight: fontWeight
                      ),
                    ),
                    Text(
                      snapshot.bookingData.brokerCommission.toString(),
                      style: TextStyle(
                        fontSize: normatTextSize,

                      ),
                    )
                  ],
                ),
                SizedBox(height: expanedTileSpace,),
              ],
            ),
            ExpansionTile(
              childrenPadding: EdgeInsets.all(8),
              title: Text(
                AppLocalizations.of(context).translate('PropertyInformation'),
                style: TextStyle(
                    fontSize: titileSize,
                    fontWeight: fontWeight
                ),
              ),

              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('SquareFeet'),
                      style: TextStyle(
                          fontSize: titileSize,
                          fontWeight: fontWeight
                      ),
                    ),
                    Text(
                      snapshot.bookingData.squareFeet.toString(),
                      style: TextStyle(
                        fontSize: normatTextSize,

                      ),
                    )
                  ],
                ),
                SizedBox(height: expanedTileSpace,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('PricePerSqFt'),
                      style: TextStyle(
                          fontSize: titileSize,
                          fontWeight: fontWeight
                      ),
                    ),
                    Text(
                      snapshot.bookingData.pricePerSquareFeet.toString(),
                      style: TextStyle(
                        fontSize: normatTextSize,

                      ),
                    )
                  ],
                ),
                SizedBox(height: expanedTileSpace,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('BookingDate'),
                      style: TextStyle(
                          fontSize: titileSize,
                          fontWeight: fontWeight
                      ),
                    ),
                    Text(
                      snapshot.bookingData.cusBookingDate.toDate().toString().substring(0,19),
                      style: TextStyle(
                        fontSize: normatTextSize,

                      ),
                    )
                  ],
                ),
                SizedBox(height: expanedTileSpace,),
              ],
            ),
            ExpansionTile(
              childrenPadding: EdgeInsets.all(8),
              title: Text(
                AppLocalizations.of(context).translate('LoanInformation'),
                style: TextStyle(
                    fontSize: titileSize,
                    fontWeight: fontWeight
                ),
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('LoanId'),
                      style: TextStyle(
                          fontSize: titileSize,
                          fontWeight: fontWeight
                      ),
                    ),
                    Text(
                      snapshot.bookingData.loanReferenceCollectionName,
                      style: TextStyle(
                        fontSize: normatTextSize,

                      ),
                    )
                  ],
                ),
                SizedBox(height: expanedTileSpace,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('MonthlyEMI'),
                      style: TextStyle(
                          fontSize: titileSize,
                          fontWeight: fontWeight
                      ),
                    ),
                    Text(
                      snapshot.bookingData.perMonthEMI.toString(),
                      style: TextStyle(
                        fontSize: normatTextSize,

                      ),
                    )
                  ],
                ),
                SizedBox(height: expanedTileSpace,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('TotalEMI'),
                      style: TextStyle(
                          fontSize: titileSize,
                          fontWeight: fontWeight
                      ),
                    ),
                    Text(
                      snapshot.bookingData.totalEMI.toString(),
                      style: TextStyle(
                        fontSize: normatTextSize,

                      ),
                    )
                  ],
                ),
                SizedBox(height: expanedTileSpace,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('StartingDateOfLoan'),
                      style: TextStyle(
                          fontSize: titileSize,
                          fontWeight: fontWeight
                      ),
                    ),
                    Text(
                      snapshot.bookingData.loanStartingDate.toDate().toString().substring(0,10),
                      style: TextStyle(
                        fontSize: normatTextSize,

                      ),
                    )
                  ],
                ),
                SizedBox(height: expanedTileSpace,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('EndingDateOfLoan'),
                      style: TextStyle(
                          fontSize: titileSize,
                          fontWeight: fontWeight
                      ),
                    ),
                    Text(
                      snapshot.bookingData.loanStartingDate.toDate().toString().substring(0,10),
                      style: TextStyle(
                        fontSize: normatTextSize,

                      ),
                    )
                  ],
                ),
                SizedBox(height: expanedTileSpace,),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
