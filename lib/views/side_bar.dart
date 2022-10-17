import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quizmaker/helper/authenticate.dart';
import 'package:quizmaker/helper/constants.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:quizmaker/services/auth.dart';
import 'package:quizmaker/views/account_details.dart';
import 'package:quizmaker/views/attempt_history.dart';
import 'package:quizmaker/views/all_quiz_list.dart';
import 'package:quizmaker/views/signin.dart';
import 'package:quizmaker/widget/about.dart';
import 'home.dart';

class SideBar extends StatefulWidget {
  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  List<String> userDetails = List<String>.filled(8, "");
  AuthService _authService = AuthService();
  
  @override
  void initState() {
    Constants.getUserDetailsSharedPreference().then((value) {
      setState(() {
        userDetails = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("1589952.jpg"), fit: BoxFit.cover),
            ),
            child: Container(
              child: Column(
                children: [
                  Spacer(),
                  Text(
                    "Hello, " + userDetails[0] + "!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    userDetails[1],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w100,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.home),
                Text(
                  " Home",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => Home()));
            },
          ),
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.account_box),
                Text(
                  " Account",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => AccountDetails()));
            },
          ),
          if (userDetails[3] == "Student")
            ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.history_edu),
                  Text(
                    " Quiz Attempt History",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => AttemptHistory(email: userDetails[1],)));
              },
            ),
          if (userDetails[3] == "Faculty")
            ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.task),
                  Text(
                    " Quiz Responses",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => AllQuizList(email: userDetails[1],)));
              },
            ),
          if (userDetails[3] == "Faculty")
            ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.book),
                  Text(
                    " Generate Report",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.info),
                Text(
                  " About Us",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => About()));
            },
          ),
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.logout),
                Text(
                  " Sign Out",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              if (_authService.signOut() != null) {
                Constants.saveUserLoggedInSharedPreference(false);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (builder) => Authenticate()));
              }
            },
          ),
        ],
      ),
    );
  }
}
