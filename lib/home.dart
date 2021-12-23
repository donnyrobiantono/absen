import 'dart:convert';

import 'package:absensi/attendance/tampilabsen.dart';
import 'package:absensi/awalan.dart';
import 'package:absensi/keluar/clockoutdalam.dart';
import 'package:absensi/masuk/clockindalam.dart';
import 'package:absensi/masuk/clockinluar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'account/model.dart';
import 'keluar/clockoutluar.dart';

class HomeState extends StatefulWidget {
  @override
  _HomeStateState createState() => _HomeStateState();
}

class _HomeStateState extends State<HomeState> {
  var value1;
  Future<MProfile> tampil() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value1 = preferences.getString('nip');
    });
    var url =
        Uri.parse('https://cobadonny.uptbali.com/profile.php?nip=' + value1);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return MProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  late Future<MProfile> futureProfile;

  @override
  void initState() {
    super.initState();

    futureProfile = tampil();
  }

  void getLocationmasuk() async {
    var value1, value2;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value1 = preferences.getString('lat');
      value2 = preferences.getString('long');
    });

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var distanceInMeters = Geolocator.distanceBetween(position.latitude,
        position.longitude, double.parse(value1), double.parse(value2));
    print("$distanceInMeters Meter");
    if (distanceInMeters >= 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Clockin()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ClockInDalam()));
    }
  }

  void getLocationkeluar() async {
    var value1, value2;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value1 = preferences.getString('lat');
      value2 = preferences.getString('long');
    });

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var distanceInMeters = Geolocator.distanceBetween(position.latitude,
        position.longitude, double.parse(value1), double.parse(value2));
    print("$distanceInMeters Meter");
    if (distanceInMeters >= 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ClockOut()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ClockOutDalam()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            ClipPath(
              clipper: CustomShape(),
              child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                color: Colors.blue,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<MProfile>(
                      future: futureProfile,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Center(
                              child: Center(
                                  child: Column(
                            children: [
                              Text(snapshot.data!.namaPegawai,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25)),
                              Text('Have A Nice Day',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20))
                            ],
                          )));
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }

                        // By default, show a loading spinner.
                        return Center(
                          child: const CircularProgressIndicator(),
                        );
                      },
                    )
                  ],
                )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Container(
                margin: EdgeInsets.only(top: 150),
                height: 100,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 3))
                ], borderRadius: BorderRadius.circular(10), color: Colors.grey),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 150,
                          height: 65,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xff689f38),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              getLocationmasuk();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.download,
                                  size: 35,
                                  color: Colors.white,
                                ),
                                Text(
                                  "CLock In",
                                  style: TextStyle(
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 150,
                          height: 65,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xffb71c1c),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              getLocationkeluar();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload,
                                  size: 35,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Clock Out",
                                  style: TextStyle(
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade400,
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: Offset(0, 3))
                      ],
                      color: Colors.brown[50],
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 300),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Absen()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                height: 100,
                                width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.alarm,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Attendance")
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                height: 100,
                                width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.alarm_add,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Lembur")
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                height: 100,
                                width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.alarm_off,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Absence")
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 50);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
