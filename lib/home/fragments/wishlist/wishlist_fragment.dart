import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/MyWidgets/FailureMessage.dart';
import 'package:ecommerce/MyWidgets/RoundedContainer.dart';
import 'package:ecommerce/MyWidgets/WishlistItem.dart';
import 'package:ecommerce/home/fragments/wishlist/wishlist_bloc.dart';
import 'package:ecommerce/home/fragments/wishlist/wishlist_event.dart';
import 'package:ecommerce/home/fragments/wishlist/wishlist_state.dart';
import 'package:ecommerce/models/wishlist_model.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:ecommerce/registration/authentication/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants.dart';

class WishlistFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WishlistBloc,WishlistState>( listener: (context,state){
      if (state is WishlistLoadingFailed) {
        if (state.message == UNAUTHENTICATED_USER) {
          BlocProvider.of<AuthCubit>(context).removeToken();
          Navigator.of(context).popUntil((route) => route.isFirst);
          ///force logout
        }
      }

    },builder: (context,state){
      if(state is WishlistInitial){
        context.read<WishlistBloc>().add(LoadWishlist());
      }

      if (state is WishlistLoadingFailed) {
        return FailureMessage(
          message: state.message,
          onRetry: () {
            context.read<WishlistBloc>().add(LoadWishlist());
          },
        );
      }

      if(state is WishlistLoaded){
        return state.wishlist.length>0?ListView.builder(itemBuilder: (context,index){
          return WishlistItem(state.wishlist[index],index,display: false,);
        },
        itemCount: state.wishlist.length,):  Center(child: Image.asset("assets/images/empty.png",height: 100,width: 100,));
      }



      return ListView.builder(itemBuilder: (context,index){
        return WishlistItem.shimmer();
      },
        itemCount:10,);
    },);
  }



}
