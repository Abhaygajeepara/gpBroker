import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Loan/LoanInfo.dart';

import 'package:gpgroup/Service/ProjectRetrieve.dart';
import 'package:provider/provider.dart';

class SingleLoan extends StatefulWidget {

  @override
  _SingleLoanState createState() => _SingleLoanState();
}

class _SingleLoanState extends State<SingleLoan> {
  @override
  Widget build(BuildContext context) {
    final _projectRetrieve = Provider.of<ProjectRetrieve>(context);
    return Scaffold(
      appBar: CommonAppbar(Container()),
      body: StreamBuilder<List<SinglePropertiesLoanInfo>>(
        stream: _projectRetrieve.LOANINFO,
        builder: (context,snapshot){
          if(snapshot.hasData)
            {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context,emiIndex){
                    return Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: CommonAssets.boxBorderColors
                          )
                      ),
                      color: snapshot.data[emiIndex].emiPending ? CommonAssets.paidEmiCardColor:Colors.white,
                      child: ListTile(
                        onTap: (){
                          if(!snapshot.data[emiIndex].emiPending ){


                            // return    Navigator.push(context, PageRouteBuilder(
                            //   pageBuilder: (_, __, ___) =>PaidEmiDetails(singlePropertiesLoanInfo:  snapshot.data[emiIndex],),
                            //   transitionDuration: Duration(seconds: 0),
                            // ),);
                          }

                        },
                        title: Text(snapshot.data[emiIndex].emiId.toString(),style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),),
                        subtitle: Text(snapshot.data[emiIndex].installmentDate.toDate().toString().substring(0,10)),
                      ),
                    );
                  }
              );
            }
          else if(snapshot.hasError) {
            return Container(
              child: Center(
                child: Text(
                  //snapshot.error.toString(),
                  CommonAssets.snapshoterror,
                  style: TextStyle(
                      color: CommonAssets.errorColor
                  ),
                ),
              ),
            );
          }
          else{
            return CircularLoading();
          }
        },
      ),
    );
  }
}
