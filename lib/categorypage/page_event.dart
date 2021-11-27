import 'package:ecommerce/categorypage/page_state.dart';
import 'package:ecommerce/models/category_model.dart';
import 'package:ecommerce/models/page_model.dart';

abstract class PageEvent{}

class LoadCategories extends PageEvent {
}

class LoadPage extends PageEvent{
  String categoryId;

  LoadPage(this.categoryId);
}

class LoadMorePage extends PageEvent{
  String categoryId;

  LoadMorePage(this.categoryId);
}