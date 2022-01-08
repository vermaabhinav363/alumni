import 'package:alumni/services/auth.dart';
import 'package:alumni/views/Add.dart';
import 'package:alumni/views/AddItem.dart';
import 'package:alumni/views/MyAd.dart';
import 'package:alumni/views/Shop.dart';
import 'package:alumni/views/intro.dart';
import 'package:alumni/views/search.dart';
import 'package:flutter/material.dart';

class SearchAdd extends StatefulWidget {
  const SearchAdd({Key? key}) : super(key: key);

  @override
  _SearchAddState createState() => _SearchAddState();
}
AuthMethods authMethods = new AuthMethods();
class _SearchAddState extends State<SearchAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.red,

        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => introduct()));

            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      body: Column(
        children: [

          Container(

          ),
        ],
      ),


    );
  }
}
class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                'Buy and Sell @BPHC',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Host an ad'),
            onTap: () => { Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItem()),
            )},
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Shop'),
            onTap: () => { Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Shop()),
            )},
          ),
          ListTile(
            leading: Icon(Icons.storage),
            title: Text('See my ads'),
            onTap: () => {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAd()),
            )},
          ),

        ],
      ),
    );
  }
}