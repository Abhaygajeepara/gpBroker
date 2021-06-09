import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Advertise/AdvertiseMode.dart';
import 'package:gpgroup/Pages/Project/ZoomImage.dart';

import 'package:gpgroup/Service/ProjectRetrieve.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:provider/provider.dart';
class SingleAds extends StatefulWidget {

  @override
  _SingleAdsState createState() => _SingleAdsState();
}

class _SingleAdsState extends State<SingleAds> {
  @override
  Widget build(BuildContext context) {
    final projectRetrieve = Provider.of<ProjectRetrieve>(context);
    final size = MediaQuery.of(context).size;
    final labelFontSize = size.height*0.02;
    final fontWeight = FontWeight.bold;
    final spaceVertical = size.height *0.01;
    final fontSize = size.height*0.015;
    return Scaffold(
      appBar: CommonAppbar(projectRetrieve.adsId,Container()),
      body: StreamBuilder<AdvertiseModel>(
        stream: projectRetrieve.SINGLEADVERTISE,
        builder: (context,snapshot){
          if(snapshot.hasData){
          return Padding(
            padding:  EdgeInsets.symmetric(horizontal: size.width*0.01,vertical: size.height*0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider.builder(
                    options: CarouselOptions(

                      // height: 400,
                      aspectRatio: 16/9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,

                      scrollDirection: Axis.horizontal,
                    ),
                    itemCount: snapshot.data.imageUrl.length,
                    itemBuilder: (BuildContext context,index){
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, PageRouteBuilder(
                            //    pageBuilder: (_,__,____) => BuildingStructure(),
                            pageBuilder: (_, __, ___) => ImageZoom(
                                image: snapshot.data.imageUrl),
                            transitionDuration: Duration(
                                milliseconds: 0),
                          ));
                          // showDialog(
                          //     context: context,
                          //     builder: (BuildContext  context){
                          //       return Dialog(
                          //         child:
                          //         CachedNetworkImage(
                          //           imageUrl:  snapshot.data.imageUrl[index],
                          //
                          //           fit: BoxFit.cover,
                          //           width: size.width *0.8,
                          //           placeholder: (context, url) => Center(child: CircularLoading(),),
                          //           errorWidget: (context, url, error) => Icon(Icons.error),
                          //         ),
                          //
                          //       );
                          //     }
                          // );
                        },
                        child:
                        CachedNetworkImage(
                          imageUrl:  snapshot.data.imageUrl[index],
                          placeholder: (context, url) => Center(child: CircularLoading(),),
                          errorWidget: (context, url, error) => Icon(Icons.error),

                        ),
                      );
                    }
                ),
                SizedBox(height: spaceVertical ,),
                Divider(color:  Theme.of(context).primaryColor,thickness: 1,),
                SizedBox(height: spaceVertical ,),
                Padding(
                  padding:  EdgeInsets.fromLTRB( size.width*0.01,0,0,0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //SizedBox(height: spaceVertical ,),
                      // Text(
                      //   AppLocalizations.of(context).translate('Ads')+AppLocalizations.of(context).translate('Id'),
                      //   style: TextStyle(
                      //       fontSize: labelFontSize,
                      //       fontWeight: fontWeight
                      //   ),
                      //
                      // ),
                      // SizedBox(height: spaceVertical *2,),
                      // Text(
                      //   snapshot.data.id ,
                      //   style: TextStyle(
                      //     fontSize: labelFontSize,
                      //
                      //   ),
                      //
                      // ),
                      SizedBox(height: spaceVertical *2,),
                      Text(
                        AppLocalizations.of(context).translate('Description'),
                        style: TextStyle(
                            fontSize: labelFontSize,
                            fontWeight: fontWeight
                        ),

                      ),
                      SizedBox(height: spaceVertical *2,),
                      Text(
                        snapshot.data.description ,
                        style: TextStyle(
                          fontSize: labelFontSize,

                        ),

                      )
                    ],
                  ),
                )
              ],
            ),
          );  
          }
          else if(snapshot.hasError){
            return Container(
              child: Center(
                child: Text(
                  snapshot.error.toString(),
                  //CommonAssets.snapshoterror,
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
      )
    );
  }
}
