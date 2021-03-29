import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Service/Lang/LangChange.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SelectLanguage extends StatefulWidget {
  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  SharedPreferences preferences;
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    waitting();
  }
  waitting()async{

    preferences = await SharedPreferences.getInstance();
    loading = false;
    setState(() {

    });


  }
  @override
  Widget build(BuildContext context) {
    List<String> lang = ["English","ગુજરાતી","हिन्दी"];
    List<String> langCode = ["en_US","gu_IN","hi_IN"];
    List<Locale> lngLocals =  [Locale('en', 'US'), Locale('gu', 'IN'), Locale('hi', 'IN'),];

    final langChange = Provider.of<LangChange>(context);
    return Scaffold(
      appBar: commonAppbar(Container()),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child:loading?CircularLoading(): ListView.builder(
            itemCount: lang.length,
            itemBuilder: (context,index){
              return Card(
                child: ListTile(
                  onTap: ()async{
                    setState(() {
                      loading = true;
                    });
                    await preferences.setString('Language', langCode[index]);
                    langChange.controller.add(lngLocals[index]);
                    // langChange.setLang(lang[index]);
                    //  Phoenix.rebirth(context);
                    setState(() {
                      loading = false;
                    });
                  },
                  title: Text(
                    lang[index],
                    style: TextStyle(
                        color: langCode[index] == preferences.getString('Language')?Theme.of(context).primaryColor:Colors.black
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

