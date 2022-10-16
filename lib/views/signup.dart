import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizmaker/helper/constants.dart';
import 'package:quizmaker/models/account.dart';
import 'package:quizmaker/services/auth.dart';
import 'package:quizmaker/services/database.dart';
import 'package:quizmaker/views/home.dart';
import 'package:quizmaker/widget/widget.dart';
import 'package:intl/intl.dart';

class SignUp extends StatefulWidget {
  final Function toogleView;
  String errMsg = "";

  SignUp({required this.toogleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthService authService = new AuthService();
  DatabaseService databaseService = new DatabaseService(uid: '');
  final _formKey = GlobalKey<FormState>();

  // text feild
  bool _loading = false;
  String email = '',
      password = '',
      name = "",
      dob = "",
      userId = "",
      branch = "",
      semester = "",
      rollNo = "",
      role = "";

  TextEditingController datecontroller = TextEditingController();

  getInfoAndSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      await authService
          .signUpWithEmailAndPassword(email, password)
          .then((value) {
        if (value == null) {
          setState(() {
            _loading = false;
          });
          widget.errMsg =
              "The email address is already in use by another account. Try with some different Email address.";
          return;
        }
        Map<String, String>? userInfo = null;
        if (role == "Student") {
          userInfo = {
            "userName": name,
            "email": email,
            "dob": dob,
            "role": role,
            "userId": userId,
            "branch": branch,
            "semester": semester,
            "rollNo": rollNo
          };
        } else if (role == "Faculty") {
          userInfo = {
            "userName": name,
            "email": email,
            "dob": dob,
            "role": role,
            "userId": userId,
            "branch": branch
          };
        }

        databaseService.addData(userInfo);
        Account accountDetails = Account(name: name, email: email, dob: dob, role: role, userId: userId, branch: branch, semester: semester, rollNo: rollNo);

        Constants.saveUserLoggedInSharedPreference(true);
        Constants.saveUserDetailsSharedPreference(accountDetails.toList());

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: AppLogo(),
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //brightness: Brightness.li,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: _loading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : ListView(
                children: [
                  if (widget.errMsg != "")
                    Text(widget.errMsg,
                        style: TextStyle(
                            color: Colors.red[500],
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                  // Spacer(),
                  Form(
                    key: _formKey,
                    child: Container(
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (val) =>
                                val!.isEmpty ? "Enter an Name" : null,
                            decoration: InputDecoration(hintText: "Name"),
                            onChanged: (val) {
                              name = val;
                            },
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            validator: (val) => validateEmail(email)
                                ? null
                                : "Enter correct email",
                            decoration: InputDecoration(hintText: "Email"),
                            onChanged: (val) {
                              email = val;
                            },
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            controller: datecontroller,
                            decoration: InputDecoration(
                              hintText: dob == "" ? "Date of Birth" : dob,
                            ),
                            readOnly: true,
                            validator: (value) {
                              if (dob == "") return "Enter Date of Birth";
                              return null;
                            },
                            onTap: () async {
                              DateTime? pickDob = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now());

                              if (pickDob != null) {
                                dob = DateFormat('dd-MM-yyyy').format(pickDob);
                                datecontroller.text = dob;
                              }
                            },
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          DropdownButtonFormField(
                              decoration: InputDecoration(
                                hintText: "Role",
                              ),
                              validator: (val) {
                                return val == null ? "Selec a role" : null;
                              },
                              items: <String>["Student", "Faculty"]
                                  .map<DropdownMenuItem<String>>((String e) {
                                return DropdownMenuItem(
                                    value: e, child: Text(e));
                              }).toList(),
                              onChanged: (val) {
                                role = val as String;
                              }),
                          SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            validator: (val) => val != ""
                                ? null
                                : "Enter the Student/Faculty ID",
                            decoration:
                                InputDecoration(hintText: "Student/Faculty ID"),
                            onChanged: (val) {
                              userId = val;
                            },
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          DropdownButtonFormField(
                              decoration: InputDecoration(
                                hintText: "Branch",
                              ),
                              validator: (val) {
                                return val == null ? "Selec a Branch" : null;
                              },
                              items: <String>[
                                "MH",
                                "CL",
                                "CH",
                                "IC",
                                "IT",
                                "CE",
                                "EC",
                                "FOD",
                                "FOP"
                              ].map<DropdownMenuItem<String>>((String e) {
                                return DropdownMenuItem(
                                    value: e, child: Text(e));
                              }).toList(),
                              onChanged: (val) {
                                branch = val as String;
                              }),
                          SizedBox(
                            height: 6,
                          ),
                          DropdownButtonFormField(
                              decoration: InputDecoration(
                                hintText: "Semester (For Students only)",
                              ),
                              validator: (val) {
                                if (role != "Faculty")
                                  return val == null
                                      ? "Selec a Semester"
                                      : null;
                              },
                              items: <String>[
                                "1",
                                "2",
                                "3",
                                "4",
                                "5",
                                "6",
                                "7",
                                "8"
                              ].map<DropdownMenuItem<String>>((String e) {
                                return DropdownMenuItem(
                                    value: e, child: Text(e));
                              }).toList(),
                              onChanged: (val) {
                                semester = val as String;
                              }),
                          SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            validator: (val) {
                              if (role != "Faculty")
                                return val == ""
                                    ? "Enter a valid Roll Number"
                                    : null;
                            },
                            decoration: InputDecoration(
                                hintText: "Roll Number (For Students only)"),
                            onChanged: (val) {
                              rollNo = val;
                            },
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (val) => val!.length < 6
                                ? "Password must be 6+ characters"
                                : null,
                            decoration: InputDecoration(hintText: "Password"),
                            onChanged: (val) {
                              password = val;
                            },
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          GestureDetector(
                            onTap: () {
                              getInfoAndSignUp();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 20),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have and account? ',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 17)),
                              GestureDetector(
                                onTap: () {
                                  widget.toogleView();
                                },
                                child: Container(
                                  child: Text('Sign In',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          decoration: TextDecoration.underline,
                                          fontSize: 17)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  )
                ],
              ),
      ),
    );
  }
}

bool validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}
