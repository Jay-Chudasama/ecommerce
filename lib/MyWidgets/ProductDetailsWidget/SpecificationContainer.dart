import 'package:ecommerce/MyWidgets/ShimmerContainer.dart';
import 'package:ecommerce/models/product_details_model.dart';
import 'package:ecommerce/productdetails/product_details_state.dart';
import 'package:flutter/material.dart';

import '../RoundedContainer.dart';

class SpecificationContainer extends StatelessWidget {
  late ProductDetailLoaded state;

  bool shimmer  =false;


  SpecificationContainer.shimmer({this.shimmer=true});

  SpecificationContainer(this.state);

  @override
  Widget build(BuildContext context) {
   if(shimmer){
     return _shimmerView();
   }else{
     return _originalView();
   }
  }

  _shimmerView(){
    return RoundedContainer(
        margin: EdgeInsets.all(8),
        width: double.maxFinite,
        child: ShimmerContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 25,
                width: 100,
                color: Colors.white,
              ),
              SizedBox(
                height: 16,
              ),
           _shimmerItem(),
           _shimmerItem(),
           _shimmerItem(),

            ],
          ),
        ));
  }

  _originalView(){
    return RoundedContainer(
        margin: EdgeInsets.all(8),
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Specifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            ...state.data.specifications!
                .map(
                  (e) => _specificationItem(e),
            )
                .toList(),
          ],
        ));
  }

  _shimmerItem(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Container(
                height: 20,
                color: Colors.white,
              ),),
          SizedBox(
            width: 16,
          ),
          Expanded(
              child:  Container(
                height: 20,
                color: Colors.white,
              ),),
        ],
      ),
    );
  }

  Widget _specificationItem(Specifications specification) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Text(
                specification.title!,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          SizedBox(
            width: 16,
          ),
          Expanded(
              child: Text(
                specification.value!,
              )),
        ],
      ),
    );
  }
}
