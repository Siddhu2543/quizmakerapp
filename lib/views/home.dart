// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:quizmaker/helper/constants.dart';
import 'package:quizmaker/services/database.dart';
import 'package:quizmaker/views/create_quiz.dart';
import 'package:quizmaker/views/quiz_play.dart';
import 'package:quizmaker/views/quiz_response_list.dart';
import 'package:quizmaker/views/side_bar.dart';
import 'package:quizmaker/widget/widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? quizStream;
  String role = "";
  String email = "", rollNo = "";
  DatabaseService databaseService = new DatabaseService(uid: '');

  Widget quizList() {
    return Container(
      child: Column(
        children: [
          StreamBuilder(
            stream: quizStream,
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
                        return QuizTile(
                          role: role,
                          noOfQuestions: snapshot.data!.docs.length,
                          imageUrl: "${data['quizImgUrl']}",
                          title: "${data['quizTitle']}",
                          description: "${data['quizDesc']}",
                          id: "$id",
                          email: email,
                          rollNo: rollNo,
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
    Constants.getUserDetailsSharedPreference().then(
      (value) {
        role = value[3];
        email = value[1];
        rollNo = value[7];
        if (value[3] == "Faculty") {
          databaseService.getQuizDataByFaculty().then((value) {
            setState(() {
              quizStream = value;
            });
          });
        } else {
          databaseService.getQuizDataByStudent().then((value) {
            setState(() {
              quizStream = value;
            });
          });
        }
      },
    );
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
      body: quizList(),
      floatingActionButton: role == "Faculty" ? FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateQuiz()));
        },
      ) : Container(),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String imageUrl, title, id, description;
  final int noOfQuestions;
  final String role;

  final String email, rollNo;
  QuizTile(
      {required this.role,
      required this.title,
      required this.imageUrl,
      required this.description,
      required this.id,
      required this.noOfQuestions,
      required this.email,
      required this.rollNo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => role == "Faculty" ? QuizResponseList(
                      quizTitle: title,
                    ) : QuizPlay(quizId: id, email: email, quizTitle: title, rollNo: rollNo,)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 24),
        height: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width - 48,
              ),
              Container(
                color: Colors.black26,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        description,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
