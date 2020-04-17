library carmel_cafe.globals;

List<Product> cart = List<Product>();


class Product {
  String name;
  double price;
  int quantity;

  Product(this.name, this.price, this.quantity);
}