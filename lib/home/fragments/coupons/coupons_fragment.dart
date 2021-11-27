import 'package:ecommerce/MyWidgets/CouponItem.dart';
import 'package:ecommerce/MyWidgets/FailureMessage.dart';
import 'package:ecommerce/home/fragments/coupons/coupons_cubit.dart';
import 'package:ecommerce/home/fragments/coupons/coupons_state.dart';
import 'package:ecommerce/models/my_coupon_model.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants.dart';

class CouponsFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CouponsCubit,CouponsState>(builder: (context,state){

      if(state is CouponsInitial){
        context.read<CouponsCubit>().loadCoupons();
      }
      if(state is CouponsLoadingFailed){
        return FailureMessage(message: state.message,onRetry: (){
          context.read<CouponsCubit>().loadCoupons();

        },);
      }

      if(state is CouponsLoaded){
        return state.coupons.length>0?ListView.builder(itemBuilder: (context,index){
          MyCouponModel couponModel = state.coupons[index];
          return CouponItem(couponModel.coupon!,validity: couponModel.validity,code: couponModel.code,);
        },itemCount: state.coupons.length,):  Center(child: Image.asset("assets/images/empty.png",height: 100,width: 100,));
      }

      return ListView.builder(itemBuilder: (context,index){
        return CouponItem.shimmer();
      },
        itemCount:10,);

    }, listener: (context,state){
      if (state is CouponsLoadingFailed) {
        if (state.message == UNAUTHENTICATED_USER) {
          BlocProvider.of<AuthCubit>(context).removeToken();
          Navigator.of(context).popUntil((route) => route.isFirst);
          ///force logout
        }
      }


    });
  }
}
