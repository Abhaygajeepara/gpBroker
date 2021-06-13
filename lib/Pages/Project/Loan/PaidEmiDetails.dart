import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Loan/LoanInfo.dart';
import 'package:gpgroup/Service/ProjectRetrieve.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:provider/provider.dart';

class PaidEmiDetails extends StatefulWidget {
  SinglePropertiesLoanInfo singlePropertiesLoanInfo;
  PaidEmiDetails({/*required*/ /*required*/ required this.singlePropertiesLoanInfo});
  @override
  _PaidEmiDetailsState createState() => _PaidEmiDetailsState();
}

class _PaidEmiDetailsState extends State<PaidEmiDetails> {
  @override
  Widget build(BuildContext context) {
    final projectRetrieve = Provider.of<ProjectRetrieve>(context);
    final size = MediaQuery.of(context).size;
    final fontWeight = FontWeight.bold;
    final fontSize = size.height *0.02;
    final minverticalSpace = size.height *0.01;
    final verticalSpace = size.height *0.02;
    return Scaffold(
      appBar: CommonAppbar(
          projectRetrieve.loadId,
          Container()),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: size.height *0.01,horizontal: size.width*0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: minverticalSpace,),
              Center(
                child: Text(
                  AppLocalizations.of(context).translate('PaidEMI'),
                  style: TextStyle(
                    fontWeight: fontWeight,
                    fontSize: size.height*0.03
                  ),
                ),
              ),
              SizedBox(height: minverticalSpace,),
              Divider(thickness: 2,color: Theme.of(context).primaryColor,),
              SizedBox(height: minverticalSpace,),
              Text(
                AppLocalizations.of(context).translate('Date'),
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight
                ),
              ),
              SizedBox(height: minverticalSpace,),
              Text(
                widget.singlePropertiesLoanInfo.paymentTime.toDate().toString().substring(0,19),
                style: TextStyle(
                  fontSize: fontSize,

                ),
              ),
            SizedBox(height: verticalSpace,),
              Text(
                AppLocalizations.of(context).translate('TypeOfPayment'),
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: fontWeight
                ),
              ),
              SizedBox(height: minverticalSpace,),
              Text(
               widget.singlePropertiesLoanInfo.typeOfPayment,
                style: TextStyle(
                    fontSize: fontSize,

                ),
              ),
              SizedBox(height: verticalSpace,),

              widget.singlePropertiesLoanInfo.typeOfPayment == "Bank"?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('BankAccountNumber'),
                      style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: fontWeight
                      ),
                    ),
                    SizedBox(height: minverticalSpace,),
                    Text(
                      widget.singlePropertiesLoanInfo.bankAccountNumber.toString(),
                      style: TextStyle(
                        fontSize: fontSize,

                      ),
                    ),
                    SizedBox(height: verticalSpace,),
                    Text(
                      AppLocalizations.of(context).translate('IFSC'),
                      style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: fontWeight
                      ),
                    ),
                    SizedBox(height: minverticalSpace,),
                    Text(
                      widget.singlePropertiesLoanInfo.ifsc.toUpperCase(),
                      style: TextStyle(
                        fontSize: fontSize,

                      ),
                    ),
                    SizedBox(height: verticalSpace,),
                  ],
                ):Container(),
              widget.singlePropertiesLoanInfo.typeOfPayment == "UPI"?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).translate('UPIID'),
                    style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: fontWeight
                    ),
                  ),
                  SizedBox(height: minverticalSpace,),
                  Text(
                    widget.singlePropertiesLoanInfo.upiId.toString(),
                    style: TextStyle(
                      fontSize: fontSize,

                    ),
                  ),
                  SizedBox(height: verticalSpace,),

                ],
              ):Container(),


              Text(
                AppLocalizations.of(context).translate('PayerName'),
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight
                ),
              ),
              SizedBox(height: minverticalSpace,),
              Text(
                widget.singlePropertiesLoanInfo.payerName,
                style: TextStyle(
                  fontSize: fontSize,

                ),
              ),

              SizedBox(height: verticalSpace,),
              Text(
                AppLocalizations.of(context).translate('ReceiverName'),
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight
                ),
              ),
              SizedBox(height: minverticalSpace,),
              Text(
                widget.singlePropertiesLoanInfo.receiverName,
                style: TextStyle(
                  fontSize: fontSize,

                ),
              ),
              SizedBox(height: verticalSpace,),
              Text(
                AppLocalizations.of(context).translate('RelationWithCustomer'),
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight
                ),
              ),
              SizedBox(height: minverticalSpace,),
              Text(
                widget.singlePropertiesLoanInfo.relation,
                style: TextStyle(
                  fontSize: fontSize,

                ),
              ),




            ],
          ),
        ),
      ),
    );
  }
}
