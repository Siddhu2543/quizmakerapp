import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizmaker/helper/constants.dart';
import 'package:quizmaker/services/auth.dart';
import 'package:quizmaker/widget/widget.dart';
import 'home.dart';

class SignIn extends StatefulWidget {
  final Function toogleView;

  SignIn({required this.toogleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  String email = '', password = '';

  bool isLoading = false;

  signIn() async {
    if(_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await _authService.signInEmailAndPass(email, password).then((val) => {
        if(val != null){
          setState(() {
            isLoading = true;
          }),
          Constants.saveUserLoggedInSharedPreference(true),
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()))
        }else{
          setState(() {
            isLoading = false;
          }),
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
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
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Spacer(),
              Container(
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) { return val!.isEmpty ? "Enter email id" : null;},
                      decoration: InputDecoration(hintText: "Email"),
                      onChanged: (val) {
                        email = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) { return val!.isEmpty ? "Enter password" : null;},
                      decoration: InputDecoration(hintText: "Password"),
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: (){
                        signIn();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          "Sign In",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account? ',
                            style:
                                TextStyle(color: Colors.black87, fontSize: 17)),
                        GestureDetector(
                          onTap: () {
                            widget.toogleView();
                          },
                          child: Container(
                            child: Text('Sign Up',
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
              SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
    );
  }
}
