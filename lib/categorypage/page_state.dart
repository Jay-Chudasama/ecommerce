import 'package:ecommerce/models/category_model.dart';
import 'package:ecommerce/models/page_model.dart';

abstract class PageState {
  List<PageModel> pages;
  List<CategoryModel> categories;

  PageState(this.pages, this.categories);
}

class PageInitial extends PageState {
  PageInitial(List<PageModel> pages, List<CategoryModel> categories) : super(pages, categories);
}

class CategoriesLoading extends PageState {
  CategoriesLoading(List<PageModel> pages, List<CategoryModel> categories) : super(pages, categories);
}

class CategoriesLoaded extends PageState {
  CategoriesLoaded(List<PageModel> pages, List<CategoryModel> categories) : super(pages, categories);
}

class CategoriesLoadingFailed extends PageState {
  String message;

  CategoriesLoadingFailed(this.message,List<PageModel> pages, List<CategoryModel> categories) : super(pages, categories);

}

class PageLoading extends PageState {
  PageLoading(List<PageModel> pages, List<CategoryModel> categories) : super(pages, categories);
}

class PageLoaded extends PageState {
  PageLoaded(List<PageModel> pages, List<CategoryModel> categories) : super(pages, categories);
}

class PageLoadingFailed extends PageState {
  String message;
  PageLoadingFailed(this.message,List<PageModel> pages, List<CategoryModel> categories) : super(pages, categories);

}

class MorePageLoadingFailed extends PageLoaded {
  String message;
  MorePageLoadingFailed(this.message,pages,categories) : super(pages,categories);
}
