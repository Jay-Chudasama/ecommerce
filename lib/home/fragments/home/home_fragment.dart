import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/MyWidgets/CategoryItem.dart';
import 'package:ecommerce/MyWidgets/FailureMessage.dart';
import 'package:ecommerce/MyWidgets/ImageBanner.dart';
import 'package:ecommerce/MyWidgets/SliderCarousel.dart';
import 'package:ecommerce/MyWidgets/ProductGrid.dart';
import 'package:ecommerce/MyWidgets/ProductThumbnail.dart';
import 'package:ecommerce/MyWidgets/Swiper.dart';
import 'package:ecommerce/MyWidgets/WishlistItem.dart';
import 'package:ecommerce/categorypage/page_bloc.dart';
import 'package:ecommerce/categorypage/page_event.dart';
import 'package:ecommerce/categorypage/page_screen.dart';
import 'package:ecommerce/categorypage/page_state.dart';
import 'package:ecommerce/home/fragments/cart/cart_bloc.dart';
import 'package:ecommerce/home/fragments/home/search_cubit.dart';
import 'package:ecommerce/home/fragments/home/search_state.dart';
import 'package:ecommerce/home/fragments/wishlist/wishlist_bloc.dart';
import 'package:ecommerce/models/category_model.dart';
import 'package:ecommerce/models/page_model.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {

  List<String> slides = [];

  Random random = Random();

  String search = '';

  @override
  Widget build(BuildContext context) {
    return search.isNotEmpty ? searchView() : defaultView();
  }

  Widget defaultView() {
    return Scaffold(
      body: BlocConsumer<PageBloc, PageState>(listener: (context, state) {
        if (state is CategoriesLoaded) {
          if (state.categories.length > 0)
            BlocProvider.of<PageBloc>(context).add(
                LoadPage(state.categories[0].id!));
        }

        if (state is CategoriesLoadingFailed) {
          if (state.message == UNAUTHENTICATED_USER) {
            BlocProvider.of<AuthCubit>(context).removeToken();
            Navigator.of(context).popUntil((route) => route.isFirst);
            ///force logout
          }
        }

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
        if (state is PageInitial) {
          BlocProvider.of<PageBloc>(context).add(LoadCategories());
        }

        if (state is CategoriesLoadingFailed) {
          return FailureMessage(
            message: state.message,
            onRetry: () {
              BlocProvider.of<PageBloc>(context).add(LoadCategories());
            },
          );
        }

        if (state is PageLoadingFailed) {
          return FailureMessage(
            message: state.message,
            onRetry: () {
              if (state.categories.length > 0)
                BlocProvider.of<PageBloc>(context).add(
                    LoadPage(state.categories[0].id!));
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<PageBloc>(context).add(LoadCategories());
          },

          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                toolbarHeight: 150,
                titleSpacing: 0,
                backgroundColor: Colors.white,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _searchField(
                        state is PageLoaded || state is MorePageLoadingFailed),
                    Text(
                      '   Categories',
                      style: TextStyle(fontSize: 8, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 80,
                      child: categories(
                          state,
                          !(state is PageLoaded) &&
                              !(state is MorePageLoadingFailed)),
                    )
                  ],
                ),
              ),
              _list(state)
            ],
          ),
        );
      }),
    );
  }

  Widget searchView() {
    return Scaffold(
      body: BlocConsumer<SearchCubit, SearchState>(
          listener: (context, state) {
            if (state is SearchLoadingFailed) {
              if (state.message == UNAUTHENTICATED_USER) {
                BlocProvider.of<AuthCubit>(context).removeToken();
                Navigator.of(context).popUntil((route) => route.isFirst);
                ///force logout
              }
            }
            if (state is MoreSearchLoadingFailed) {
              if (state.message == UNAUTHENTICATED_USER) {
                BlocProvider.of<AuthCubit>(context).removeToken();
                Navigator.of(context).popUntil((route) => route.isFirst);
                ///force logout
              }
            }
          },
          builder: (context, state) {
            if (state is SearchLoadingFailed) {
              return FailureMessage(
                message: state.message,
                onRetry: () {
                  BlocProvider.of<SearchCubit>(context).search(search);
                },
              );
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  toolbarHeight: 60,
                  titleSpacing: 0,
                  backgroundColor: Colors.white,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _searchField(
                          state is SearchLoaded ||
                              state is MoreSearchLoadingFailed),

                    ],
                  ),
                ),
                searchList(state)
              ],
            );
          }),
    );
  }


  Widget categories(state, bool shimmer) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: shimmer ? 15 : state.categories.length,
      itemBuilder: (context, index) {
        if (shimmer) {
          return CategoryItem.shimmer();
        }
        return InkWell(
          onTap: index == 0
              ? null
              : () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) =>
                    MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                            value: BlocProvider.of<PageBloc>(context)),
                        BlocProvider.value(
                            value: BlocProvider.of<WishlistBloc>(context)),
                        BlocProvider.value(
                            value: BlocProvider.of<CartBloc>(context)),
                      ],
                      child: PageScreen(state.categories[index].id!,
                          state.categories[index].name!),
                    )));
          },
          child: CategoryItem(DOMAIN_URL + state.categories[index].image!,
              state.categories[index].name!),
        );
      },
    );
  }

  Widget searchList(state) {
    if (state is SearchLoaded ||
        state is MoreSearchLoadingFailed) {
      SearchLoaded _loadedSearch =
      state is MoreSearchLoadingFailed
          ? state.loadedSearch
          : state as SearchLoaded;
      return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if(_loadedSearch.products.length == 0){
                    return  Center(child: Column(
                      children: [
                        Image.asset("assets/images/empty.png",height: 100,width: 100,),
                        Text("Not found!")
                      ],
                    ));
                  }
              if (index < _loadedSearch.products.length) {
                // Show your info
                return WishlistItem(_loadedSearch.products[index], index);
              } else {
                if (state is MoreSearchLoadingFailed) {
                  return FailureMessage(message: state.message, onRetry: null);
                }
                BlocProvider.of<SearchCubit>(context).loadMore();
                return Center(child: CircularProgressIndicator());
              }
            },
            childCount:_loadedSearch.products.length == 0? 1 : _loadedSearch.next != null ? _loadedSearch.products
                .length + 1 : _loadedSearch.products.length,
          ));
    }

    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return WishlistItem.shimmer();
        }, childCount: 10));
  }

  Widget _list(state) {
    if (state is PageLoaded) {
      late PageModel pageModel;
      state.pages.forEach((page) {
        if (page.category == state.categories[0].id) {
          pageModel = page;
        }
      });
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
      return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              if (index < list.length) {
                // Show your info
                return _listItem(context, list[index], false);
              } else {
                if (state is MorePageLoadingFailed) {
                  return FailureMessage(message: state.message, onRetry: null);
                }
                BlocProvider.of<PageBloc>(context)
                    .add(LoadMorePage(state.categories[0].id!));
                return Center(child: CircularProgressIndicator());
              }
            },
            childCount: pageModel.next != null ? list.length + 1 : list.length,
          ));
    } else {
      ////shimmer list
      return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index == 0) {
              return _listItem(context, Results(viewType: 0), true);
            }
            return _listItem(
                context, Results(viewType: random.nextInt(3) + 1), true);
          }, childCount: 10));
    }
  }

  Widget _searchField(enabled) {
    return Container(
      color: PRIMARY_SWATCH,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),

      child: TextFormField(
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (value) {
          if (value.isNotEmpty && value.length > 2) {
          setState(() {
            search = value;
          });
            BlocProvider.of<SearchCubit>(context).search(value);
          }
          if(value.isEmpty){
            setState(() {
              search = value;
            });
          }
        },
        enabled: enabled,
        initialValue: search,
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey),
          fillColor: Colors.white,
          filled: true,
          enabledBorder: FOCUSED_BORDER,
          focusedBorder: FOCUSED_BORDER,
          disabledBorder: FOCUSED_BORDER,
          prefixIconConstraints: BoxConstraints.tight(Size(40, 30)),
          suffixIcon: search.isEmpty?null: IconButton(
            icon: Icon(FontAwesomeIcons.timesCircle,color: Colors.grey,), onPressed: () { setState(() {
              search = '';
            }); },
          ),
          prefixIcon: Center(
              child: Icon(
                Icons.search,
                color: Colors.grey,
              )),
        ),
      ),
    );
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
