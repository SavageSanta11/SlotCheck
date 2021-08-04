import 'package:flutter/material.dart';
import 'package:cowin/widgets/drop_down.dart';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

const Color color = Color(0xff344966);
const Color buttoncolorno = Color(0xffFF5E5B);
const Color buttoncoloryes = Color(0xff74A57F);

String pin;
String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
String dateparam = "";
String pinUrl =
    'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=' +
        pin +
        '&date=' +
        date;
bool a1 = true;
bool a2 = false;
bool b1 = true;
bool b2 = false;
bool c1 = true;
bool c2 = false;

int agelim = 18;
String vax = 'COVISHIELD';
String dose = 'available_capacity_dose1';

void toggleAge1() {
  a1 = !a1;
  a2 = !a2;
  if (a1) {
    agelim = 18;
  } else {
    agelim = 45;
  }
  print(agelim);
}

void toggleVax1() {
  b1 = !b1;
  b2 = !b2;
  if (b1) {
    vax = 'COVISHIELD';
  } else {
    vax = 'COVAXIN';
  }
  print(vax);
}

void toggleDose1() {
  c1 = !c1;
  c2 = !c2;
  if (c1) {
    dose = 'available_capacity_dose1';
  } else {
    dose = 'available_capacity_dose2';
  }
  print(dose);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool hide = false;
  @override
  Widget build(BuildContext context) {
    const Color buttoncoloryes = Color(0xff74A57F);
    final alucard = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          SizedBox(height: 80.0),
          CircleAvatar(
              radius: 72.0,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/crowd.png')),
        ]),
      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(children: <Widget>[
        SizedBox(
          height: 40.0,
        ),
        Text(
          'Welcome to SlotCheck',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28.0, color: Colors.white),
        ),
      ]),
    );

    final lorem = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Click on the button below to start looking for vaccination slots',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0, color: Colors.white),
      ),
    );
    const Color color = Color(0xff344966);
    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: color,
      ),
      child: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            alucard,
            welcome,
            lorem,
            SizedBox(height: 20.0),
            RaisedButton(
              child: new Text("Check Slots"),
              textColor: Colors.white,
              color: buttoncoloryes,
              onPressed: () {
                setState(() {
                  hide = !hide;
                });
              },
            ),
            SizedBox(height: 40.0),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  AnimatedOpacity(
                      opacity: hide ? 1 : 0,
                      duration: Duration(seconds: 1),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 0.4 * MediaQuery.of(context).size.width,
                            height: 50.0,
                            child: RaisedButton(
                                child: new Text("Search by district"),
                                textColor: Colors.white,
                                color: buttoncoloryes,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DropDownApp()),
                                  );
                                }),
                          ),
                          SizedBox(width: 10.0),
                          SizedBox(
                            width: 0.4 * MediaQuery.of(context).size.width,
                            height: 50.0,
                            child: RaisedButton(
                                child: new Text("Search by PIN"),
                                textColor: Colors.white,
                                color: buttoncoloryes,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => pinChoice()),
                                  );
                                }),
                          ),
                        ],
                      )),
                ])
          ],
        ),
      ]),
    );

    return Scaffold(
      body: body,
    );
  }
}

// ignore: camel_case_types

// ignore: camel_case_types
class pinChoice extends StatefulWidget {
  @override
  _pinChoiceState createState() => _pinChoiceState();
}

// ignore: camel_case_types
class _pinChoiceState extends State<pinChoice> {
  TextEditingController _controller;

  List data;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final body = Stack(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(28.0),
        decoration: BoxDecoration(
          color: color,
        ),
      ),
      Positioned(
        top: 0.20 * MediaQuery.of(context).size.height,
        left: 0.22 * MediaQuery.of(context).size.width,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                width: 0.6 * MediaQuery.of(context).size.width,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter a PIN code',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  controller: _controller,
                  onChanged: (value) {
                    setState(() {
                      pin = value.toString();

                      pinUrl =
                          'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=' +
                              pin +
                              '&date=' +
                              date;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 0.6 * MediaQuery.of(context).size.width,
                child: DateTimePicker(
                  type: DateTimePickerType.date,
                  dateMask: 'd MMM, yyyy',

                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 7)),
                  icon: Icon(Icons.event, color: Colors.white),
                  style: TextStyle(color: Colors.white),
                  dateLabelText: 'Date',

                  selectableDayPredicate: (date) {
                    // Disable weekend days to select from the calendar
                    return true;
                  },
                  onChanged: (val) {
                    date = DateFormat("dd-MM-yyyy").format(DateTime.parse(val));
                    print(date);
                    dateparam = date;
                    pinUrl =
                        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=' +
                            pin +
                            '&date=' +
                            date;
                  },
                  validator: (val) {
                    date = DateFormat("dd-MM-yyyy").format(DateTime.parse(val));
                    print(date);
                    dateparam = date;
                    pinUrl =
                        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=' +
                            pin +
                            '&date=' +
                            date;
                    return null;
                  },
                  //onSaved: (val) => print(val),
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                      child: new Text('18-44'),
                      textColor: Colors.white,
                      color: a1 ? buttoncoloryes : buttoncolorno,
                      onPressed: () => setState(() => toggleAge1())),
                  SizedBox(
                    width: 8.0,
                  ),
                  new RaisedButton(
                      child: new Text('45+'),
                      textColor: Colors.white,
                      color: a2 ? buttoncoloryes : buttoncolorno,
                      onPressed: () => setState(() => toggleAge1())),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                      child: new Text('COVISHIELD'),
                      textColor: Colors.white,
                      color: b1 ? buttoncoloryes : buttoncolorno,
                      onPressed: () => setState(() => toggleVax1())),
                  SizedBox(
                    width: 8.0,
                  ),
                  new RaisedButton(
                      child: new Text('COVAXIN'),
                      textColor: Colors.white,
                      color: b2 ? buttoncoloryes : buttoncolorno,
                      onPressed: () => setState(() => toggleVax1())),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                      child: new Text('Dose 1'),
                      textColor: Colors.white,
                      color: c1 ? buttoncoloryes : buttoncolorno,
                      onPressed: () => setState(() => toggleDose1())),
                  SizedBox(
                    width: 8.0,
                  ),
                  new RaisedButton(
                      child: new Text('Dose 2'),
                      textColor: Colors.white,
                      color: c2 ? buttoncoloryes : buttoncolorno,
                      onPressed: () => setState(() => toggleDose1())),
                ],
              ),
              SizedBox(height: 15.0),
              ElevatedButton(
                  child: Text('Check slots'),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => pinSlotView()),
                    );
                  }),
            ],
          ),
        ),
      ),
    ]);
    return Scaffold(appBar: AppBar(), body: body);
  }
}

// ignore: camel_case_types
class pinSlotView extends StatefulWidget {
  @override
  _pinSlotViewState createState() => _pinSlotViewState();
}

// ignore: camel_case_types
class _pinSlotViewState extends State<pinSlotView> {
  List data;
  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async {
    var response = await http
        .get(Uri.encodeFull(pinUrl), headers: {"Accept": "application.json"});

    setState(() {
      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson['sessions'];

      print(pinUrl);
    });
    return "Success";
  }

  Widget build(BuildContext context) {
    const Color color = Color(0xff344966);
    final body = Stack(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(28.0),
        decoration: BoxDecoration(
          color: color,
        ),
      ),
      new ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return (data[index]['min_age_limit'] == agelim &&
                    data[index]['vaccine'] == vax &&
                    data[index][dose] > 0)
                ? new Container(
                    child: new Center(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Card(
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new ListTile(
                                leading: Icon(Icons.local_hospital),
                                title: new Text(data[index]['name']),
                                subtitle: new Text(data[index]['address']),
                              ),
                              new Text(
                                data[index]['vaccine'],
                                textAlign: TextAlign.center,
                              ),
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  new Text('Dose 1:' +
                                      data[index]['available_capacity_dose1']
                                          .toString()),
                                  new SizedBox(width: 8),
                                  new Text('Dose 2:' +
                                      data[index]['available_capacity_dose2']
                                          .toString()),
                                  new SizedBox(width: 8),
                                ],
                              ),
                              new InkWell(
                                  child: new Text(
                                    'Book Slot',
                                    style: TextStyle(color: Colors.blue),
                                    textAlign: TextAlign.right,
                                  ),
                                  onTap: () =>
                                      launch('https://www.cowin.gov.in/home')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
                : SizedBox();
          })
    ]);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Slots"),
      ),
      body: body,
    );
  }
}
