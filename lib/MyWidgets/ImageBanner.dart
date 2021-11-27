import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/MyWidgets/ShimmerContainer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../constants.dart';

class ImageBanner extends StatelessWidget {
  bool shimmer = false;
  String image = '';

  ImageBanner.shimmer({this.shimmer = true});

  ImageBanner(this.image);

  @override
  Widget build(BuildContext context) {
    return shimmer ? _shimmerView() : _originalView();
  }

  Widget _shimmerView() {
    return ShimmerContainer(

      child: Container(
        margin: EdgeInsets.all(8),
        height: 150,
        color: Colors.white,
      ),
    );
  }

  Widget _originalView() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: CachedNetworkImage(
        imageUrl: image,
        errorWidget: (context, url, error) => Container(
            padding: EdgeInsets.all(24),
            color: INPUT_BORDER_COLOR,
            child: Icon(
            Icons.broken_image_sharp,
              color: Colors.grey,
            )),
      ),
    );
  }
}
