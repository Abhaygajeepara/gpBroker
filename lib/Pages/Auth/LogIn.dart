import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Service/Auth/LoginAuto.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool error = false;
  late String id ;
  late String password ;
  bool loading = false;
  String errorMessage='';
  final _formkey = GlobalKey<FormState>();
  bool _vision = true;
  void _visibility(){
    setState(() {
      print(_vision);
      _vision = ! _vision;
    });
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Scaffold(
      // resizeToAvoidBottomInset: false,
     body: Center(
       child: SingleChildScrollView(
         child: loading ?CircularLoading(): Form(
           key: _formkey,
           child: Padding(
               padding:  EdgeInsets.symmetric(horizontal: size.width * 0.10),
               child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [

              
                     Image.asset('assets/vrajraj.png'),
                     SizedBox(height: size.height*0.02,),

                     SizedBox(height: size.height*0.02,),
               TextFormField(
               decoration: loginAndsignincommoninputdecoration.copyWith(labelText: AppLocalizations.of(context).translate('Broker')+ AppLocalizations.of(context).translate('Id')),
           validator: (val) => val!/*!*/.isEmpty ?AppLocalizations.of(context).translate('Broker')+AppLocalizations.of(context).translate('Id'):null,
           onChanged: (val)=> id =val,
         ),
                     SizedBox(height: size.height*0.02,),
           TextFormField(
             obscureText: _vision,
             decoration: loginAndsignincommoninputdecoration.copyWith(labelText:  AppLocalizations.of(context).translate('Password'),suffixIcon: IconButton(
               onPressed:_visibility,
               icon:_vision == true ? Icon(Icons.visibility_off,color:  Colors.black,):Icon(Icons.visibility,color: Colors.black),),
               errorStyle: TextStyle(
                 fontSize: 14.0,
                 fontWeight: FontWeight.w400,
                 color: Colors.red,


               ),),
             validator: (val) => val!.isEmpty ?AppLocalizations.of(context).translate('EnterPassword'):null,
             onChanged: (val)=> password =val,

           ),
           SizedBox(height: size.height*0.015,),
                   error?  AutoSizeText(
                       errorMessage,
                      maxLines: 2,
                      style: TextStyle(
                        color: CommonAssets.errorColor,
                        fontSize: size.height*0.02
                      ),
                     ):Container(),
                     SizedBox(height: size.height*0.015,),
           ElevatedButton(
             style: ElevatedButton.styleFrom(
               padding: EdgeInsets.symmetric(horizontal: size.width * 0.15,vertical: size.height * 0.02),
               shape: StadiumBorder(),
             //  primary: CommonAssets.registerTextColor,
             ),

             onPressed: ()async{
              if(_formkey.currentState!.validate()){
                setState(() {
                  loading = true;
                });
            final result =  await LogInAndSignIn().Login(id,password);
            if(result =='WrongPassword'){

              setState(() {
                error = true;
                loading = false;
                errorMessage =AppLocalizations.of(context).translate('WrongPassword');
              });
            }
            else if(result == 'NoPermission'){
              setState(() {
                error = true;
                loading = false;
                errorMessage =AppLocalizations.of(context).translate('Thisuserhasnopermissiontologin');
              });
            }
            else if(result == false){
              setState(() {
                error = true;
                loading = false;
                errorMessage =AppLocalizations.of(context).translate('Thisuserhasnopermissiontologin');
              });
            }else{

            }

              }

             },
             child: Text(
               AppLocalizations.of(context).translate('Login'),
               style: TextStyle(
                   color: Colors.white
               ),
             ),
           ),]),),),
       ),
     ),
    );
  }
}
