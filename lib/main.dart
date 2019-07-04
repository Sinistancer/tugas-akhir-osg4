import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tugas_osg4/model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<IPList> future() async {
    http.Response response = await http.get(
        'https://db.ygoprodeck.com/api/v5/cardinfo.php?num=15&level=4&attribute=dark&sort=atk');
//    print(json.decode(response.body));
    if (response.statusCode == 200) {
      return IPList.fromJson(json.decode(response.body));
    } else {
      throw Exception('failed to load data');
    }
  }

  static Future<void> pop() async {
    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: Text('Tugas Akhir OSG-4'),
                centerTitle: true,
                actions: <Widget>[MyExitButton()]),
            body: Center(
              child: FutureBuilder(
                future: future(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return MyDataPage(data: snapshot);
                },
              ),
            )));
  }
}

class MyExitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
            icon: Icon(choices[0].icon),
            tooltip: 'Close app',
            onPressed: () {
              showAlertDialog(context);
            }));
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Batal"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        SystemNavigator.pop();
      },
    );
    // set up the AlertDialog
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Exit Application"),
      content: Text("Apakah anda yakin untuk keluar dari aplikasi ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Exit', icon: Icons.exit_to_app)
];

class MyDataPage extends StatefulWidget {
  final data;

  MyDataPage({Key key, this.data}) : super(key: key);

  @override
  _MyDataPageState createState() => _MyDataPageState();
}

class _MyDataPageState extends State<MyDataPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: _buildData(widget.data),
    );
  }

  Widget _buildData(var snapshot) {
    if (snapshot.hasData) {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(children: <Widget>[
            Column(
                children: (snapshot.data.list as List)
                    .map(
                      (i) => InkWell(
                          onTap: () {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(''),
                              action: SnackBarAction(
                                label: 'Go Detail',
                                onPressed: () {
                                  return Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyDetailPage(i.id)),
                                  );
                                },
                              ),
                            ));
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(15.0),
                                      width: 600,
                                      decoration: BoxDecoration(
                                        color: Color(0xff9be7ff),
                                        borderRadius:
                                            new BorderRadius.circular(8.0),
                                      ),
                                      child: Column(children: <Widget>[
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: 40.0,
                                                height: 60.0,
                                                decoration: new BoxDecoration(
                                                    color: Colors.white,
                                                    image: new DecorationImage(
                                                        image: new NetworkImage(
                                                            i.imageSmall),
                                                        fit: BoxFit.cover)),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(5.0)),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  children: <Widget>[
                                                    Text(i.name,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black)),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(i.race,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .grey)),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0)),
                                                        Text(i.type,
                                                            style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black))
                                                      ],
                                                    )
                                                  ]),
                                            ])
                                      ]),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )),
                    )
                    .toList())
          ]));
    } else if (snapshot.hasError) {
      return Text('${snapshot.error}');
    } else {
      return CircularProgressIndicator();
    }
  }
}

class MyDetailPage extends StatelessWidget {
  final id;

  MyDetailPage(this.id);

  Future<IPList> futureDetail() async {
    http.Response response = await http
        .get('https://db.ygoprodeck.com/api/v5/cardinfo.php?name=' + id);
//    print(response.body);
    if (response.statusCode == 200) {
      return IPList.fromJson(json.decode(response.body));
    } else {
      throw Exception('failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureDetail(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          return MyDataPageDetail(
              data: snapshot.data
          );
        } else {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class MyDataPageDetail extends StatefulWidget {
  final IPList data;

  MyDataPageDetail({Key key, this.data}) : super(key: key);

  @override
  _MyDataPageDetailState createState() => _MyDataPageDetailState();
}

class _MyDataPageDetailState extends State<MyDataPageDetail> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: _buildData(widget.data),
    );
  }

  Widget _buildData(var snapshot) {
    return Scaffold(
        appBar: AppBar(title: Text(snapshot.list[0].name), centerTitle: true),
        body: Center(
            child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(15.0),
                    width: 600,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(8.0)),
                    child: Column(children: <Widget>[
                      ClipRRect(
                        borderRadius: new BorderRadius.circular(8.0),
                        child: Image.network(
                          snapshot.list[0].imageBig,
                          width: 200,
                          height: 300,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                textDirection: TextDirection.ltr,
                                children: <Widget>[
                                  Text(snapshot.list[0].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.black)),
                                  Text(
                                      'Race: ' +
                                          snapshot.list[0].race +
                                          ' | Type: ' +
                                          snapshot.list[0].type,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.grey))
                                ])
                          ]),
                      Padding(padding: EdgeInsets.only(top: 8.0)),
                      Text(snapshot.list[0].desc,
                          textAlign: TextAlign.justify, softWrap: true)
                    ]),
                  )
                ],
              )
            ],
          ),
        )));
  }
}
