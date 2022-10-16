import 'package:contactus/contactus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:quizmaker/views/side_bar.dart';
import 'package:quizmaker/widget/widget.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ContactUs(
            avatarRadius: 75,
            textColor: Colors.white,
            cardColor: Colors.blue,
            taglineColor: Colors.black,
            companyColor: Colors.blue,
            logo: AssetImage('icon_flutter.png'),
            email: 'vadgamasiddharth9@gmail.com',
            companyName: 'Siddharth Vadgama',
            phoneNumber: '+91123456789',
            dividerThickness: 2,
            website: 'https://github.com/Siddhu2543/quizmakerapp',
            githubUserName: 'Siddhu2543',
            tagLine: 'Flutter Developer',
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black, blurRadius: 2)],
              color: Colors.white,
            ),
            height: 150,
            padding: EdgeInsets.symmetric(horizontal: 24),
            margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Text(
              "Quiz Maker Application for University use where Faculties can create quizzes and set to whom it will be available and Students will get to attempt quizzes accordingly!",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontStyle: FontStyle.normal),
            ),
          )
        ],
      ),
      bottomNavigationBar: ContactUsBottomAppBar(
        textFont: "Noto",
        fontSize: 18,
        companyName: 'Siddharth Vadgama & Faizan Vora',
        textColor: Colors.white,
        backgroundColor: Colors.blue,
        email: '',
      ),
    );
  }
}
