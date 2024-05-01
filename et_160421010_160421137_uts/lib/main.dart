// ================================ JIKA GAMBAR TIDAK BERJALAN ===========================================
// flutter run -d chrome --web-renderer html

// ignore_for_file: non_constant_identifier_names
import 'package:et_160421010_160421137_uts/screen/gameScreen.dart';
import 'package:et_160421010_160421137_uts/screen/hasil.dart';
import 'package:et_160421010_160421137_uts/screen/highScore.dart';
import 'package:et_160421010_160421137_uts/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ================================ VAR SHARED PREFS (u/ Login dan Score) ===========================================
String username = "";

// Method ambil username dari Shared Pref
Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String username = prefs.getString("username") ?? '';
  return username;
}

// Method u/ menghapus username di Shared Pref
void doLogout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("username");
  main();
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
  initializeHighScores();
}

// Method to ensure high scores are initialized
void initializeHighScores() async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? stringList = prefs.getStringList("ListScore");
  if (stringList == null || stringList.isEmpty) {
    // Data dummy jika tidak ada pada HS
    List<String> ListDummy = [
      "Garth Ranzz, 1000, https://imgur.com/fCbeYDm.jpeg",
      "String A, 750, https://imgur.com/fCbeYDm.jpeg",
      "123456789012345, 500, https://imgur.com/fCbeYDm.jpeg"
    ];
    prefs.setStringList("ListScore", ListDummy);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MEMORIMAGE - Home',
      routes: {
        'login': (context) => const Login(),
        'hasil': (context) => const Hasil(500),
        'highScore': (context) => const HighScore(),
        'game': (context) => const Quiz(),
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
              title: const Text("Game"),
              leading: const Icon(Icons.gamepad),
              onTap: () {
                Navigator.pushNamed(context, "game");
              },
            ),
            ListTile(
              title: const Text("High Score"),
              leading: const Icon(Icons.add_chart_sharp),
              onTap: () {
                Navigator.pushNamed(context, "highScore");
              },
            ),
            ListTile(
              title: const Text("Hasil"),
              leading: const Icon(Icons.thumb_up_sharp),
              onTap: () {
                Navigator.pushNamed(context, "hasil");
              },
            ),
            ListTile(
              title: Text(username != "" ? "Logout" : "Login"),
              leading: const Icon(Icons.login),
              onTap: () {
                username != ""
                    ? doLogout()
                    : Navigator.pushNamed(context, "login");
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
