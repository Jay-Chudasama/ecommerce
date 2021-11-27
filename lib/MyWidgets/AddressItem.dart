import 'package:ecommerce/MyWidgets/ShimmerContainer.dart';
import 'package:ecommerce/home/fragments/account/account_bloc.dart';
import 'package:ecommerce/home/fragments/account/account_event.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/newaddress/newaddress_bloc.dart';
import 'package:ecommerce/newaddress/newaddress_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'RoundedContainer.dart';

class AddressItem extends StatelessWidget {
  bool shimmer = false;

  late Selected_address address;
  bool showcase = false,manage=false;

  AddressItem(this.address, {this.showcase = false,this.manage = false});

  AddressItem.shimmer({this.shimmer = true});

  @override
  Widget build(BuildContext context) {
   return shimmer?_shimmerView():_originalView(context);
  }

  _originalView(context){
    return InkWell(
      onTap: () {
        BlocProvider.of<AccountBloc>(context)
            .add(UpdateSelectedAddress(address));
      },
      child: RoundedContainer(
          margin: EdgeInsets.all(8),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showcase)
                Text(
                  'SHIPPING ADDRESS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              if (address != null) ...[
                Row(
                  children: [
                    Text(
                      address.name!,
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Spacer(),
                    if (BlocProvider.of<AccountBloc>(context)
                        .state
                        .userdata
                        .selectedAddress!
                        .id ==
                        address.id &&
                        !showcase && !manage)
                      Icon(
                        FontAwesomeIcons.solidCheckCircle,
                        color: Colors.blueAccent,
                      ),
                    if(manage)
                    PopupMenuButton(
                      onSelected: (value){
                        if(value==1){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => NewAddressBloc(),
                                child: NewAddressScreen(model: address,),
                              )));
                        }else{
                          BlocProvider.of<AccountBloc>(context).add(DeleteAddress(address.id!));
                        }
                      },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text("Edit",style: TextStyle(fontSize: 12),),

                            value: 1,
                          ),
                          PopupMenuItem(
                            child: Text("Delete",style: TextStyle(fontSize: 12),),
                            value: 2,
                          )
                        ]
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Text(address.flatNo! + ', ' + address.locality! + ','),
                Text(
                  '(Landmark ${address.landmark!})',
                ),
                Text(
                  address.city!,
                ),
                Text(
                  address.state!,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Pincode ' + address.pincode.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Mobile no. ' + address.mobileNo!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (address.alternateNo!.isNotEmpty)
                  Text(
                    'Alternate no. ' + address.alternateNo!.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
              ],
            ],
          )),
    );
  }

  _shimmerView(){
    return RoundedContainer(
        margin: EdgeInsets.all(8),
        width: double.infinity,
        child: ShimmerContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

               Container(color: Colors.white,height: 26,width: 60,),
SizedBox(height: 8,),
                Row(
                  children: [
                    Container(color: Colors.white,height: 20,width: 70,),
                    Spacer(),

                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Container(color: Colors.white,height: 16,),

                Container(color: Colors.white,height: 16,),

              SizedBox(
                height: 8,
              ),
                Container(color: Colors.white,height: 16,width: 40,),
                SizedBox(
                  height: 8,
                ),
                Container(color: Colors.white,height: 16,width: 90,),
              SizedBox(
                height: 8,
              ),
                Container(color: Colors.white,height: 16,width: 30,),


            ],
          ),
        ));
  }
}
