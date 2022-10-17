import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:quizmaker/services/database.dart';
import 'package:quizmaker/views/home.dart';
import 'package:quizmaker/views/quiz_response_list.dart';
import 'package:quizmaker/views/side_bar.dart';
import 'package:quizmaker/widget/widget.dart';

class AllQuizList extends StatefulWidget {
  final String email;

  const AllQuizList({required this.email});

  @override
  State<AllQuizList> createState() => _AllQuizListState();
}

class _AllQuizListState extends State<AllQuizList> {
  Stream? allQuizList;
  DatabaseService databaseService = DatabaseService(uid: "");

  @override
  void initState() {
    databaseService.getQuizListForFaculty(widget.email).then((value) {
      setState(() {
        allQuizList = value;
      });
    });
    super.initState();
  }

  Widget quizList() {
    return Container(
      child: Column(
        children: [
          StreamBuilder(
            stream: allQuizList,
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
                        return QuizAttemptTile(
                          creationDate: data['creationDate'],
                          dueDate: data['due'],
                          imgUrl: data['quizImgUrl'],
                          quizDesc: data['quizDesc'],
                          quizTitle: data['quizTitle'],
                          semester: data['semester'],
                          quizId: id,
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
      body: quizList(),
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

class QuizAttemptTile extends StatelessWidget {
  final String creationDate, dueDate, quizTitle, quizDesc, imgUrl, semester, quizId;

  const QuizAttemptTile(
      {required this.creationDate, required this.dueDate, required this.quizTitle, required this.quizDesc, required this.imgUrl, required this.semester, required this.quizId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: DateTime.now().compareTo(DateTime.parse(dueDate)) > 0 ? Icon(Icons.pending_actions) : Icon(Icons.done),
            title: Text(quizTitle),
            subtitle: Row(
              children: [
                Icon(Icons.notes),
                Text("  $quizDesc"),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              
              TextButton(
                child: Text(
                  "View Responses",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => QuizResponseList(quizTitle: quizTitle)));
                },
              ),
              SizedBox(
                width: 10,
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

