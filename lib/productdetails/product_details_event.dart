abstract class ProductDetailsEvent{}

class LoadProduct extends ProductDetailsEvent{
  late String id;

  LoadProduct(this.id);
}