import 'package:flutter/material.dart';

const DOMAIN_URL = "http://10.0.2.2:8000";
const HOST_URL = "http://10.0.2.2:8000";
//const DOMAIN_URL = "http://192.168.1.2:8000";
//const HOST_URL = "http://192.168.1.2:8000";
const BASE_URL = HOST_URL+"/api";
const UNAUTHENTICATED_USER = 'unauthenticated_user';
const EMAIL_REGEX = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

const PAGE_LIMIT = 8;
const ORDERS_PAGE_LIMIT = 8;
const NOTIFICATIONS_PAGE_LIMIT = 8;
const QUESTIONS_PAGE_LIMIT = 8;
const SEARCH_PAGE_LIMIT = 8;
const VIEWALL_PAGE_LIMIT = 8;

const CURRENCY = "₹";

const USER = 'user';

////VIEW TYPE
const BANNER = 1;
const SWIPER = 2;
const GRID = 3;

///THEME COLOR

const Map<int, Color> color =
{
  50:Color.fromRGBO(80,188,134, .1),
  100:Color.fromRGBO(80,188,134, .2),
  200:Color.fromRGBO(80,188,134, .3),
  300:Color.fromRGBO(80,188,134, .4),
  400:Color.fromRGBO(80,188,134, .5),
  500:Color.fromRGBO(80,188,134, .6),
  600:Color.fromRGBO(80,188,134, .7),
  700:Color.fromRGBO(80,188,134, .8),
  800:Color.fromRGBO(80,188,134, .9),
  900:Color.fromRGBO(80,188,134, 1),
};

const PRIMARY_SWATCH =  MaterialColor(0xff50bc86,color);
const SECONDARY_HEADER_COLOR = PRIMARY_SWATCH;
const APP_BACKGROUND_COLOR =     Color(0xfff9f9f9);

const INPUT_BORDER_COLOR = Color(0xffD9D9D9);

const COUPON_COLOR = Color(0xff34DEA4);


final OutlineInputBorder ENABLED_BORDER = OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(
  color: INPUT_BORDER_COLOR,
//  width: 2.0,
),);

final OutlineInputBorder FOCUSED_BORDER = OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(
  color: PRIMARY_SWATCH,
  width: 2.0,
),);
final OutlineInputBorder ERROR_BORDER = OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(
  color: Colors.red,
  width: 2.0,
),);



