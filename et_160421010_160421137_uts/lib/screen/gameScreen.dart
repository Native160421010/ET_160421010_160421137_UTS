// The following code is designed with android look in mind, please use tab view
// and use flutter run -d chrome --web-renderer html to access the images from the internet.

// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:et_160421010_160421137_uts/class/questionBank.dart';
import 'package:et_160421010_160421137_uts/screen/hasil.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<List<String>> listScore = [];

// Method ambil List Score dari Shared Pref
Future<List<List<String>>> checkScore() async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? stringList = prefs.getStringList("ListScore");
  if (stringList != null) {
    List<List<String>> listScore =
        stringList.map((string) => string.split(',')).toList();
    return listScore;
  } else {
    return [];
  }
}

String formatTime(int hitung) {
  var hours = (hitung ~/ 3600).toString().padLeft(2, '0');
  var minutes = ((hitung % 3600) ~/ 60).toString().padLeft(2, '0');
  var seconds = (hitung % 60).toString().padLeft(2, '0');
  return "$hours:$minutes:$seconds";
}

String cur_user = "";
int _point = 0;
bool gameStart = true;

class Quiz extends StatefulWidget {
  const Quiz({super.key});
  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  late Timer _timer;
  final int _init_value = 5; // nilai default timer
  int _timeRemaining = 5; // nilai timer yang akan berkurang terus

  int _question_no = 0; // anda tahu ini apa
  final List<QuestionObj> _questions = [];

  @override
  void initState() {
    super.initState();
    _point = 0;
    startTimer();

    _questions.addAll([
      QuestionObj(
        "assets/images/image1.jpeg",
        "assets/images/image2.jpeg",
        "assets/images/image3.jpeg",
        "assets/images/image4.jpeg",
        "assets/images/image1.jpeg",
      ),
      QuestionObj(
        "assets/images/image2.jpeg",
        "assets/images/image3.jpeg",
        "assets/images/image4.jpeg",
        "assets/images/image5.jpeg",
        "assets/images/image2.jpeg",
      ),
      QuestionObj(
        "assets/images/image3.jpeg",
        "assets/images/image4.jpeg",
        "assets/images/image5.jpeg",
        "assets/images/image1.jpeg",
        "assets/images/image3.jpeg",
      ),
      QuestionObj(
        "assets/images/image4.jpeg",
        "assets/images/image5.jpeg",
        "assets/images/image1.jpeg",
        "assets/images/image2.jpeg",
        "assets/images/image4.jpeg",
      ),
      QuestionObj(
        "assets/images/image5.jpeg",
        "assets/images/image2.jpeg",
        "assets/images/image3.jpeg",
        "assets/images/image4.jpeg",
        "assets/images/image5.jpeg",
      ),
    ]);

    _questions.shuffle();
  }

  @override
  void dispose() {
    _timer.cancel();
    _timeRemaining = 0;
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      // timer berkurang tiap detik (1000 ms)
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else if (_timeRemaining <= 0 && gameStart == true) {
          _timeRemaining = _init_value;
          gameStart = false;
        } else if (_timeRemaining <= 0 && gameStart == false) {
          finishQuiz();
        }
      });
    });
  }

  void checkAnswer(String answer) {
    setState(() {
      // Jika benar poin bertambah (duh!)
      if (answer == _questions[_question_no].answer) {
        _point += 100;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Correct!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("WRONG!")),
        );
      }
      // Salah tidak salah akan selalu move on
      _question_no++;

      // Jika soal habis maka selesai (Game Over)
      if (_question_no >= _questions.length) {
        finishQuiz();
      }

      // Timer akan selalu reset
      _timeRemaining = _init_value;
    });
  }

  finishQuiz() async {
    // Timer berhenti, soal reset
    _timer.cancel();
    _question_no = 0;
    gameStart = true;

    // // Preferensi
    // final prefs = await SharedPreferences.getInstance();
    // List<String>? stringList = prefs.getStringList("ListScore");
    // List<List<String>> ListScore =
    //     stringList?.map((list) => list.split(',')).toList() ?? [];

    // // Ambil username
    // String username = prefs.getString("username") ?? '';

    // // Bandingkan score terlebih dahulu
    // for (int i = 0; i < ListScore.length; i++) {
    //   int pointCompare = int.parse(ListScore[i][1]);

    //   if (pointCompare > _point) {
    //     ListScore.insert(
    //         i, [username, _point.toString(), "https://imgur.com/fCbeYDm.jpeg"]);
    //   } else {
    //     break;
    //   }
    // }

    // // Logging
    // print('ListScore before update: $ListScore');

    // // Update Shared Pref
    // List<String> updatedStringList =
    //     ListScore.map((list) => list.join(',')).toList();
    // await prefs.setStringList("ListScore", updatedStringList);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Hasil(_point)),
    );
  }

  // void callbackFunction(int index) {
  //   if (index == _questions.length - 1) {
  //     startTimer(1);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('GAME'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: <Widget>[
            const Divider(
              height: 25,
              color: Colors.transparent,
            ),
            LinearPercentIndicator(
              center: Text(formatTime(_timeRemaining)),
              width: MediaQuery.of(context).size.width,
              lineHeight: 20.0,
              percent: 1 - (_timeRemaining / _init_value),
              backgroundColor: Colors.green,
              progressColor: Colors.black,
            ),
            const Divider(
              height: 50,
            ),

            Visibility(
                visible: gameStart,
                child: Column(children: [
                  // MEMPERLIHATKAN YANG BUTUH DIINGAT SATU PER-SATU
                  const Text(
                    "Remember these images, dummy!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    height: 50,
                    color: Colors.transparent,
                  ),
                  CarouselSlider(
                      items: _questions.map((question) {
                        return Builder(
                          builder: (BuildContext context) {
                            return SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.asset(
                                  question.answer,
                                  height: 100,
                                  width: 100,
                                ));
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 120,
                        aspectRatio: 1 / 1,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 1),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        // onPageChanged:
                        //     (int index, CarouselPageChangedReason reason) {
                        //   callbackFunction(index);
                        // },
                      )),
                  const Divider(
                    height: 50,
                    color: Colors.transparent,
                  ),
                ])),

            // Pilihan A B C D
            Visibility(
                visible: !gameStart,
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(125, 150),
                            elevation: 4,
                          ),
                          onPressed: () {
                            checkAnswer(_questions[_question_no].option_a);
                          },
                          child: Image.asset(
                            _questions[_question_no].option_a,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(125, 150),
                            elevation: 4,
                          ),
                          onPressed: () {
                            checkAnswer(_questions[_question_no].option_b);
                          },
                          child: Image.asset(
                            _questions[_question_no].option_b,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(125, 150),
                            elevation: 4,
                          ),
                          onPressed: () {
                            checkAnswer(_questions[_question_no].option_c);
                          },
                          child: Image.asset(
                            _questions[_question_no].option_c,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(125, 150),
                            elevation: 4,
                          ),
                          onPressed: () {
                            checkAnswer(_questions[_question_no].option_d);
                          },
                          child: Image.asset(
                            _questions[_question_no].option_d,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]))
          ]),
        ),
      ),
    );
  }
}
