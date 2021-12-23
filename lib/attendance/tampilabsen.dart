import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Absen extends StatefulWidget {
  const Absen({Key? key}) : super(key: key);
  @override
  _AbsenState createState() => new _AbsenState();
}

class _AbsenState extends State {
  List? data;
  var value1;
  var bulan;
  var loading = false;
  Future<String> getData() async {
    var bln = new DateTime.now();
    var formatedbulan = new DateFormat("M").format(bln);
    setState(() {
      bulan = formatedbulan;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value1 = preferences.getString('nip');
    });
    http.Response response = await http.get(
        Uri.parse("https://cobadonny.uptbali.com/tampilabsen.php?nip=" +
            value1 +
            "&bulan=" +
            bulan),
        headers: {"Accept": "application/json"});

    setState(() {
      data = json.decode(response.body);
    });
    return "Success?";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Data Absensi"),
        backgroundColor: Colors.blueAccent,
      ),
      body: new ListView.builder(
        itemCount: data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
              elevation: 4,
              child: data?[index]["status"] == "CLOCK IN"
                  ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          color: Colors.lightGreen),
                      padding: EdgeInsets.all(10),
                      height: 100,
                      child: data?[index]["story"] == "Approve"
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '${data?[index]["tanggal"]}-${data?[index]["bulan"]}-${data?[index]["tahun"]}',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Text(data?[index]["status"]),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                new Text(
                                  data?[index]["jam"],
                                  style: TextStyle(fontSize: 17),
                                ),
                                Icon(Icons.check)
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '${data?[index]["tanggal"]}-${data?[index]["bulan"]}-${data?[index]["tahun"]}',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Text(data?[index]["status"]),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                new Text(
                                  data?[index]["jam"],
                                  style: TextStyle(fontSize: 17),
                                ),
                                Icon(Icons.phone)
                              ],
                            ))
                  : Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          color: Colors.redAccent),
                      padding: EdgeInsets.all(10),
                      height: 100,
                      child: data?[index]["story"] == "Approve"
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '${data?[index]["tanggal"]}-${data?[index]["bulan"]}-${data?[index]["tahun"]}',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Text(data?[index]["status"]),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                new Text(
                                  data?[index]["jam"],
                                  style: TextStyle(fontSize: 17),
                                ),
                                Icon(Icons.check)
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '${data?[index]["tanggal"]}-${data?[index]["bulan"]}-${data?[index]["tahun"]}',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Text(data?[index]["status"]),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                new Text(
                                  data?[index]["jam"],
                                  style: TextStyle(fontSize: 17),
                                ),
                                Icon(Icons.phone)
                              ],
                            )));
        },
      ),
    );
  }
}
