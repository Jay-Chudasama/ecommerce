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

class ProductGrid extends StatelessWidget {
  bool shimmer = false;
late  Results result;


  ProductGrid(this.result);

  ProductGrid.shimmer({this.shimmer=true});

  @override
  Widget build(BuildContext context) {

    return shimmer ? _shimmerView() : _originalView(context);


  }

 Widget _originalView(context) {
   int productsCount = result.products!.length;
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
           IntrinsicHeight(
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 ProductThumbail(result.products![0], null, false),
                 if (productsCount > 1) ...[
                   VerticalDivider(
                     thickness: 1,
                     color: APP_BACKGROUND_COLOR,
                   ),
                   ProductThumbail(result.products![1], null, false),
                 ]
               ],
             ),
           ),
           if (productsCount > 2) ...[
             Divider(
               thickness: 1,
               indent: 0,
               endIndent: 0,
               height: 1,
               color: APP_BACKGROUND_COLOR,
             ),
             IntrinsicHeight(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   ProductThumbail(result.products![2], null, false),
                   if (productsCount > 3) ...[
                     VerticalDivider(
                       thickness: 1,
                       color: APP_BACKGROUND_COLOR,
                     ),
                     ProductThumbail(result.products![3], null, false),
                   ]
                 ],
               ),
             )
           ]
         ],
       ),
     );
   }
 }

  Widget _shimmerView() {
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
                child: Container(
                    height: 20, width: 80, color: Colors.white)),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ProductThumbail(Products(), null, true),
                  VerticalDivider(
                    thickness: 1,
                    color: APP_BACKGROUND_COLOR,
                  ),
                  ProductThumbail(Products(), null, true),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              indent: 0,
              endIndent: 0,
              height: 1,
              color: APP_BACKGROUND_COLOR,
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ProductThumbail(Products(), null, true),
                  VerticalDivider(
                    thickness: 1,
                    color: APP_BACKGROUND_COLOR,
                  ),
                  ProductThumbail(Products(), null, true),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
