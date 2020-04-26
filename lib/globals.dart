library carmel_cafe.globals;

import 'package:http/http.dart' as http;
import 'dart:convert';
class Section {
  String name;
  int id;
  String imgLink;
  int total;
  Section(this.id, this.name, this.total);
  Section.withImage(this.id, this.name, this.total, this.imgLink);
}
String ip = "http://165.227.91.153:25510";
List<Purchase> cart = List<Purchase>();


Future<List<Section>> getSections() async {
  var url = ip + '/products';
  var response = await http.get(url);
  List l = json.decode(response.body);
  List<Section> c = new List();
  l.forEach((i){
    c.add(new Section.withImage(i['ProductID'], i['Name'], i['Total'],i['Image']));
  });
  return c;
}

Future<List<Product>> getSectionProducts(String section) async {
  var url = ip + '/section';
  var response = await http.post(url, body: {"Section":section});
  List l = json.decode(response.body);
  List<Product> c = new List();
  l.forEach((i){
    String options;
    if(i['Options'] == null) {
      options = "";
    } else {
      options = i['Options'];
    }
    c.add(new Product(i['ProductID'], i['Name'], i['Price'].toDouble(), options,i['Image']));
  });
  return c;
}
Future<Product> getProduct(String section, int pID) async {
  var url = ip + '/product';
  dynamic response = await http.post(url, body: {"Section":section,"ProductID":pID.toString()});
  var decoded = jsonDecode(response.body);
  Product product = new Product(decoded['ProductID'], decoded['Name'], decoded['Price'].toDouble(), decoded['Options'],decoded['Image']);
  return product;
}

class Product {
  int id;
  String name;
  double price;
  String options;
  String image;
  Product(this.id, this.name, this.price, this.options, this.image);
}

class Purchase {
  Product product;
  int quantity;
  String flavor;
  Purchase(this.product, this.quantity) {
    this.flavor = "None";
  }
  Purchase.withFlavor(this.product, this.quantity, this.flavor);
  bool hasFlavor() {
    if(this.flavor == "None") {
      return false;
    } else {
      return true;
    }
  }
}