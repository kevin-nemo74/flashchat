import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import '../components/new_button.dart';

class WelcomeScreen extends StatefulWidget {
  static final id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      textStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  totalRepeatCount: 6,
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            NewButton(
                colour: Colors.lightBlueAccent,
                title: 'Log In',
                onPress: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                }),
            NewButton(
                colour: Colors.blueAccent,
                title: 'Register',
                onPress: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                }),
          ],
        ),
      ),
    );
  }
}
