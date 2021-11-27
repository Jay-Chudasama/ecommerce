import 'package:ecommerce/MyWidgets/ShimmerContainer.dart';
import 'package:ecommerce/models/page_model.dart';
import 'package:ecommerce/viewall/viewall_cubit.dart';
import 'package:ecommerce/viewall/viewall_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../constants.dart';
import 'ProductThumbnail.dart';

class Swiper extends StatelessWidget {
  bool shimmer = false;
  late Results result;

  Swiper(this.result);

  Swiper.shimmer({this.shimmer = true});

  @override
  Widget build(BuildContext context) {
    return shimmer ? _shimmerView() : _originalView(context);
  }

  _shimmerView() {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: ShimmerContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(height: 20, width: 80, color: Colors.white)),
            SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (context, index) {
                  return ProductThumbail(Products(), 150, true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _originalView(context) {
    if (result.products == null || result.products!.length == 0) {
      return Container(
          padding: EdgeInsets.all(24),
          color: INPUT_BORDER_COLOR,
          child: Icon(
            FontAwesomeIcons.exclamationTriangle,
            color: Colors.grey,
          ));
    } else {
      return Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    result.title!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                TextButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider<ViewAllCubit>(create:(_)=> ViewAllCubit(),child: ViewAllScreen(result.id!,result.title!),)));
                }, child: Text('ViewALL',style: TextStyle(fontWeight: FontWeight.bold),)),
                SizedBox(width: 8,)
              ],
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: result.products!.length,
                itemBuilder: (context, index) {
                  Products product = result.products![index];
                  return ProductThumbail(product, 150, false);
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
