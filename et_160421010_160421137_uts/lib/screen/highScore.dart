// ignore: file_names
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighScore extends StatelessWidget {
  const HighScore({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MEMORIMAGE - High Score',
      theme: ThemeData( scaffoldBackgroundColor: Colors.lightGreenAccent,),
      home: const HighScoreForm(),
    );
  }
}

class HighScoreForm extends StatefulWidget {
  const HighScoreForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HighScoreState();
  }
}

class _HighScoreState extends State<HighScoreForm> {
  @override
  void initState() {
    super.initState();
    getListScore();
  }

  Future<void> getListScore() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? stringList = prefs.getStringList("ListScore");
    if (stringList != null) {
      setState(() {
        ListScore = stringList.map((list) => list.split(',')).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(child: Text('HIGH SCORE')),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: DisplayScore(),
        ),
      ])),
    );
  }
}

// ignore: non_constant_identifier_names
List<List<String>> ListScore = [];

// ignore: non_constant_identifier_names
List<Widget> DisplayScore() {
  List<Widget> temp = [];
  int i = 0;
  while (i < ListScore.length) {
    Widget w = Container(
      height: 92,
      margin: const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        border: Border.all(width: 1),
        color: Colors.white,
        //boxShadow: const [BoxShadow(blurRadius: 20)]
      ),
      child: Column(
        children: [
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center, // tinggi
            children: [

              // ============================ RANK ============================ 
              Container(
                padding: const EdgeInsets.only(right: 15),
                child: Text(
                  (i + 1).toString(),
                  style: const TextStyle(fontSize: 20, fontFamily: 'Britannic'),
                ),
              ),
              
              // ============================ PROFIL ============================ 
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(ListScore[i][2]),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ),
              
              // ============================ NAMA ============================ 
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    ListScore[i][0].toUpperCase(),
                    style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // ============================ POINTS ============================ 
              Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  ListScore[i][1],
                  style: const TextStyle(fontSize: 20, fontFamily: 'Britannic'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    temp.add(w);
    i++;
  }
  return temp;
}
