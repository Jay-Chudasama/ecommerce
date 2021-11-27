import 'package:ecommerce/MyWidgets/FailureMessage.dart';
import 'package:ecommerce/MyWidgets/WishlistItem.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:ecommerce/viewall/viewall_cubit.dart';
import 'package:ecommerce/viewall/viewall_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';

class ViewAllScreen extends StatelessWidget {

  late String id;
  late String title;

  ViewAllScreen(this.id,this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: BlocConsumer<ViewAllCubit, ViewAllState>(
          listener: (context, state) {
            if (state is ViewAllLoadingFailed) {
              if (state.message == UNAUTHENTICATED_USER) {
                BlocProvider.of<AuthCubit>(context).removeToken();
                Navigator.of(context).popUntil((route) => route.isFirst);
                ///force logout
              }
            }
            if (state is MoreViewAllLoadingFailed) {
              if (state.message == UNAUTHENTICATED_USER) {
                BlocProvider.of<AuthCubit>(context).removeToken();
                Navigator.of(context).popUntil((route) => route.isFirst);
                ///force logout
              }
            }
          },
          builder: (context, state) {
            if (state is ViewAllInitial) {
              BlocProvider.of<ViewAllCubit>(context).load(id);
            }

            if (state is ViewAllLoadingFailed) {
              return FailureMessage(
                message: state.message,
                onRetry: () {
                  BlocProvider.of<ViewAllCubit>(context).load(id);
                },
              );
            }

            if (state is ViewAllLoaded ||
                state is MoreViewAllLoadingFailed) {
              ViewAllLoaded _loadedViewAll =
              state is MoreViewAllLoadingFailed
                  ? state.loadedViewAll
                  : state as ViewAllLoaded;
              return _loadedViewAll.products.length > 0 ? ListView.builder(
                itemBuilder: (context, index) {
                  if (index < _loadedViewAll.products.length) {
                    // Show your info
                    return WishlistItem(_loadedViewAll.products[index],index);
                  } else {
                    if (state is MoreViewAllLoadingFailed) {
                      return FailureMessage(message: state.message, onRetry: null);
                    }
                    BlocProvider.of<ViewAllCubit>(context).loadMore();
                    return Center(child: CircularProgressIndicator());
                  }
                },
                itemCount: _loadedViewAll.next != null
                    ? _loadedViewAll.products.length + 1
                    : _loadedViewAll.products.length,
              ):  Center(child: Image.asset("assets/images/empty.png",height: 100,width: 100,));
            }

            return ListView.builder(itemBuilder: (context,index){
              return WishlistItem.shimmer();
            },);
          }),
    );
  }
}
