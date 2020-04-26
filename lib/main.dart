import 'package:flutter/material.dart';
import 'package:carmel_cafe/globals.dart' as globals;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Set up our product prices first thing
    return MaterialApp(
      title: 'Carmel Cafe',
      theme: ThemeData(
        primaryColor: Color(0xFF005DAB),
        accentColor: Colors.blue,
        fontFamily: 'Georgia',
        textTheme: TextTheme(
          button: TextStyle(
            fontSize: 20.0,
            color: const Color(0xFFFFC324),
          ),
          title: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFFC324),
          ),
        ),
      ),
      home: MyHomePage(title: 'Carmel Cafe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          _futureGrid(),
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

  Widget _futureGrid() {
    return FutureBuilder<List<globals.Section>>(
      future: globals.getSections(),
      builder: (BuildContext context,
          AsyncSnapshot<List<globals.Section>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('loading..');
          case ConnectionState.waiting:
            return new Text('loading..');
          default:
            if (snapshot.hasError) {
              return new Text("Report this Error: ${snapshot.error}");
            } else {
              return _buildNetItemGrid(context, snapshot.data);
            }
        }
      },
    );
  }

  Widget _buildNetItemGrid(
      BuildContext context, List<globals.Section> sections) {
    return GridView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: sections.length,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext ctxt, int index) {
        return Container(
          child: Card(
              shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(child: Image.network(sections[index].imgLink)),
                  Container(
                    margin: const EdgeInsets.only(top: 0),
                    child: RaisedButton(
                      child: Text(sections[index].name),
                      onPressed: () {
                        navigateSection(context, sections[index].name);
                      },
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

  void navigateSection(BuildContext context, String section) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SectionPage(title: section)),
    );
  }
}

/* COFFEE */
class SectionPage extends StatefulWidget {
  SectionPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _SectionPageState createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          _futureGrid(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToCart(context);
        },
        tooltip: 'Your Cart',
        child: Icon(Icons.shopping_cart),
      ),
    );
  }

  Widget _futureGrid() {
    return FutureBuilder<List<globals.Product>>(
      future: globals.getSectionProducts(widget.title),
      builder: (BuildContext context,
          AsyncSnapshot<List<globals.Product>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('loading..');
          case ConnectionState.waiting:
            return new Text('loading..');
          default:
            if (snapshot.hasError) {
              return new Text("Report this Error: ${snapshot.error}");
            } else {
              return _buildNetItemGrid(context, snapshot.data);
            }
        }
      },
    );
  }

  Widget _buildNetItemGrid(
      BuildContext context, List<globals.Product> products) {
    return GridView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext ctxt, int index) {
        return Container(
          child: Card(
              shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(child: Image.network(products[index].image)),
                  Container(
                    margin: const EdgeInsets.only(top: 0),
                    child: RaisedButton(
                      child: Text(products[index].name,
                          textAlign: TextAlign.center),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductPage(
                                  title: widget.title,
                                  pID: products[index].id)),
                        );
                      },
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}

/* PRODUCT PAGE */
class ProductPage extends StatefulWidget {
  ProductPage({Key key, this.title, this.pID}) : super(key: key);

  final String title;
  final int pID;
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _radioValue1 = -1;
  int quantity = 0;
  double total = 0.0;
  globals.Product p;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildProduct(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToCart(context);
        },
        tooltip: 'Your Cart',
        child: Icon(Icons.shopping_cart),
      ),
    );
  }

  Widget _buildProduct() {
    return FutureBuilder<globals.Product>(
      future: globals.getProduct(widget.title, widget.pID),
      builder: (BuildContext context, AsyncSnapshot<globals.Product> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('loading..');
          case ConnectionState.waiting:
            return new Text('loading..');
          default:
            if (snapshot.hasError) {
              return new Text("Report this Error: ${snapshot.error}");
            } else {
              return _buildProductLayout(context, snapshot.data);
            }
        }
      },
    );
  }

  List<Widget> _buildOptions(String options) {
    List<Widget> optionList = new List();
    RegExp exp = new RegExp(r"#(\w+\s*\w*)");
    Iterable<RegExpMatch> matches = exp.allMatches(options);
    for (int i = 0; i < matches.length; i++) {
      String option = matches.elementAt(i).group(1);
      Widget row = new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Radio(
            value: i,
            groupValue: _radioValue1,
            onChanged: _handleRadioValueChange5,
          ),
          Text(option),
        ],
      );
      optionList.add(row);
    }
    return optionList;
  }

  void _handleRadioValueChange5(int value) {
    setState(() {
      _radioValue1 = value;
    });
  }

  Widget _buildProductLayout(BuildContext context, globals.Product product) {
    p = product;
    if (quantity == 0) {
      //Check if product already in cart
      for (int i = 0; i < globals.cart.length; i++) {
        if (globals.cart[i].product.id == p.id) {
          quantity = globals.cart[i].quantity;
          total = p.price * quantity;
        }
      }
    }
    if (product.options == null || product.options == '') {
      return Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: Image.network(
              product.image,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(6.0),
            child: Text(
              product.name,
              style: Theme.of(context).textTheme.title,
              textAlign: TextAlign.center,
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                color: Theme.of(context).accentColor,
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
                onPressed: () {
                  decreaseQuantity();
                },
              ),
              Container(
                padding: EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
                child: Text(quantity.toString()),
              ),
              FlatButton(
                color: Theme.of(context).accentColor,
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  increaseQuantity();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                  padding: EdgeInsets.all(8.0),
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    "Add to Cart ($total)",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  onPressed: () {
                    addProduct(p, quantity);
                  }),
            ],
          )
        ],
      );
    } else {
      //Use Regex to parse options and put in radio buttons
      List<Widget> options = _buildOptions(product.options);
      return Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: Image.network(
              product.image,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(6.0),
            child: Text(
              product.name,
              style: Theme.of(context).textTheme.title,
              textAlign: TextAlign.center,
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                color: Theme.of(context).accentColor,
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
                onPressed: () {
                  decreaseQuantity();
                },
              ),
              Container(
                padding: EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
                child: Text(quantity.toString()),
              ),
              FlatButton(
                color: Theme.of(context).accentColor,
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  increaseQuantity();
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return options[index];
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                  padding: EdgeInsets.all(8.0),
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    "Add to Cart ($total)",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  onPressed: () {
                    addProduct(p, quantity);
                  }),
            ],
          )
        ],
      );
    }
  }

  void increaseQuantity() {
    setState(() {
      total = ++quantity * p.price;
    });
  }

  void decreaseQuantity() {
    if (quantity > 0) {
      setState(() {
        total = --quantity * p.price;
      });
    }
  }
}

/* CART */
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
      body: _buildCart(context),
    );
  }

  Column _buildCart(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: globals.cart.length,
              /* For each item
               -Display the product name
               -Display the quantity
               -Add an option to remove from cart
               */
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
                        globals.cart[index].product.name,
                        textAlign: TextAlign.left,
                        textScaleFactor: 1.4,
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
                              "\$" +
                                  (globals.cart[index].quantity *
                                          globals.cart[index].product.price)
                                      .toStringAsFixed(2),
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
        ),
        RaisedButton(
          padding:
              EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            //TODO: Purchasing logic
          },
          child: Text(
            "Purchase",
            style: Theme.of(context).textTheme.button,
          ),
        ),
      ],
    );
  }
}

void addProduct(globals.Product product, int quantity) {
  var newPurchase = new globals.Purchase(product, quantity);
  for (int i = 0; i < globals.cart.length; i++) {
    if (globals.cart[i].product.name == product.name) {
      globals.cart.removeAt(i);
    }
  }
  globals.cart.add(newPurchase);

  print("Added Product");
}

void goToCart(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CartPage(title: "Your Order")),
  );
}
