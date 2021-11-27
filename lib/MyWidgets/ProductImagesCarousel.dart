import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/MyWidgets/ShimmerContainer.dart';
import 'package:ecommerce/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

class ProductImagesCarousel extends StatefulWidget {
  List<String> imgList = ["", "", ""];
  late bool shimmer = false;

  late List<Widget> imageSliders;


  ProductImagesCarousel.shimmer({this.shimmer=true}){
    imageSliders = _genereteSlides();
  }

  ProductImagesCarousel(this.imgList) {
    imageSliders = _genereteSlides();
  }

  List<Widget> _genereteSlides(){
    return imgList
        .map((item) => Container(
      child: Container(

        child: ClipRRect(
            child: shimmer?
            ShimmerContainer(
              child: Container(
                height: 150,
                color: Colors.white,
              ),
            )
                :CachedNetworkImage(
              imageUrl: item,fit: BoxFit.contain,width: 1000,
                errorWidget: (context, url, error)=>Icon(Icons.broken_image_sharp,color: Colors.grey,)
            )),
      ),
    ))
        .toList();
  }

  @override
  _ProductImagesCarouselState createState() => _ProductImagesCarouselState();
}

class _ProductImagesCarouselState extends State<ProductImagesCarousel> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CarouselSlider(
        items: widget.imageSliders,
        carouselController: _controller,
        options: CarouselOptions(
            viewportFraction: 1,
            autoPlay: false,
            aspectRatio: 1,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Positioned(
        bottom: 8,
        left: 0,
        right: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imgList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: PRIMARY_SWATCH
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ),
    ]);
  }
}
