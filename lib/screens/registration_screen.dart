import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/components/rounded_button.dart';
import 'package:flashchat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? email;
  String? password;
  bool _saving = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration: kInputDecoration.copyWith(hintText: 'Enter Email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration:
                    kInputDecoration.copyWith(hintText: "Enter Password"),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  colour: Colors.blueAccent,
                  title: "Register",
                  onPress: () async {
                    try {
                      setState(() {
                        _saving = true;
                      });
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email!, password: password!);
                      if (newUser != null) {
                        setState(() {
                          _saving = false;
                        });
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                    } catch (e) {
                      setState(() {
                        _saving = false;
                      });
                      print(e);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
