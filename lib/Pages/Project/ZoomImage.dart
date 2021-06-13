import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:pinch_zoom/pinch_zoom.dart';


class ImageZoom extends StatefulWidget {
  List<String> image;
  ImageZoom({/*required*/ required this.image});
  @override
  _ImageZoomState createState() => _ImageZoomState();
}

class _ImageZoomState extends State<ImageZoom> {
  late String selectedUrl ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedUrl = widget.image.first;
  }
  @override

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CommonAppbar(
      CommonAssets.apptitle
      ,Container()),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: size.width *0.2,

            child: ListView.builder(
            itemCount: widget.image.length   ,
            itemBuilder: (context,index){
              return GestureDetector(
                onTap: (){
                  setState(() {
                    selectedUrl =   widget.image[index];
                  });
                },
                child: Card(
                  child:
                  CachedNetworkImage(
                    //fit: BoxFit.cover,
                    imageUrl:   widget.image[index],
                    placeholder: (context, url) => Center(child: CircularLoading(),),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  // Image.network(
                  //   widget.image[index],
                  //   width: size.width *0.2,
                  //   height: size.height*0.1,
                  //   fit:BoxFit.cover,
                  //
                  //
                  // ),
                ),
              );
            }),
          ),
          VerticalDivider(
            color: Theme.of(context).primaryColor,
            thickness: 2,
          ),
          Expanded(
            child: PinchZoom(

              zoomedBackgroundColor: Colors.black.withOpacity(0.5),
              resetDuration: const Duration(milliseconds: 100),
              maxScale: 2.5,
            image:
              CachedNetworkImage(
                imageUrl:  selectedUrl,
                placeholder: (context, url) => Center(child: CircularLoading(),),
                errorWidget: (context, url, error) => Icon(Icons.error),

              ),
            ),
          ),
        ],
      ),

    );
  }
}
