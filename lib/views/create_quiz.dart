import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quizmaker/helper/constants.dart';
import 'package:quizmaker/services/database.dart';
import 'package:quizmaker/views/add_question.dart';
import 'package:quizmaker/widget/widget.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  DatabaseService databaseService = new DatabaseService(uid: '');
  final _formKey = GlobalKey<FormState>();

  String quizImgUrl = "", quizTitle = "", quizDesc = "", semester = "", due = "";
  String branch = "", maker = "";
  TextEditingController datecontroller = TextEditingController();

  @override
  void initState() {
    Constants.getUserDetailsSharedPreference().then((value) {
      branch = value[5];
      maker = value[1];
    },);
    super.initState();
  }

  bool isLoading = false;
  String quizId = "";

  createQuiz() {
    quizId = randomAlphaNumeric(16);
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, String> quizData = {
        "quizImgUrl": quizImgUrl,
        "quizTitle": quizTitle,
        "quizDesc": quizDesc,
        "due": due,
        "creationDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "branch": branch,
        "maker": maker,
        "semester": semester
      };

      databaseService.addQuizData(quizData, quizId).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AddQuestion(quizId)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black54,
        ),
        title: AppLogo(),
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //brightness: Brightness.li,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TextFormField(
                validator: (val) =>
                    val!.isEmpty ? "Enter Quiz Image Url" : null,
                decoration:
                    InputDecoration(hintText: "Quiz Image Url (Optional)"),
                onChanged: (val) {
                  quizImgUrl = val;
                },
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter Quiz Title" : null,
                decoration: InputDecoration(hintText: "Quiz Title"),
                onChanged: (val) {
                  quizTitle = val;
                },
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                validator: (val) =>
                    val!.isEmpty ? "Enter Quiz Description" : null,
                decoration: InputDecoration(hintText: "Quiz Description"),
                onChanged: (val) {
                  quizDesc = val;
                },
              ),
              DropdownButtonFormField(
                  decoration: InputDecoration(
                    hintText: "Semester",
                  ),
                  validator: (val) {
                    return val == null ? "Selec a Semester" : null;
                  },
                  items: <String>["1", "2", "3", "4", "5", "6", "7", "8"]
                      .map<DropdownMenuItem<String>>((String e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (val) {
                    semester = val as String;
                  }),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                            controller: datecontroller,
                            decoration: InputDecoration(
                              hintText: due == "" ? "Due Date" : due,
                            ),
                            readOnly: true,
                            validator: (value) {
                              if (due == "") return "Enter a Due Date";
                              return null;
                            },
                            onTap: () async {
                              DateTime? pickDob = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2050));

                              if (pickDob != null) {
                                due = DateFormat('yyyy-MM-dd').format(pickDob);
                                datecontroller.text = due;
                              }
                            },
                          ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  createQuiz();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Create Quiz",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
