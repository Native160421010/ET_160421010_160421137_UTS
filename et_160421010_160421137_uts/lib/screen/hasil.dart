// ignore: file_names
import 'package:et_160421010_160421137_uts/screen/gameScreen.dart';
import 'package:et_160421010_160421137_uts/screen/highScore.dart';
import 'package:et_160421010_160421137_uts/main.dart';
import 'package:flutter/material.dart';

class Hasil extends StatelessWidget {
  final int score;
  const Hasil(this.score, {super.key});

  @override
  Widget build(BuildContext context) {
    String title = "";
    if (score == 500) {
      title = "Maestro dell'Indovinello \n(Master of Riddles)";
    } else if (score == 400) {
      title = "Esperto dell'Indovinello \n(Expert of Riddles)";
    } else if (score == 300) {
      title = "Abile Indovinatore (Skillful Guesser)";
    } else if (score == 200) {
      title = "Principiante dell'Indovinello \n(Riddle Beginner)";
    } else if (score == 100) {
      title = "Neofita dell'Indovinello \n(Riddle Novice)";
    } else {
      title = "Sfortunato Indovinatore \n(Unlucky Guesser)";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("CONGRATULATIONS! Your score is...",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
            Text(
              (score).toString(),
              style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            ),
            Text(("You are a $title!"),
                style:
                    const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center),
            const Divider(
              height: 32,
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
                    Text("Play Again"),
                  ],
                ),
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
                  MaterialPageRoute(builder: (context) => const HighScore()),
                );
              },
              child: const SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_chart_sharp),
                    SizedBox(width: 8),
                    Text("High Score"),
                  ],
                ),
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
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
              child: const SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home),
                    SizedBox(width: 8),
                    Text("Main Menu"),
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
