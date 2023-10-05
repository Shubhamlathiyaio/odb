import 'package:flutter/material.dart';

import 'main.dart';

class view extends StatefulWidget {
  const view({super.key});

  @override
  State<view> createState() => _viewState();
}

class _viewState extends State<view> {
  List<Map> m = [];

  data() async {
    m = await Home.database!.rawQuery('select * from contact_book');
    print(m);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: FutureBuilder(future: data(), builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.done)
          return ListView.builder(
            itemCount: m.length,
            itemBuilder: (context, index) => Card(
                child: ListTile(
                    title: Text('${m[index]['name']}'),
                    subtitle : Text('${m[index]['contact']}'),
                    trailing: Wrap(
                      children: [
                        IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Home(m[index]),)), icon: Icon(Icons.edit)),
                        IconButton(onPressed: () => setState(() {
                          Home.database?.rawDelete('delete from contact_book where id=${m[index]['id']}');
                        }), icon: Icon(Icons.delete)),
                      ],
                    )
                )),
          );
        else
          return Center(child: CircularProgressIndicator());
      },)
    );
  }
}
