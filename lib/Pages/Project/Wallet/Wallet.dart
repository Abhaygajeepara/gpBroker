import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';
import 'package:gpgroup/Model/Wallet/BrokerWallet.dart';
import 'package:gpgroup/Service/ProjectRetrieve.dart';

import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BrokerWallet extends StatefulWidget {
  @override
  _BrokerWalletState createState() => _BrokerWalletState();
}

class _BrokerWalletState extends State<BrokerWallet> {
  final _formKey  = GlobalKey<FormState>();
  final _passwordFormKey  = GlobalKey<FormState>();
  int amount= 0;
  String password;
  bool passwordLoading = false;
  @override
  Widget build(BuildContext context) {
    final _projectRetrieve = Provider.of<ProjectRetrieve>(context);

    
    final size = MediaQuery.of(context).size;
    final  labelWight = FontWeight.bold;
    final labelTextSize =  size.height *0.025;
    final normalTextSize =  size.height *0.02;
    final space = size.height *0.01;
    final buttonTextSize =size.height*0.025;
    // Widget passwordShowDialog(){
    //   showDialog(
    //     builder: (context){
    //       return AlertDialog(
    //         content:  Container(
    //
    //           //width:size.width *0.8,
    //           // height: size.height *0.3,
    //           child:passwordLoading?CircularLoading(): Form(
    //               key: _passwordFormKey,
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //
    //                   TextFormField(
    //                     obscureText: true,
    //                     maxLength: 6,
    //                     decoration: loginAndsignincommoninputdecoration.copyWith(labelText:  AppLocalizations.of(context).translate('Password'),counterText: ""),
    //                     validator: (val) => val.length < 6 ?'< 6':null,
    //                     onChanged: (val)=>password =val,
    //                   ),
    //
    //                 ],
    //               )
    //           ),
    //
    //         ),
    //
    //         title: Text(AppLocalizations.of(context).translate('Password')),
    //         actions: [
    //           RaisedButton(
    //               shape: StadiumBorder(),
    //               child: Text(
    //                 AppLocalizations.of(context).translate("Submit"),
    //                 style: TextStyle(
    //                     color: CommonAssets.buttonTextColor
    //                 ),
    //               ),
    //               onPressed: ()async{
    //                 if(_passwordFormKey.currentState.validate()){
    //                   dynamic result = await _projectRetrieve.passwordInfo(password);
    //
    //                   if(result == true){
    //                    setState(() {
    //                      passwordLoading = true;
    //                    });
    //                    Navigator.pop(context);
    //
    //                   }
    //                   else{
    //                     Navigator.pop(context);
    //                     setState(() {
    //                       passwordLoading = false;
    //                     });
    //
    //
    //                   }
    //                 }
    //               })
    //         ],
    //       );
    //     },
    //     context:context,
    //
    //   );
    // }
    return Scaffold(
      appBar: CommonAppbar(
        AppLocalizations.of(context).translate('Balances'),
          Container()),
      body: StreamBuilder<BrokerWalletAndProfile>(
          stream: _projectRetrieve.BROKERWALLETANDPROFILE(),
          builder: (context,snapshot){

            if(snapshot.hasData){
              return Form(
                key: _formKey,
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: size.height*0.02),
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context).translate('Balances'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: size.height*0.03,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              snapshot.data.brokerModel.walletBalance.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: size.height*0.02,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                  SizedBox(height: space,),

                      Expanded(child: ListView.builder(
                          itemCount: snapshot.data.brokerWalletModel.length,
                          itemBuilder: (context,index){
                            Color textColor = snapshot.data.brokerWalletModel[index].isMoneyAddToWallet?CommonAssets.receivedAmountColor:CommonAssets.remainingAmountColor;
                            return Card(
                              child: ExpansionTile(

                                childrenPadding: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.01),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        snapshot.data.brokerWalletModel[index].reasonOfTransfer,
                                      style: TextStyle(
                                        color: textColor
                                      ),
                                    ),
                                    SizedBox(width: size.width*0.02,),
                                    Flexible(child: Text(
                                      snapshot.data.brokerWalletModel[index].amount.toString(),
                                      style: TextStyle(
                                          color: textColor
                                      ),
                                    ))
                                  ],
                                ),
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                       AppLocalizations.of(context).translate('Date'),
                                        style: TextStyle(
                                            color: CommonAssets.normalTextColor
                                        ),
                                      ),

                                      Flexible(child: Text(
                                        snapshot.data.brokerWalletModel[index].transactionTime.toDate().toString().substring(0,16),
                                        style: TextStyle(
                                            color: textColor
                                        ),
                                      ))
                                    ],
                                  ),
                                  SizedBox(height: size.height*0.01,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context).translate('Reason'),
                                        style: TextStyle(
                                            color: CommonAssets.normalTextColor
                                        ),
                                      ),
                                      SizedBox(width: size.width*0.02,),
                                      Flexible(child: Text(
                                        snapshot.data.brokerWalletModel[index].reasonOfTransfer,
                                        style: TextStyle(
                                            color: textColor
                                        ),
                                      ))
                                    ],
                                  ),
                                  SizedBox(height: size.height*0.01,),
                                ],
                              ),
                            );
                          })),
                      IconButton(icon: Icon(Icons.arrow_downward_outlined), onPressed: (){
                       setState(() {
                         _projectRetrieve.setRecordLimit(_projectRetrieve.recordLimits+10);
                       });
                      })
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
              return CircularLoading();
            }

          })
    );
  }
  String numbervalidtion(String value){
    Pattern pattern = '^[0-9]+';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return AppLocalizations.of(context).translate("NumberOnly");
      return 'Enter The Number Only';
    }
   else {
      return null;
    }
  }
}
