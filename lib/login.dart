import 'dart:convert';
import 'package:absensi/account/profile.dart';
import 'package:absensi/home.dart';
import 'package:absensi/notification/notification.dart';
import 'package:absensi/register.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:animated_button/animated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String? username, password;
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
      login();
    }
  }

  String? id;
  login() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    setState(() {
      id = androidDeviceInfo.id;
    });
    var url = Uri.parse('https://cobadonny.uptbali.com/login.php');
    var response = await http.post(url,
        body: {"username": username, "password": password, "perangkat": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String nip = data['nip'];
    String nama = data['nama_pegawai'];
    String atasan = data['atasan'];
    String lat = data['latitude'];
    String long = data['longitude'];
    String level = data['level'];
    String bagian = data['bagian'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, nip, nama, atasan, lat, long, level, bagian);
      });
      print(pesan);
    } else {
      print(pesan);
    }
  }

  savePref(int value, String nip, String nama, String atasan, String lat,
      String long, String level, String bagian) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("nip", nip);
      preferences.setString("nama", nama);
      preferences.setString("atasan", atasan);
      preferences.setString("lat", lat);
      preferences.setString("long", long);
      preferences.setString("level", level);
      preferences.setString("bagian", bagian);
      // ignore: deprecated_member_use
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);

      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 130,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            flexibleSpace: ClipPath(
              clipper: CustomClipPath(),
              child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                color: Colors.blue,
                child: Center(
                    child: Text(
                  "Silahkan Login",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
              ),
            ),
          ),
          body: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                      key: _key,
                      child: Container(
                        padding: EdgeInsets.all(20),
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
                                    borderRadius:
                                        new BorderRadius.circular(5.0)),
                              ),
                            ),
                            SizedBox(height: 10),
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
                                    _secureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                                icon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0)),
                              ),
                            ),
                            SizedBox(height: 20),
                            AnimatedButton(
                                shadowDegree: ShadowDegree.light,
                                color: Colors.blue,
                                onPressed: () {
                                  check();
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
                                    Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ))
                ],
              ),
            ],
          ),
        );
        break;
      case LoginStatus.signIn:
        return MainMenu(signOut);
        break;
    }
  }
}

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[HomeState(), NotifHome(), Profile()],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(title: Text('Home'), icon: Icon(Icons.home)),
          BottomNavyBarItem(
              title: Text('Notification'), icon: Icon(Icons.notifications)),
          BottomNavyBarItem(title: Text('Account'), icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.arcToPoint(Offset(size.width, size.height),
        radius: Radius.elliptical(30, 10));
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
