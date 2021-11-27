import 'package:ecommerce/MyWidgets/ShimmerContainer.dart';
import 'package:ecommerce/productdetails/StockOutCubit/StockCubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'CashOnDeliveryTag.dart';
import 'package:ecommerce/models/product_details_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../ProductImagesCarousel.dart';

class ProductOptionsContainer extends StatefulWidget {
  late ProductDetailsModel _model;
  int selectedOptionIndex = 0;
  late String selectedOptionId;
  late String selectedOption;
  late String image;
  bool shimmer = false;

  ProductOptionsContainer.shimmer({this.shimmer = true});

  ProductOptionsContainer(this._model):selectedOptionId = _model.options![0].id!,selectedOption=_model.options![0].option!;

  @override
  _ProductOptionsContainerState createState() =>
      _ProductOptionsContainerState();
}

class _ProductOptionsContainerState extends State<ProductOptionsContainer> {


  @override
  void initState() {
    if(!widget.shimmer){

    if(widget._model.options![0].quantity! >  0){
      BlocProvider.of<StockCubit>(context).stockAvailable(widget._model.options![0].quantity!);
    }else{
      BlocProvider.of<StockCubit>(context).outOfStock();
    }
    }
  }
  @override
  Widget build(BuildContext context) {
    if (widget.shimmer) {
      return _shimmerView();
    } else {
      return _originalView();
    }
  }

  _shimmerView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductImagesCarousel.shimmer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShimmerContainer(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 25,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 60,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      height: 20,
                      width: 50,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _originalView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductImagesCarousel(_generateImageList()),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget._model.title!,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    CURRENCY + widget._model.offerPrice!.toString(),
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto"),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  if (widget._model.price != widget._model.offerPrice)
                    Text(
                      CURRENCY + widget._model.price.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          fontFamily: "Roboto"),
                    ),
                  Spacer(),
                  if (widget._model.cod!) CashOnDeliveryTag(),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              ..._generateOptions(),
            ],
          ),
        ),
      ],
    );
  }

  List<String> _generateImageList() {
    widget.image = widget._model.options![widget.selectedOptionIndex].images![0].image!;
    return widget._model.options![widget.selectedOptionIndex].images!
        .map((e) => DOMAIN_URL + e.image!)
        .toList();
  }

  _generateOptions() {
    if (widget._model.options!.length > 0) {
      return [
        Text(
          'OPTIONS',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Wrap(
          children: widget._model.options!
              .map((e) => _optionBtn(e, widget._model.options!.indexOf(e)))
              .toList(),
        ),
      ];
    }
  }

  Widget _optionBtn(Options option, index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.selectedOptionId = option.id!;
          widget.selectedOption = option.option!;
          widget.selectedOptionIndex = index;
          if(option.quantity! >  0){
            BlocProvider.of<StockCubit>(context).stockAvailable(option.quantity!);
          }else{
            BlocProvider.of<StockCubit>(context).outOfStock();
          }

        });
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 80.0,
        ),
        child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    width: 2,
                    color: option.id == widget.selectedOptionId
                        ? PRIMARY_SWATCH
                        : Colors.grey)),
            child: Text(
              option.option!,
              textAlign: TextAlign.center,
            )),
      ),
    );
  }
}
