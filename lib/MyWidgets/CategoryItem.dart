import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryItem extends StatelessWidget {

  bool shimmer = false;
  late String image,name;


  CategoryItem.shimmer({this.shimmer=true});


  CategoryItem(this.image, this.name);

  @override
  Widget build(BuildContext context) {

    return shimmer?_shimmerView():_originalView();

  }

  Widget _shimmerView(){
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 8),
              height: 40,
              width: 40,
              color:Colors.white
          ),
          Container(
              height: 10,
              width: 50,
              color:Colors.white
          ),
        ],
      ),
    );
  }

  Widget _originalView(){
    return Container(
        width: 60,
        child: Column(
          children: [
            SizedBox(height: 4,),
            CachedNetworkImage(imageUrl: image,
              fit: BoxFit.contain,
              height: 40,
              width: 40,
              errorWidget: (context, url, error)=>Icon(FontAwesomeIcons.image),
            ),
            SizedBox(height: 2,),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              style:
              TextStyle(fontSize: 10, fontWeight: FontWeight.bold,height: 1,color: Colors.black),
            ),

          ],
        ));
  }


}
