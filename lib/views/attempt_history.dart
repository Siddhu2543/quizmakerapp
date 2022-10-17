import 'package:flutter/material.dart';
import 'package:quizmaker/helper/constants.dart';
import 'package:quizmaker/services/database.dart';
import 'package:quizmaker/views/create_quiz.dart';
import 'package:quizmaker/views/home.dart';
import 'package:quizmaker/views/quiz_play.dart';
import 'package:quizmaker/views/side_bar.dart';
import 'package:quizmaker/widget/widget.dart';

class AttemptHistory extends StatefulWidget {
  final String email;
  const AttemptHistory({required this.email});

  @override
  State<AttemptHistory> createState() => _AttemptHistoryState();
}

class _AttemptHistoryState extends State<AttemptHistory> {
  Stream? attempHistory;
  DatabaseService databaseService = DatabaseService(uid: "");

  Widget responseList() {
    return Container(
      child: Column(
        children: [
          StreamBuilder(
            stream: attempHistory,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.hasData == false
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var docs = snapshot.data.docs;
                        final data = docs[index].data();
                        final id = docs[index].id;
                        return AttemptTile(
                          attemptDate: "${data['attemptDate']}",
                          quizId: "${data['quizId']}",
                          quizTitle: "${data['quizTitle']}",
                          imgUrl: "${data['imgUrl']}",
                          attempted: "${data['attempted']}",
                          correct: "${data['correct']}",
                          total: "${data['total']}",
                          wrong: "${data['attempted'] - data['correct']}",
                        );
                      });
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    databaseService.getResponseData(widget.email).then((value) {
      setState(() {
        attempHistory = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        centerTitle: true,
        title: AppLogo(),
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.blue),
        //brightness: Brightness.li,
      ),
      body: responseList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.home),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        },
      ),
    );
  }
}

class AttemptTile extends StatelessWidget {
  final String attemptDate, quizId, quizTitle, imgUrl;
  final String total, attempted, correct, wrong;

  const AttemptTile(
      {required this.attemptDate,
      required this.quizId,
      required this.quizTitle,
      required this.imgUrl,
      required this.total,
      required this.attempted,
      required this.correct,
      required this.wrong});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.done),
            title: Text(quizTitle),
            subtitle: Row(
              children: [
                Icon(Icons.calendar_month),
                Text("  $attemptDate"),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const SizedBox(width: 8),
              TextButton(
                child: Text(
                  "Total $total",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
              TextButton(
                child: Text(
                  "Attempted $attempted",
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
              TextButton(
                child: Text(
                  "Correct $correct",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
              TextButton(
                child: Text(
                  "Wrong $wrong",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () {/* ... */},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
