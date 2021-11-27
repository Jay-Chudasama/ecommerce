
import 'package:dio/dio.dart';
import 'package:ecommerce/categorypage/page_event.dart';
import 'package:ecommerce/categorypage/page_repository.dart';
import 'package:ecommerce/categorypage/page_state.dart';
import 'package:ecommerce/models/category_model.dart';
import 'package:ecommerce/models/page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageBloc extends Bloc<PageEvent,PageState>{
  PageRepository _pageRepository = PageRepository();

  PageBloc() : super(PageInitial([],[]));

  @override
  Stream<PageState> mapEventToState(PageEvent event) async* {
    PageState newState;

    if(event is LoadCategories){
      newState=  CategoriesLoading([],[]);
      yield newState;
      await _pageRepository.loadCategories().then((response){
        var data = response.data;
        List<CategoryModel> list = List.from(data.map((json)=>CategoryModel.fromJson(json)));
        newState =  CategoriesLoaded([],list);
      }).catchError((value){
        DioError error = value;
        if (error.response != null) {
          try {
            newState=CategoriesLoadingFailed(error.response!.data,state.pages,state.categories);
          } catch (e) {
            newState=CategoriesLoadingFailed(error.response!.data['detail'],state.pages,state.categories);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState=CategoriesLoadingFailed("Please check your internet connection!",state.pages,state.categories);
          } else {
            newState=CategoriesLoadingFailed(error.message,state.pages,state.categories);
          }
        }
      });
      yield newState;
    }else if (event is LoadPage){

      newState = PageLoading(state.pages,state.categories);
      yield newState;
      await _pageRepository.loadPage(category: event.categoryId).then((response){
//        IT WILL ADD NEW PAGE
        PageModel pageModel = PageModel.fromJson(response.data);
        try{
          state.pages.removeWhere((element) => element.category==event.categoryId);
        }catch(e){
//          nothing
        }
        state.pages.add(pageModel);
        newState =  PageLoaded(state.pages,state.categories);
      }).catchError((value){
        DioError error = value;
        if (error.response != null) {
          try {
            newState = PageLoadingFailed(error.response!.data,state.pages,state.categories);
          } catch (e) {
            newState = PageLoadingFailed(error.response!.data['detail'],state.pages,state.categories);
          }
        } else {
          if (error.type == DioErrorType.other) {
            newState = PageLoadingFailed("Please check your internet connection!",state.pages,state.categories);
          } else {
            newState = PageLoadingFailed(error.message,state.pages,state.categories);
          }
        }
      });
      yield newState;
    } else if(event is LoadMorePage){
      late PageModel pageModel;

      state.pages.forEach((page) {
        if(page.category==event.categoryId){
          pageModel = page;
        }
      });
      newState = state; ///same videos


      await _pageRepository.loadMorePage(nextUrl: pageModel.next!).then((response){
        var data = response.data;
        List<Results> list = List.from(data['results'].map((json)=>Results.fromJson(json)));
        pageModel.results!.addAll(list);
        pageModel.next = data['next'];
        pageModel.previous = data['previous'];
        newState =  PageLoaded(state.pages,state.categories);
      }).catchError((value){
        print(value);
        DioError error = value;
        if (error.response != null) {
          newState =  MorePageLoadingFailed(error.response!.data['detail'],state.pages,state.categories);
        } else {
          if (error.type == DioErrorType.other) {
            newState = MorePageLoadingFailed("Please check your internet connection!",state.pages,state.categories);
          } else {
            newState = MorePageLoadingFailed(error.message,state.pages,state.categories);
          }
        }
      });
      yield newState;
    }
  }

}