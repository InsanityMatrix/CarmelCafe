import 'package:flutter/material.dart';
import 'package:carmel_cafe/globals.dart' as globals;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carmel Cafe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Carmel Cafe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Text(
            "Carmel Cafe Options",
            textAlign: TextAlign.center,
          ),
          _buildItemGrid(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),
        tooltip: 'Your Cart',
        onPressed: () {
          goToCart(context);
        },
      ),
    );
  }

  Widget _buildItemGrid() {
    return GridView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: 2,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Card(
              shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(child: Image.network(_getImg(index))),
                  Container(
                    margin: const EdgeInsets.only(top: 0),
                    child: RaisedButton(
                      child: Text(_getProduct(index)),
                      onPressed: () {
                        NavigateProduct(context, index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  String _getImg(int index) {
    switch (index) {
      case 0:
        return "https://images-gmi-pmc.edge-generalmills.com/087d17eb-500e-4b26-abd1-4f9ffa96a2c6.jpg";
        break;
      case 1:
        return "https://cdn.pixabay.com/photo/2016/04/26/16/58/coffe-1354786_960_720.jpg";
        break;
      case 2:
        return "https://assets.bonappetit.com/photos/57ace0f51b334044149752a2/16:9/w_2560,c_limit/LEMONADE.jpg";
        break;
      default:
        return "Cookie";
    }
  }

  String _getProduct(int index) {
    switch (index) {
      case 0:
        return "Cookies";
        break;
      case 1:
        return "Coffee";
        break;
      case 2:
        return "Drinks";
        break;
      default:
        return "Error";
    }
  }

  void NavigateProduct(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CookiePage(title: "Carmel Cafe")),
        );
        break;
      default:
        return;
    }
  }
}

class CookiePage extends StatefulWidget {
  CookiePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _CookiePageState createState() => _CookiePageState();
}

class _CookiePageState extends State<CookiePage> {
  int _quantity = 0;
  double _price = 1.00;
  double _total = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: (MediaQuery.of(context).size.width),
            child: Image.network(
              "https://images-gmi-pmc.edge-generalmills.com/087d17eb-500e-4b26-abd1-4f9ffa96a2c6.jpg",
            ),
          ),
          Container(
            color: const Color(0xFF005DAB),
            padding: EdgeInsets.all(5),
            width: (MediaQuery.of(context).size.width),
            child: Text(
              "Cookies",
              textAlign: TextAlign.center,
              textScaleFactor: 2.0,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFC324),
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                  color: Colors.blue,
                  child: Text(
                    "-",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    decreaseQuantity();
                  }),
              Container(
                padding: EdgeInsets.only(left: 40, right: 40),
                child: Text("$_quantity"),
              ),
              FlatButton(
                  color: Colors.blue,
                  child: Text(
                    "+",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    increaseQuantity();
                  }),
            ],
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: RaisedButton(
                  color: Colors.blue,
                  padding: EdgeInsets.only(
                      top: 6.0, bottom: 6.0, right: 12.0, left: 12.0),
                  child: Text(
                    "Add to Cart (\$" + _total.toStringAsFixed(2) + ")",
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    addProduct("Cookies", _price, _quantity);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            goToCart(context);
          },
          tooltip: 'Your Cart',
          child: Icon(Icons.shopping_cart)),
    );
  }

  void increaseQuantity() {
    setState(() {
      _quantity++;
      _total = _quantity * _price;
    });
  }

  void decreaseQuantity() {
    setState(() {
      if (_quantity > 0) {
        _quantity--;
      }
      _total = _quantity * _price;
    });
  }
}

class CartPage extends StatefulWidget {
  CartPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: globals.cart.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Container(
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 10.0, bottom: 6.0),
              margin: EdgeInsets.only(left: 6.0, right: 6.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2.0, color: Colors.grey),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    globals.cart[index].name,
                    textAlign: TextAlign.left,
                    textScaleFactor: 1.8,
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(6.0),
                        child: Text(
                          "x" + globals.cart[index].quantity.toString(),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(6.0),
                        child: Text(
                          "\$" + (globals.cart[index].quantity * globals.cart[index].price).toStringAsFixed(2),
                        ),
                      ),
                      FlatButton(
                        color: Colors.red,
                        child: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            globals.cart.removeAt(index);
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}

void addProduct(String name, double price, int quantity) {
  var newProduct = new globals.Product(name, price, quantity);
  globals.cart.add(newProduct);
}

void goToCart(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CartPage(title: "Your Order")),
  );
}
