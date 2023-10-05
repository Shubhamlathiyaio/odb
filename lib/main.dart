import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'View.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  Map? m;

  Home([this.m]);

  static Database? database;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_database();
    if (widget.m != null) {
      name.text = widget.m!['name'];
      contact.text = widget.m!['contact'];
      city.text = widget.m!['city'];
    }
  }

  TextEditingController name = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController city = TextEditingController();

  get_database() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

// open the database
    Home.database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE contact_book (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,contact TEXT,city TEXT)');
    });
  }

  Widget tf(TextEditingController t, String s, Icon i) {
    return TextField(
      controller: t,
      decoration: InputDecoration(hintText: s, icon: i, enabled: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            tf(name, "Enter the Name", Icon(Icons.account_circle)),
            tf(contact, "Enter the Phone number", Icon(Icons.phone)),
            tf(city, "Enter the City", Icon(Icons.location_city)),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      if (widget.m == null)
                        Home.database!.rawInsert("insert into contact_book values(null,'${name.text}','${contact.text}','${city.text}')");
                      else
                        Home.database?.rawUpdate("update contact_book set name='${name.text}',contact='${contact.text}',city='${city.text}' where id=${widget.m!['id']}");
                      name.text = '';
                      contact.text = '';
                      city.text = '';
                    },
                    child: widget.m == null ? Text('ADD') : Text('UPDATE')),
                ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => view(),
                        )),
                    child: Text('VIEW')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
