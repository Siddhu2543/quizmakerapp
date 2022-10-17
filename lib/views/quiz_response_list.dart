import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:quizmaker/services/database.dart';
import 'package:quizmaker/views/home.dart';
import 'package:quizmaker/views/side_bar.dart';
import 'package:quizmaker/widget/widget.dart';

class QuizResponseList extends StatefulWidget {
  final String quizTitle;

  const QuizResponseList({required this.quizTitle});

  @override
  State<QuizResponseList> createState() => _QuizResponseList();
}

class _QuizResponseList extends State<QuizResponseList> {
  Stream? allResponseList;
  DatabaseService databaseService = DatabaseService(uid: "");

  @override
  void initState() {
    databaseService.getResponseListForFaculty(widget.quizTitle).then((value) {
      setState(() {
        allResponseList = value;
      });
    });
    super.initState();
  }

  Widget responseList() {
    return Container(
      child: Column(
        children: [
          StreamBuilder(
            stream: allResponseList,
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
                        // final id = docs[index].id;
                        return QuizResponseTile(
                          attemptDate: data['attemptDate'],
                          attempted: "${data['attempted']}",
                          correct: "${data['correct']}",
                          email: data['stdEmail'],
                          rollNo: data['rollNo'],
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

class QuizResponseTile extends StatelessWidget {
  final String attemptDate, rollNo, email;
  final String total, attempted, correct, wrong;

  const QuizResponseTile(
      {required this.attemptDate,
      required this.total,
      required this.attempted,
      required this.correct,
      required this.wrong,
      required this.rollNo,
      required this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.done),
            title: Text(rollNo),
            subtitle: Row(
              children: [
                Icon(Icons.email),
                Text("  $email"),
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

