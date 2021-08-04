import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:cowin/Models/localization_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

const Color color = Color(0xff344966);
const Color buttoncolorno = Color(0xffFF5E5B);
const Color buttoncoloryes = Color(0xff74A57F);

String _province;
DateTime selectedData;
String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
String provinceparam = "";
String dateparam = "";
String url =
    'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByDistrict?district_id=' +
        provinceparam +
        '&date=' +
        dateparam;
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

class DropDownApp extends StatefulWidget {
  @override
  createState() => _DropDownAppState();
}

class _DropDownAppState extends State<DropDownApp> {
  // ignore: deprecated_member_use
  List statesList = List();
  // ignore: deprecated_member_use
  List provincesList = List();
  // ignore: deprecated_member_use
  List tempList = List();
  String _state;
  List data;

  Future<String> loadStatesProvincesFromFile() async {
    return await rootBundle.loadString('json/new.json');
  }

  // ignore: missing_return
  Future<String> _populateDropdown() async {
    String getPlaces = await loadStatesProvincesFromFile();
    final jsonResponse = json.decode(getPlaces);

    Localization places = new Localization.fromJson(jsonResponse);

    setState(() {
      statesList = places.states;
      provincesList = places.provinces;
    });
  }
  //calendar

  @override
  void initState() {
    super.initState();
    this._populateDropdown();
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
        left: 0.25 * MediaQuery.of(context).size.width,
        child: Container(
          child: new Form(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 28),
              child: new Container(
                width: 350,
                child: Column(
                  children: <Widget>[
                    new DropdownButton(
                      style: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                      isExpanded: true,
                      icon: const Icon(
                        Icons.add_location,
                        color: Colors.white,
                      ),
                      items: statesList.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item.name),
                          value: item.id.toString(),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          _province = null;
                          _state = newVal;
                          tempList = provincesList
                              .where((x) =>
                                  x.stateId.toString() == (_state.toString()))
                              .toList();
                        });

                        // print(testingList.toString());
                      },
                      value: _state,
                      hint: Text(
                        'Select a state',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    new DropdownButton(
                      isExpanded: true,
                      style: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                      icon: const Icon(
                        Icons.gps_fixed,
                        color: Colors.white,
                      ),
                      items: tempList.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item.name),
                          value: item.id.toString(),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          _province = newVal;
                          provinceparam = _province.toString();
                          if (provinceparam is String) {
                            print(provinceparam);
                          }
                          url =
                              'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByDistrict?district_id=' +
                                  provinceparam +
                                  '&date=' +
                                  dateparam;
                        });
                      },
                      value: _province,
                      hint: Text(
                        'Select a province',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DateTimePicker(
                      type: DateTimePickerType.date,
                      dateMask: 'd MMM, yyyy',

                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 7)),
                      icon: Icon(
                        Icons.event,
                        color: Colors.white,
                      ),
                      dateLabelText: 'Date',
                      style: TextStyle(color: Colors.white),
                      selectableDayPredicate: (date) {
                        // Disable weekend days to select from the calendar
                        return true;
                      },
                      onChanged: (val) {
                        date = DateFormat("dd-MM-yyyy")
                            .format(DateTime.parse(val));
                        print(date);
                        dateparam = date;
                        url =
                            'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByDistrict?district_id=' +
                                provinceparam +
                                '&date=' +
                                dateparam;
                      },
                      validator: (val) {
                        date = DateFormat("dd-MM-yyyy")
                            .format(DateTime.parse(val));
                        print(date);
                        dateparam = date;
                        url =
                            'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByDistrict?district_id=' +
                                provinceparam +
                                '&date=' +
                                dateparam;
                        return null;
                      },
                      //onSaved: (val) => print(val),
                    ),
                    SizedBox(height: 10.0),
                    Row(
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
                    RaisedButton(
                        child: Text('Check slots'),
                        textColor: Colors.white,
                        color: buttoncoloryes,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SlotView()),
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
    return SafeArea(
      child: Scaffold(appBar: AppBar(), body: body),
    );
  }
}

class SlotView extends StatefulWidget {
  @override
  _SlotViewState createState() => _SlotViewState();
}

class _SlotViewState extends State<SlotView> {
  List data;
  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application.json"});

    setState(() {
      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson['sessions'];
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
                              new Text('Age limit: ' +
                                  data[index]['min_age_limit'].toString()),
                              new Text(
                                data[index]['vaccine'],
                                textAlign: TextAlign.center,
                              ),
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  new Text('Dose 1: ' +
                                      data[index]['available_capacity_dose1']
                                          .toString()),
                                  new SizedBox(width: 8),
                                  new Text('Dose 2: ' +
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
