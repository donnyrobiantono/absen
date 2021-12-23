import 'dart:convert';

import 'package:absensi/awalan.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? username, password, perangkat;
  final _key = new GlobalKey<FormState>();
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      register();
    }
  }

  //TextEditingController username = TextEditingController();
  //TextEditingController password = TextEditingController();
  //TextEditingController perangkat = TextEditingController();
  String? id;
  register() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    setState(() {
      id = androidDeviceInfo.id;
    });
    var url = Uri.parse('https://cobadonny.uptbali.com/register.php');
    var response = await http.post(url,
        body: {"username": username, "password": password, "perangkat": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        final snackBar = SnackBar(content: Text(pesan));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Awalan()));
      });
    }
  }

  String deviceId = "";

  // script untuk mendapatkan unique device ID
  Future _getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getId().then((id) {
      setState(() {
        deviceId = id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Please Insert Username";
                      }
                    },
                    onSaved: (e) => username = e,
                    decoration: new InputDecoration(
                      hintText: "Username",
                      labelText: "Username",
                      icon: Icon(Icons.people),
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Please Insert Password";
                      }
                    },
                    onSaved: (e) => password = e,
                    obscureText: _secureText,
                    decoration: new InputDecoration(
                      hintText: "Password",
                      labelText: "Password",
                      suffixIcon: IconButton(
                        onPressed: showHide,
                        icon: Icon(
                          _secureText ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                      icon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 200,
                    height: 45,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xffF18265),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        check();
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
