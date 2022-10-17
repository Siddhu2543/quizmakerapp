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
            companyName: 'Quiz Maker Application',
            phoneNumber: '+91123456789',
            dividerThickness: 2,
            website: 'https://github.com/Siddhu2543/quizmakerapp',
            githubUserName: 'Siddhu2543/quizmakerapp',
            tagLine: 'Flutter Project',
          ),
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
