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
      "Mike, 300, assets/images/Mike.jpg",
      "String A, 200, assets/images/Jonathan.jpg",
      "123456789012345, 100, assets/images/Fish.jpeg"
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
        // 'hasil': (context) => const Hasil(500),
        'highScore': (context) => const HighScore(),
        'game': (context) => const Quiz(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'HOME'),
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
                        AssetImage("assets/images/Baaaaa.jpeg"))),
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
            // ListTile(
            //   title: const Text("Hasil"),
            //   leading: const Icon(Icons.thumb_up_sharp),
            //   onTap: () {
            //     Navigator.pushNamed(context, "hasil");
            //   },
            // ),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to MEMORIMAGE!',
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              child: const Text(
                'Cara Bermain:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: const Text(
                '1. Sistem akan menampilkan 5 gambar secara acak selama 3 detik. Ingatlah gambar-gambar tersebut.',
                style: TextStyle(fontSize: 10),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: const Text(
                '2. Setelah itu, sistem akan menampilkan 4 opsi gambar, di mana salah satunya adalah gambar yang harus diingat oleh pemain, dan 3 lainnya adalah gambar pengecoh yang mirip.',
                style: TextStyle(fontSize: 10),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                '3. Pengguna memiliki waktu 30 detik untuk memilih gambar yang benar.',
                style: TextStyle(fontSize: 10),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: const Text(
                '4. Jika waktu habis, pertanyaan tersebut akan dilewati tanpa mendapatkan poin.',
                style: TextStyle(fontSize: 10),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: const Text(
                '5. Tujuan pemain adalah memilih gambar yang sesuai dengan yang ditampilkan sebelumnya.',
                style: TextStyle(fontSize: 10),
              ),
            ),
            const Divider(
              height: 16,
              color: Colors.transparent,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Quiz()),
                );
              },
              child: const SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.gamepad),
                    SizedBox(width: 8),
                    Text("Play Game"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
