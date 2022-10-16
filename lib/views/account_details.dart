import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quizmaker/helper/constants.dart';
import 'package:quizmaker/models/account.dart';
import 'package:quizmaker/services/auth.dart';
import 'package:quizmaker/services/database.dart';
import 'package:quizmaker/views/side_bar.dart';
import 'package:quizmaker/widget/widget.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({Key? key}) : super(key: key);

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  List<String> userDetails = List<String>.filled(8, "");
  AuthService _authService = AuthService();
  DatabaseService databaseService = DatabaseService(uid: "");
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String name = "", dob = "", semester = "", rollNo = "";
  TextEditingController datecontroller = TextEditingController();

  updateDetails() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      await databaseService.updateDetails(
          email: userDetails[1],
          name: name,
          dob: dob,
          semester: semester,
          rollNo: rollNo);
      Account account = await Account.getAccountFromEmail(userDetails[1]);
      Constants.saveUserDetailsSharedPreference(account.toList());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (builder) => AccountDetails()));
    }
  }

  @override
  void initState() {
    Constants.getUserDetailsSharedPreference().then((value) {
      setState(() {
        userDetails = value;
      });
      name = value[0];
      dob = value[2];
      semester = value[6];
      rollNo = value[7];
      datecontroller.text = dob;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        centerTitle: true,
        title: AppLogo(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.blue),
        //brightness: Brightness.li,
      ),
      body: _loading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val) =>
                              name.isEmpty ? "Enter an Name" : null,
                          decoration: InputDecoration(
                              hintText: userDetails[0],
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                          initialValue: userDetails[0],
                          onChanged: (val) {
                            name = val;
                          },
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          initialValue: userDetails[1],
                          decoration: InputDecoration(
                              hintText: userDetails[1],
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                          readOnly: true,
                        ),
                        TextFormField(
                          // initialValue: userDetails[2],
                          controller: datecontroller,
                          style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                          decoration: InputDecoration(
                              hintText: dob == "" ? "Date of Birth" : dob,),
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
                        TextFormField(
                          initialValue: userDetails[3],
                          decoration: InputDecoration(
                              hintText: userDetails[3],
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                          readOnly: true,
                        ),
                        TextFormField(
                          initialValue: userDetails[4],
                          decoration: InputDecoration(
                              hintText: userDetails[4],
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                          readOnly: true,
                        ),
                        TextFormField(
                          initialValue: userDetails[5],
                          decoration: InputDecoration(
                              hintText: userDetails[5],
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                          readOnly: true,
                        ),
                        if (userDetails[3] == "Student")
                          DropdownButtonFormField(
                            value: userDetails[6],
                              decoration: InputDecoration(
                                  hintText: userDetails[6],
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  )),
                              validator: (val) {
                                return val == null ? "Selec a Semester" : null;
                              },
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
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
                        if (userDetails[3] == "Student")
                          TextFormField(
                            initialValue: userDetails[7],
                            style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                            decoration: InputDecoration(
                                hintText: userDetails[7],),
                            validator: (value) =>
                                value == "" ? "Enter valid Roll number" : null,
                            onChanged: (value) {
                              rollNo = value;
                            },
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          GestureDetector(
                            onTap: () {
                              updateDetails();
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
                                "Update Account Details",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
