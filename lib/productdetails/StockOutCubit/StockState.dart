abstract class StockState{}

class InStock extends StockState{
  late int quantity;

  InStock(this.quantity);
}
class StockOut extends StockState{}