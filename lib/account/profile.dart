

import 'dart:convert';

import 'package:absensi/login.dart';
import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'model.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    setState(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    });
  }

  late Future<MProfile> futureProfile;

  @override
  void initState() {
    super.initState();

    futureProfile = tampil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper:
                      CustomShape(), // this is my own class which extendsCustomClipper
                  child: Container(
                    height: 150,
                    color: Colors.blue,
                  ),
                ),
                SafeArea(
                    child: Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                FutureBuilder<MProfile>(
                  future: futureProfile,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                top: 80, left: 45, right: 45),
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
                                          Text('Username'),
                                          Text(snapshot.data!.username)
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Nama Pegawai'),
                                          Text(snapshot.data!.namaPegawai)
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('NIP'),
                                          Text(snapshot.data!.nip)
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Bagian '),
                                          Text(snapshot.data!.bagian)
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Lokasi Kerja'),
                                          Text(
                                              '${snapshot.data!.latitude},${snapshot.data!.longitude}'),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Atasan'),
                                          Text(snapshot.data!.atasan),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      );
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
            ),
            SizedBox(
              height: 20,
            ),
            AnimatedButton(
                shadowDegree: ShadowDegree.light,
                color: Colors.red,
                onPressed: () {
                  signOut();
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.input,
                      size: 40,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Logout",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )),
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
