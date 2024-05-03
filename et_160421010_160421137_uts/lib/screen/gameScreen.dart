// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:et_160421010_160421137_uts/class/questionBank.dart';
import 'package:et_160421010_160421137_uts/screen/hasil.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});
  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  String cur_user = "";
  int _point = 0;
  bool gameStart = true; // Atur visibility

  late Timer _timer;
  final int _init_value = 10; // Nilai default timer
  int _timeRemaining = 10; // Nilai timer yang akan berkurang terus
  int addPoint = 100; // Tambahan poin jika benar (malas masuk ke method lol)

  int _question_no = 0; // anda tahu ini apa
  List<List<String>> listScore = [];
  final List<QuestionObj> _questions = [];

  @override
  void initState() {
    super.initState();
    _point = 0;
    startTimer();

    _questions.addAll([
      QuestionObj(
        "assets/images/image1.jpeg",
        "assets/images/image5.jpeg",
        "assets/images/image6.jpeg",
        "assets/images/image7.jpeg",
        "assets/images/image1.jpeg",
      ),
      QuestionObj(
        "assets/images/image2.jpeg",
        "assets/images/image5.jpeg",
        "assets/images/image6.jpeg",
        "assets/images/image7.jpeg",
        "assets/images/image2.jpeg",
      ),
      QuestionObj(
        "assets/images/image3.jpeg",
        "assets/images/image5.jpeg",
        "assets/images/image6.jpeg",
        "assets/images/image7.jpeg",
        "assets/images/image3.jpeg",
      ),
      QuestionObj(
        "assets/images/image4.jpeg",
        "assets/images/image5.jpeg",
        "assets/images/image6.jpeg",
        "assets/images/image7.jpeg",
        "assets/images/image4.jpeg",
      ),
      QuestionObj(
        "assets/images/image5.jpeg",
        "assets/images/image1.jpeg",
        "assets/images/image6.jpeg",
        "assets/images/image7.jpeg",
        "assets/images/image5.jpeg",
      ),
    ]);

    _questions.shuffle();
  }

  String formatTime(int hitung) {
    var hours = (hitung ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((hitung % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (hitung % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
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
        _point += addPoint;
        Fluttertoast.showToast(
                            msg: "CORRECT!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
                            msg: "WRONG!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);

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

    // Preferensi
    final prefs = await SharedPreferences.getInstance();
    List<String>? stringList = prefs.getStringList("ListScore");
    List<List<String>> ListScore =
        stringList?.map((list) => list.split(',')).toList() ?? [];

    // Ambil username
    String username = prefs.getString("username") ?? '';

    // Bandingkan score terlebih dahulu
    for (int i = 0; i < ListScore.length; i++) {
      int pointCompare = int.parse(ListScore[i][1]);

      if (_point >= pointCompare) {
        ListScore.insert(
            i, [username, _point.toString(), "assets/images/Baaaaa.jpeg"]);
        break;
      }
    }

    await Future.delayed(const Duration(milliseconds: 10));
    List<String> updatedStringList =
        ListScore.map((list) => list.join(',')).toList();
    await prefs.setStringList("ListScore", updatedStringList);

    dispose();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Hasil(_point)),
    );
  }

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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ).animate().fade(duration: 500.ms).scale(delay: 500.ms),
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
                          autoPlayInterval: const Duration(seconds: 2),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
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
                        ).animate().shake(),
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
                        ).animate().shake(),
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
                        ).animate().shake(),
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
                        ).animate().shake(),
                      ],
                    ),
                  ])),
            ]),
          ),
        ));
  }
}
