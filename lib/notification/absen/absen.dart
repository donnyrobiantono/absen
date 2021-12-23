import 'dart:convert';

import 'package:absensi/notification/absen/lihat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? stringResponse;
Map? mapResponse;
var value2;
var bulan;
List? listResponse;

class NotifAbsen extends StatefulWidget {
  @override
  _NotifAbsenState createState() => _NotifAbsenState();
}

class _NotifAbsenState extends State<NotifAbsen> {
  Future apiCall() async {
    var bln = new DateTime.now();
    var formatedbulan = new DateFormat("M").format(bln);
    setState(() {
      bulan = formatedbulan;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      //value1 = preferences.getString('nip');
      value2 = preferences.getString('nama');
    });
    http.Response response;
    response = await http.get(
      Uri.parse("https://cobadonny.uptbali.com/notifikasiabsen.php?atasan=" +
          value2 +
          "&bulan=" +
          bulan),
    );
    if (response.statusCode == 200) {
      setState(() {
        //stringResponse = response.body;
        mapResponse = json.decode(response.body);
        listResponse = (mapResponse as dynamic)['data'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiCall();
  }

  String? _id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 70,
          title: Text("APPROVAL ABSENSI"),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Colors.blue),
          ),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _id = (listResponse as dynamic)[index]['id'].toString();
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LihatAbsen(
                              letak:
                                  "https://cobadonny.uptbali.com/approval.php?id=" +
                                      _id!)));
                },
                child: Card(
                    elevation: 4,
                    child: (listResponse as dynamic)[index]['status']
                                .toString() ==
                            "CLOCK IN"
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Colors.lightGreen),
                            padding: EdgeInsets.all(10),
                            height: 70,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      (listResponse as dynamic)[index]['nip']
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      (listResponse as dynamic)[index]['status']
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text((listResponse as dynamic)[index]['jam']
                                    .toString())
                              ],
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Colors.red),
                            padding: EdgeInsets.all(10),
                            height: 70,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      (listResponse as dynamic)[index]['nip']
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      (listResponse as dynamic)[index]['status']
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text((listResponse as dynamic)[index]['jam']
                                    .toString())
                              ],
                            ),
                          )),
              ),
            );
          },
          itemCount: listResponse == null ? 0 : listResponse!.length,
        ));
  }
}
