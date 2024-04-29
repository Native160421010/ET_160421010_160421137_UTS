// ================================ JIKA GAMBAR TIDAK BERJALAN ===========================================
// flutter run -d chrome --web-renderer html

import 'package:et_160421010_160421137_uts/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ================================ VAR SHARED PREFS (u/ Login dan Score) ===========================================
String username = "";

// Func ambil username
Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String username = prefs.getString("username") ?? '';
  return username;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '') {
      runApp(const Login());
    } else {
      username = result;
      runApp(const MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MEMORIMAGE',
      routes: {
        'login': (context) => const Login(),
        //'highScore': (context) => const highScore(), to be added
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MEMORIMAGE Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Method u/ menghapus username di Shared Pref
  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    main();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      // Buat lihat Username dan Logout
      drawer: Drawer(
        elevation: 16.0,
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
                accountName: Text(username),
                accountEmail: const Text("xyz@gmail.com"),
                currentAccountPicture: const CircleAvatar(
                    backgroundImage:
                        NetworkImage("https://i.pravatar.cc/150"))),
            ListTile(
              title: Text(username != "" ? "LOGOUT" : "LOGIN"),
              leading: const Icon(Icons.login),
              onTap: () {
                username != ""
                    ? doLogout()
                    : Navigator.pushNamed(context, "login");
              },
            ),
            ListTile(
              title: const Text("HIGH SCORE"),
              leading: const Icon(Icons.score),
              onTap: () {
                // Navigator.pushNamed(context, "login"); to be added
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to MEMORIMAGE!',
            ),
          ],
        ),
      ),
    );
  }
}
