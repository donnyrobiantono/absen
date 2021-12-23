import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LihatAbsen extends StatefulWidget {
  final String letak;

  LihatAbsen({required this.letak});
  @override
  _LihatAbsenState createState() => _LihatAbsenState();
}

Map? mapResponse;
List? listResponse;

class _LihatAbsenState extends State<LihatAbsen> {
  tampil() async {
    http.Response response;
    response = await http.get(
      Uri.parse(widget.letak),
    );
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = json.decode(response.body);
        listResponse = (mapResponse as dynamic)['data'];
      });
    }
  }

  @override
  void initState() {
    tampil();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 70,
          title: Text("APPROVAL"),
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
            return new Center(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 45, right: 45),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('NIP'),
                                    Text((listResponse as dynamic)[index]['nip']
                                        .toString())
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Status'),
                                    Text((listResponse as dynamic)[index]
                                            ['status']
                                        .toString())
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Tanggal'),
                                    Text(
                                        "${(listResponse as dynamic)[index]['tanggal'].toString()} - ${(listResponse as dynamic)[index]['bulan'].toString()} - ${(listResponse as dynamic)[index]['tahun'].toString()} "),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Pukul'),
                                    Text((listResponse as dynamic)[index]['jam']
                                        .toString())
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Lokasi Absen'),
                                    Text((listResponse as dynamic)[index]
                                            ['lokasi']
                                        .toString()),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Keterangan'),
                                    Text((listResponse as dynamic)[index]
                                            ['keterangan']
                                        .toString()),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                new Image(
                                  image: NetworkImage(
                                      "https://cobadonny.uptbali.com/uploads/${(listResponse as dynamic)[index]['evidence'].toString()}"),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async {
                              http.Response response;
                              response = await http.get(
                                Uri.parse(
                                    "https://cobadonny.uptbali.com/tolakabsen.php?id=" +
                                        (listResponse as dynamic)[index]['id']
                                            .toString()),
                              );
                              if (response.statusCode == 200) {
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.red),
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.warning,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Tolak",
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              http.Response response;
                              response = await http.get(
                                Uri.parse(
                                    "https://cobadonny.uptbali.com/setuju.php?id=" +
                                        (listResponse as dynamic)[index]['id']
                                            .toString()),
                              );
                              if (response.statusCode == 200) {
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.green),
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Setuju",
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
          itemCount: listResponse!.length,
        ));
  }
}
