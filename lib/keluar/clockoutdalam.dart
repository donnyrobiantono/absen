import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ClockOutDalam extends StatefulWidget {
  @override
  _ClockOutDalamState createState() => _ClockOutDalamState();
}

class _ClockOutDalamState extends State<ClockOutDalam> {
  TextEditingController kegiatan = new TextEditingController();
  //lostdatacamera

  var hari = '';
  void startHari() {
    var day = new DateTime.now();
    var formatedHari = new DateFormat.E().format(day);
    if (formatedHari == 'Sun') {
      setState(() {
        formatedHari = 'Minggu';
      });
    } else if (formatedHari == 'Mon') {
      setState(() {
        formatedHari = 'Senin';
      });
    } else if (formatedHari == 'Tue') {
      setState(() {
        formatedHari = 'Selasa';
      });
    } else if (formatedHari == 'Wed') {
      setState(() {
        formatedHari = 'Rabu';
      });
    } else if (formatedHari == 'Thur') {
      setState(() {
        formatedHari = 'Kamis';
      });
    } else if (formatedHari == 'Fri') {
      setState(() {
        formatedHari = 'Jumat';
      });
    } else {
      setState(() {
        formatedHari = 'Sabtu';
      });
    }
    setState(() {
      hari = formatedHari;
    });
  }

  var tanggal = '';
  void starttgl() {
    var tgl = new DateTime.now();
    var formatedtgl = new DateFormat("dd").format(tgl);
    setState(() {
      tanggal = formatedtgl;
    });
  }

  var bulan = '';
  void startbulan() {
    var bln = new DateTime.now();
    var formatedbulan = new DateFormat("M").format(bln);
    setState(() {
      bulan = formatedbulan;
    });
  }

  var tahun = '';
  void startTahun() {
    var thn = new DateTime.now();
    var formatedthn = new DateFormat.y().format(thn);
    setState(() {
      tahun = formatedthn;
    });
  }

  var jam = '';
  void startJam() {
    Timer.periodic(new Duration(seconds: 1), (_) {
      var jm = new DateTime.now();
      var formatedjam = new DateFormat.Hms().format(jm);
      setState(() {
        jam = formatedjam;
      });
    });
  }

  @override
  void initState() {
    startHari();
    starttgl();
    startbulan();
    startTahun();
    startJam();
    // TODO: implement initState
    super.initState();
  }

  var value1, value2, value3, longlat, haric;
  Future masuk() async {
    //NIP
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value1 = preferences.getString('nip');
      value2 = preferences.getString('atasan');
      value3 = preferences.getString('bagian');
    });
    //lokasi
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      longlat =
          position.latitude.toString() + "," + position.longitude.toString();
    });
    //hari
    var day = new DateTime.now();
    var formatedHari = new DateFormat.E().format(day);
    if (formatedHari == 'Sun') {
      setState(() {
        formatedHari = 'Minggu';
      });
    } else if (formatedHari == 'Mon') {
      setState(() {
        formatedHari = 'Senin';
      });
    } else if (formatedHari == 'Tue') {
      setState(() {
        formatedHari = 'Selasa';
      });
    } else if (formatedHari == 'Wed') {
      setState(() {
        formatedHari = 'Rabu';
      });
    } else if (formatedHari == 'Thur') {
      setState(() {
        formatedHari = 'Kamis';
      });
    } else if (formatedHari == 'Fri') {
      setState(() {
        formatedHari = 'Jumat';
      });
    } else {
      setState(() {
        formatedHari = 'Sabtu';
      });
    }
    setState(() {
      haric = formatedHari;
    });
    //tanggal
    var tgl = new DateTime.now();
    var formatedtgl = new DateFormat("dd").format(tgl);
    setState(() {
      tanggal = formatedtgl;
    });
    //bulan
    var bln = new DateTime.now();
    var formatedbulan = new DateFormat("M").format(bln);
    setState(() {
      bulan = formatedbulan;
    });
    //tahun
    var thn = new DateTime.now();
    var formatedthn = new DateFormat.y().format(thn);
    setState(() {
      tahun = formatedthn;
    });

    //jam
    Timer.periodic(new Duration(seconds: 1), (_) {
      var jm = new DateTime.now();
      var formatedjam = new DateFormat.Hms().format(jm);
      setState(() {
        jam = formatedjam;
      });
    });

    var url = Uri.parse('https://cobadonny.uptbali.com/clockoutdalam.php?nip=' +
        value1 +
        '&atasan=' +
        value2 +
        '&bagian=' +
        value3);
    var response = await http.post(url, body: {
      "lokasi": longlat,
      "hari": haric,
      "tanggal": tanggal,
      "bulan": bulan,
      "tahun": tahun,
      "jam": jam,
    });
    final data = jsonDecode(response.body);
    String pesan = data['message'];
    if (pesan == 'Berhasil Absen') {
      final snackBar = SnackBar(content: Text(pesan));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(
          context, MaterialPageRoute(builder: (context) => ClockOutDalam()));
      print("Image Upload");
    } else {
      final snackBar = SnackBar(content: Text(pesan));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(
          context, MaterialPageRoute(builder: (context) => ClockOutDalam()));
      print("Image Gagal Upload");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 130,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: CustomShape(),
          child: Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            color: Colors.red,
            child: Center(
                child: Text(
              "Clock Out",
              style: TextStyle(fontSize: 20, color: Colors.white),
            )),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$hari / $tanggal - $bulan - $tahun',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$jam',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Anda Sedang Berada Di Lingkungan Lokasi Kerja',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text('Silahkan Clock Out',
                        style: TextStyle(
                          fontSize: 15,
                        )),
                    SizedBox(
                      height: 4,
                    ),
                    Text('dan',
                        style: TextStyle(
                          fontSize: 15,
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    Text('Selamat Beristirahat',
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(height: 10),
                    InkWell(
                        onTap: () {
                          masuk();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.upload,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Clock Out',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ))),
                  ],
                ),
              )
            ],
          ),
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
