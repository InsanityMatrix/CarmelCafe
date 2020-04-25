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
      builder: (BuildContext context, AsyncSnapshot<List<globals.Section>> snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('loading..');
          case ConnectionState.waiting:
            return new Text('loading..');
          default:
            if(snapshot.hasError) {
              return new Text("Report this Error: ${snapshot.error}");
            } else {
              return _buildNetItemGrid(context, snapshot.data);
            }
        }
      },
    );
  }
  Widget _buildNetItemGrid(BuildContext context, List<globals.Section> sections) {
    return GridView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: sections.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
            )
          ),
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
      builder: (BuildContext context, AsyncSnapshot<List<globals.Product>> snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('loading..');
          case ConnectionState.waiting:
            return new Text('loading..');
          default:
            if(snapshot.hasError) {
              return new Text("Report this Error: ${snapshot.error}");
            } else {
              return _buildNetItemGrid(context, snapshot.data);
            }
        }
      },
    );
  }
  Widget _buildNetItemGrid(BuildContext context, List<globals.Product> products) {
    return GridView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
                      child: Text(products[index].name),
                      onPressed: () {
                        //TODO: Navigate to product
                      },
                    ),
                  ),
              ],
            )
          ),
        );
      },
    );
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
                              "x3",// + globals.cart[index].quantity.toString(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(6.0),
                            child: Text(
                              "\$",/* +
                                  (globals.cart[index].quantity *
                                          globals.cart[index].price)
                                      .toStringAsFixed(2),*/
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

void addProduct(String name, double price, int quantity) {
  /*
  var newProduct = new globals.Product(name, price, quantity);
  for(int i = 0; i < globals.cart.length; i++) {
    if(globals.cart[i].name == name) {
      globals.cart.removeAt(i);
    }
  }
  globals.cart.add(newProduct);
  */
  print("Added Product");
}

void goToCart(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CartPage(title: "Your Order")),
  );
}
