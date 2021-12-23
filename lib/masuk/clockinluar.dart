import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Clockin extends StatefulWidget {
  const Clockin({Key? key}) : super(key: key);
  @override
  _ClockinState createState() => _ClockinState();
}

class _ClockinState extends State<Clockin> {
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
    } else if (formatedHari == 'Sat') {
      setState(() {
        formatedHari = 'Sabtu';
      });
    } else if (formatedHari == 'Fri') {
      setState(() {
        formatedHari = 'Jumat';
      });
    } else {
      setState(() {
        formatedHari = 'Kamis';
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

  XFile? image;

  final ImagePicker _picker = ImagePicker();

  void getImage() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    print(photo!.path);
    setState(() {
      image = photo;
    });
  }

  var value1, value2, value3, longlat, haric;
  Future masukluar() async {
    //NIP&atasan
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
    } else if (formatedHari == 'Sat') {
      setState(() {
        formatedHari = 'Sabtu';
      });
    } else if (formatedHari == 'Fri') {
      setState(() {
        formatedHari = 'Jumat';
      });
    } else {
      setState(() {
        formatedHari = 'Kamis';
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

    var uri = Uri.parse('https://cobadonny.uptbali.com/clockin.php?nip=' +
        value1 +
        '&atasan=' +
        value2 +
        '&bagian=' +
        value3);
    var request = new http.MultipartRequest("POST", uri);
    //request.fields['nip'] = "9817072TCY";
    request.fields['lokasi'] = longlat;
    request.fields['hari'] = haric;
    request.fields['tanggal'] = tanggal;
    request.fields['bulan'] = bulan;
    request.fields['tahun'] = tahun;
    request.fields['jam'] = jam;
    request.fields['keterangan'] = kegiatan.text;
    request.fields['evidence'] = image!.name;
    var multipartFile = await http.MultipartFile.fromPath("image", image!.path);

    request.files.add(multipartFile);

    var response = await request.send();
    if (response.statusCode == 200) {
      final snackBar = SnackBar(content: Text("Berhasil"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(
          context, MaterialPageRoute(builder: (context) => Clockin()));
      print("Image Upload");
    } else {
      print("Image Gagal Upload");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            color: Colors.green,
            child: Center(
                child: Text(
              "Clock In",
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
                      '$hari / $tanggal - $bulan $tahun',
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
                      'Anda Sedang Tidak Berada Di Lingkungan Kerja',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Apa Kegiatan Anda?',
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: kegiatan,
                      decoration: new InputDecoration(
                        hintText: "Kegiatan",
                        labelText: "Kegiatan",
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                      ),
                    ),
                    SizedBox(height: 10),
                    image == null
                        ? Text("No Image Selected")
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0)),
                            child: Image.file(
                              File(image!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                    SizedBox(height: 10),
                    Container(
                      child: InkWell(
                          onTap: () {
                            getImage();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              height: 50,
                              width: 100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.camera,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Eviden',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ))),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                        onTap: () {
                          masukluar();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
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
                                        Icons.download,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Clock In',
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
