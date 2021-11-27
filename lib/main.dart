import 'package:ecommerce/home/fragments/account/account_event.dart';
import 'package:ecommerce/home/fragments/account/account_state.dart';
import 'package:ecommerce/home/fragments/cart/cart_bloc.dart';
import 'package:ecommerce/home/fragments/cart/cart_state.dart';
import 'package:ecommerce/home/fragments/coupons/coupons_cubit.dart';
import 'package:ecommerce/home/fragments/home/search_cubit.dart';
import 'package:ecommerce/home/fragments/wishlist/wishlist_bloc.dart';
import 'package:ecommerce/home/home_screen.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/notification/notification_event.dart';
import 'package:ecommerce/productdetails/product_details_screen.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:ecommerce/registration/authentication/auth_repository.dart';
import 'package:ecommerce/registration/authentication/auth_state.dart';
import 'package:ecommerce/registration/authentication/authenticating_screen.dart';
import 'package:ecommerce/registration/signup/signup_cubit.dart';
import 'package:ecommerce/registration/signup/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'categorypage/page_bloc.dart';
import 'constants.dart';
import 'home/fragments/account/account_bloc.dart';
import 'models/notification_model.dart';
import 'notification/notification_bloc.dart';
import 'notification/notification_state.dart';

//Recieves message when the app is in background state!
Future<void> backgroundHandler(RemoteMessage message) async {
  print('on Recieve....');
}

final AuthRepository authRepository = AuthRepository();
final storage = FlutterSecureStorage();
final AuthCubit authCubit =
    AuthCubit(storage: storage, authRepository: authRepository);
final NotificationsBloc notificationBLoc = NotificationsBloc();
final AccountBloc accountBloc = AccountBloc(AccountInitial(UserModel()));
final WishlistBloc wishlistBloc = WishlistBloc();
final SearchCubit searchCubit = SearchCubit();
final PageBloc pageBloc = PageBloc();
final CouponsCubit couponsCubit = CouponsCubit();
final CartBloc cartBloc = CartBloc(CartInitial());

bool firebaseInitialized = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.instance.subscribeToTopic("EVERYONE");
    firebaseInitialized = true;
  if(authCubit.state is AuthInitial) {
    await authCubit.authenticate();
  }
  runApp(EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  EcommerceApp() {
    //    Recieves message when the app is closed!
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('CLosed app');
      }
    });

//    foreground listening
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null && message.data['type'] == USER) {
        if (notificationBLoc.state is NotificationsLoaded) {
          notificationBLoc.add(AddNewNotification(NotificationModel(
              title: message.notification!.title,
              body: message.notification!.body,
              image: message.data['image'],
              createdAt: message.data['createdAt'])));
        }
        accountBloc.add(AddNotificationCount());
      }
    });

//    When user taps and App is in background, but opened!
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null && message.data['type'] == USER) {
        if (notificationBLoc.state is NotificationsLoaded) {
          notificationBLoc.add(AddNewNotification(NotificationModel(
              title: message.notification!.title,
              body: message.notification!.body,
              image: message.data['image'],
              createdAt: message.data['createdAt'])));
        }
        accountBloc.add(AddNotificationCount());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => authCubit,
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AccountBloc>(create: (_) {
                accountBloc.state.userdata =
                    state is Authenticated ? state.userdata : UserModel();
                return accountBloc;
              }),
              BlocProvider<WishlistBloc>(
                create: (BuildContext context) => wishlistBloc,
              ),
            ],
            child: MaterialApp(
                title: 'MyMall',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    appBarTheme: AppBarTheme(
                        brightness: Brightness.dark,
                        textTheme: TextTheme(
                            headline6: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Poppins')),
                        iconTheme: IconThemeData(color: Colors.white)),
                    scaffoldBackgroundColor: APP_BACKGROUND_COLOR,
                    primarySwatch: PRIMARY_SWATCH,
                    secondaryHeaderColor: SECONDARY_HEADER_COLOR,
                    fontFamily: 'Poppins'),
                home: state is Authenticated
                    ? MultiBlocProvider(providers: [
                        BlocProvider<SearchCubit>(
                          create: (BuildContext context) => searchCubit,
                        ),
                        BlocProvider<PageBloc>(
                          create: (BuildContext context) => pageBloc,
                        ),
                        BlocProvider<CouponsCubit>(
                          create: (BuildContext context) => couponsCubit,
                        ),
                        BlocProvider<CartBloc>(
                          create: (BuildContext context) =>
                              cartBloc,
                        ),
                        BlocProvider<NotificationsBloc>(
                            create: (BuildContext context) => notificationBLoc),
                      ], child: HomeScreen())
                    : state is AuthenticationFailed || state is Authenticating
                        ? AuthenticatingScreen()
                        : BlocProvider<SignUpCubit>(
                            create: (context) => SignUpCubit(),
                            child: SignUpScreen())),
          );
        },
      ),
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    return BlocProvider(
//      create: (BuildContext context) =>
//          AuthCubit(storage: storage, authRepository: authRepository),
//      child: MaterialApp(
//        title: 'Ecommerce App',
//        debugShowCheckedModeBanner: false,
//        theme: ThemeData(
//          appBarTheme: AppBarTheme(brightness: Brightness.dark,iconTheme: IconThemeData(color: Colors.white)),
//            scaffoldBackgroundColor: APP_BACKGROUND_COLOR,
//            primarySwatch: PRIMARY_SWATCH,
//            secondaryHeaderColor: SECONDARY_HEADER_COLOR,
//            fontFamily: 'Poppins'),
//        home: BlocBuilder<AuthCubit, AuthState>(
//          builder: (context, state) {
//            Widget page = SplashScreen();
//
//            if (state is Authenticated) {
//              page = MultiBlocProvider(providers: [
//                BlocProvider<PageBloc>(
//                  create: (BuildContext context) => PageBloc(),
//                ),
//                BlocProvider<WishlistBloc>(
//                  create: (BuildContext context) => WishlistBloc(),
//                ),
//                BlocProvider<CartBloc>(
//                  create: (BuildContext context) => CartBloc(),
//                ),
//                BlocProvider<AccountBloc>(
//                  create: (BuildContext context) => AccountBloc(AccountInitial(state.userdata)),
//                ),
//
//              ], child: HomeScreen());
//            } else if (state is LoggedOut) {
//              page =  BlocProvider<SignUpCubit>(
//                      create: (context) => SignUpCubit(),
//                      child: SignUpScreen());
//            }
//
//            return page;
//          },
//        ),
//      ),
//    );
//  }
}
