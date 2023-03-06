import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'form_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding:
              const EdgeInsets.only(left: 0.0, right: 0.0, top: 0, bottom: 27),
          child: Text(
            'Hey ${FirebaseAuth.instance.currentUser!.displayName}',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          height: 85,
          width: 260,
          padding:
              const EdgeInsets.only(left: 0.0, right: 0.0, top: 10, bottom: 27),
          child: ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              // GoogleSignIn().signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                return const FormScreen();
              }), ModalRoute.withName('/'));
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                side:
                    const BorderSide(color: Color.fromARGB(255, 76, 137, 137)),
                borderRadius: BorderRadius.circular(5),
              )),
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 34, 78, 113).withOpacity(0.2)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.logout_outlined),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    )));
  }
}
