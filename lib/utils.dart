import 'package:ecommerce/models/cart_model.dart';

String average(product){
  late String rating;
  var total = product.star1! +
      product.star2! +
      product.star3! +
      product.star4! +
      product.star5!;
  var stars = product.star1! +
      (product.star2! * 2) +
      (product.star3! * 3) +
      (product.star4! * 4) +
      (product.star5! * 5);
  if (total == 0) {
    rating = "0";
  } else {
    rating = (stars / total).toStringAsFixed(1);
  }
  return rating;
}

class CartTotals {
  late List<CartModel> list;
  List<CartModel> cartItems = [];
  List<String> cartItemIds = [];
  int itemCount=0,itemTotal = 0,deliveryCharge = 0,totalAmount = 0,discountAmt=0;
  bool cod = true;


  CartTotals(this.list){

    list.forEach((element) {
      if(element.quantity!>0){
        if(cod){
          if(!element.productDetails!.cod!){
            cod = false;
          }
        }
        cartItems.add(element);
        cartItemIds.add(element.id!);
        itemCount++;
        itemTotal = itemTotal + (element.selectedQuantity!*element.productDetails!.offerPrice!);
        deliveryCharge = deliveryCharge + (element.productDetails!.deliveryCharge!);
      }
    });


    totalAmount = itemTotal+deliveryCharge;

  }
}

String date(String dateString) {
  dateString =dateString.split(".")[0];
  DateTime tm = DateTime.parse(dateString);

  String timeString;
  String period = "AM";
  int hour = tm.hour;
  if(tm.hour>12){
    hour = tm.hour - 12;
    period = "PM";
  }

  String time = "at "+ hour.toString()+":"+tm.minute.toString()+" "+period;

  DateTime today = new DateTime.now();
  Duration oneWeek = new Duration(days: 7);
  String month = getMonth(tm);


  Duration difference = today.difference(tm);

  if (today.day - tm.day == 0) {
    return "today "+time;
  } else if (today.day - tm.day == 1) {
    return "yesterday " +time;
  } else if (difference.compareTo(oneWeek) < 1) {
    switch (tm.weekday) {
      case 1:
        return "monday " + time;
      case 2:
        return "tuesday "+ time;
      case 3:
        return "wednesday "+ time;
      case 4:
        return "thursday "+ time;
      case 5:
        return "friday "+ time;
      case 6:
        return "saturday "+ time;
      case 7:
        return "sunday "+ time;
      default:
        return "";
    }
  } else if (tm.year == today.year) {
    return '${tm.day} $month';
  } else {
    return '${tm.day} $month ${tm.year}';
  }
}

String fullDate(String dateString){
  dateString =dateString.split(".")[0];
  DateTime tm = DateTime.parse(dateString);
  return tm.day.toString()+" "+getMonth(tm)+" "+tm.year.toString();
}

String getMonth(tm){
  switch (tm.month) {
    case 1:
      return "january";

    case 2:
      return "february";

    case 3:
      return "march";

    case 4:
      return "april";

    case 5:
      return "may";

    case 6:
      return "june";

    case 7:
      return "july";

    case 8:
      return "august";

    case 9:
      return "september";

    case 10:
      return "october";

    case 11:
      return "november";

    case 12:
      return "december";

    default:
      return "";
  }
}