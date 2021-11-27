import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/MyWidgets/CartIconButton.dart';
import 'package:ecommerce/MyWidgets/CategoryItem.dart';
import 'package:ecommerce/MyWidgets/FailureMessage.dart';
import 'package:ecommerce/MyWidgets/ImageBanner.dart';
import 'package:ecommerce/MyWidgets/SliderCarousel.dart';
import 'package:ecommerce/MyWidgets/ProductGrid.dart';
import 'package:ecommerce/MyWidgets/ProductThumbnail.dart';
import 'package:ecommerce/MyWidgets/Swiper.dart';
import 'package:ecommerce/categorypage/page_bloc.dart';
import 'package:ecommerce/categorypage/page_event.dart';
import 'package:ecommerce/categorypage/page_state.dart';
import 'package:ecommerce/home/fragments/cart/cart_bloc.dart';
import 'package:ecommerce/home/fragments/cart/cart_screen.dart';
import 'package:ecommerce/models/category_model.dart';
import 'package:ecommerce/models/page_model.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants.dart';

class PageScreen extends StatelessWidget {
  late String categoryId;
  late String title;
  List<String> slides = [];
  Random random = Random();

  PageScreen(this.categoryId,this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),titleSpacing: 0, actions: [
       CartIconButton(onPressed: (){
         Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(value: BlocProvider.of<CartBloc>(context),child: CartScreen(),)));
       },)
      ]),
      body: BlocConsumer<PageBloc, PageState>(listener: (context, state) {
        if (state is PageLoadingFailed) {
          if (state.message == UNAUTHENTICATED_USER) {
            BlocProvider.of<AuthCubit>(context).removeToken();
            Navigator.of(context).popUntil((route) => route.isFirst);
            ///force logout
          }
        }
        if (state is MorePageLoadingFailed) {
          if (state.message == UNAUTHENTICATED_USER) {
            BlocProvider.of<AuthCubit>(context).removeToken();
            Navigator.of(context).popUntil((route) => route.isFirst);
            ///force logout
          }
        }
      }, builder: (context, state) {

        if (state is PageLoadingFailed) {
          return FailureMessage(
            message: state.message,
            onRetry: () {
              BlocProvider.of<PageBloc>(context).add(LoadPage(categoryId));
            },
          );
        }

        return _list(state,context);
      }),
    );
  }

  Widget _list(state,context) {
    if (state is PageLoaded) {
      PageModel? pageModel;
      try {
        pageModel = state.pages.firstWhere((element) => element.category ==
            categoryId);
      }catch (e){
//        do nothing
      }

      if(pageModel == null){
        BlocProvider.of<PageBloc>(context).add(LoadPage(categoryId));
        return Center(child: CircularProgressIndicator(),);
      }

      List<Results> list;
      if (pageModel.slides != null) {
        if (pageModel.slides!.length > 0) {
          slides = pageModel.slides!.map((e) => DOMAIN_URL + e.image!).toList();
          list = [
            Results.fromJson({'view_type': 0}),
            ...?pageModel.results
          ];
        } else {
          list = pageModel.results!;
        }
      } else {
        list = pageModel.results!;
      }
      return RefreshIndicator(
        onRefresh: () async{
          BlocProvider.of<PageBloc>(context).add(LoadPage(categoryId));
        },
        child: list.length>0?ListView.builder(
          itemBuilder: (context, index) {
            if (index < list.length) {
              // Show your info
              return _listItem(context, list[index], false);
            } else {
              if (state is MorePageLoadingFailed) {
                return FailureMessage(message: state.message, onRetry: null);
              }
              BlocProvider.of<PageBloc>(context)
                  .add(LoadMorePage(categoryId));
              return Center(child: CircularProgressIndicator());
            }
          },
          itemCount: pageModel.next != null ? list.length + 1 : list.length,
        ):  Center(child: Image.asset("assets/images/empty.png",height: 100,width: 100,)),
      );
    } else {
      ////shimmer list
      return ListView.builder(
          itemBuilder: (context, index) {
            if (index == 0) {
              return _listItem(context, Results(viewType: 0), true);
            }
            return _listItem(
                context, Results(viewType: random.nextInt(3) + 1), true);
          },
          itemCount: 10);
    }
  }

  Widget _listItem(BuildContext context, Results result, bool shimmer) {
    if (shimmer) {
      switch (result.viewType) {
        case BANNER:
          return ImageBanner.shimmer();
        case SWIPER:
          return Swiper.shimmer();
        case GRID:
          return ProductGrid.shimmer();
        default:
          return SliderCarousel.shimmer();
      }
    } else {
      switch (result.viewType) {
        case BANNER:
          return ImageBanner(DOMAIN_URL + result.image);
        case SWIPER:
          return Swiper(result);
        case GRID:
          return ProductGrid(result);
        default:
          return SliderCarousel(slides);
      }
    }
  }
}
