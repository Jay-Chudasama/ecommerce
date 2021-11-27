import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/models/payout_beneficiary_model.dart';
import 'package:ecommerce/utils.dart';

abstract class AccountEvent{}

class RemoveFromUserWishlist extends AccountEvent{
  late String id;

  RemoveFromUserWishlist(this.id);
}

class AddToUserWishlist extends AccountEvent{
  late String id;

  AddToUserWishlist(this.id);
}

class RemoveFromUserCart extends AccountEvent{
  late String id;

  RemoveFromUserCart(this.id);
}

class AddToUserCart extends AccountEvent{
  late String id;

  AddToUserCart(this.id);
}

class LoadMyAddresses extends AccountEvent {
}

class LoadMyBenes extends AccountEvent {
}

class AddAddress extends AccountEvent {
  Selected_address selected_address;

  AddAddress(this.selected_address);
}

class UpdateAccountAddress extends AccountEvent {
  Selected_address selected_address;

  UpdateAccountAddress(this.selected_address);
}


class DeleteAddress extends AccountEvent{
  String id;
  DeleteAddress(this.id);
}

class AddBene extends AccountEvent {
  PayoutBeneficiaryModel bene;

  AddBene(this.bene);
}

class UpdateSelectedBene extends AccountEvent{}

class DeleteBene extends AccountEvent{
  String id;
  DeleteBene(this.id);
}


class UpdateSelectedAddress extends AccountEvent {
  Selected_address selected_address;

  UpdateSelectedAddress(this.selected_address);
}

class RemovedOrderedProductsUserCart extends AccountEvent{
  late CartTotals cartTotals;

  RemovedOrderedProductsUserCart(this.cartTotals);
}

class UpdateInfo extends AccountEvent{
  String email,phone,name;

  UpdateInfo(this.email, this.phone, this.name);
}

class AddNotificationCount extends AccountEvent{}

class NotificationsReaded extends AccountEvent{}