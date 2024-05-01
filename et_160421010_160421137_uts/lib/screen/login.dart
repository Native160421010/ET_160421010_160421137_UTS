import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:et_160421010_160421137_uts/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MEMORIMAGE - Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginForm> {
  // Var menyimpan username sebelum simpan ke Shared Pref
  String username = "";

  // Var dummy untuk mengecek apakah pass kosong
  String pass = "";

  // Method u/ menyimpan username ke Shared Pref
  void doLogin() async {
    //later, we use web service here to check the user id and password
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("username", username);
    main();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('MEMORIMAGE - LOGIN '),
        ),
        body: Container(
          height: 300,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              border: Border.all(width: 1),
              color: Colors.white,
              boxShadow: const [BoxShadow(blurRadius: 20)]),
          child: Column(children: [

            // Text input Email
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter a valid username'),
                onChanged: (v) {
                  username = v;
                },
              ),
            ),

            // Text input Password
            Padding(
              padding: const EdgeInsets.all(10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
                onChanged: (v) {
                  pass = v;
                },
              ),
            ),

            // Button Login
            Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    onPressed: () {
                      if (username.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Username cannot be empty!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                      else if (pass.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Password cannot be empty!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        doLogin();
                      }
                    },
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(color: Colors.deepPurple, fontSize: 25),
                    ),
                  ),
                )),
          ]),
        ));
  }
}
