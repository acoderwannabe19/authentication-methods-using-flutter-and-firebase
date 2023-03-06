import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../screens/form_screen.dart';
import '../screens/user_screen.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isLoading, {Key? key}) : super(key: key);

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String firstName,
    String lastName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  // ignore: library_private_types_in_public_api
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _firstName = '';
  var _lastName = '';
  var _userPassword = '';
  bool _showPassword = false;
  var emailController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var passwordController = TextEditingController();

  void _trySubmit() async {
    final dbRef = FirebaseDatabase.instance.ref().child("users");
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(_userEmail.trim(), _userPassword.trim(),
          _firstName.trim(), _lastName.trim(), _isLogin, context);

      if (!_isLogin) {
        dbRef.push().set({
          "email": emailController.text,
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "password": passwordController.text,
        });
        //await FirebaseAuth.instance.currentUser.updateDisplayName(firstNameController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration:
          const BoxDecoration(color: Color.fromARGB(136, 209, 188, 188)),
      child: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 125.0, top: 50, bottom: 0),
                    child: const DefaultTextStyle(
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 55.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 174, 106, 16),
                        ),
                        child: Text('Appname')),
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.only(
                          top: 30.0, left: 15.0, right: 30.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: emailController,
                            key: const ValueKey('email'),
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 93, 90, 90)),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange),
                                )),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            enableSuggestions: true,
                            validator: (value) {
                              if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value!) ==
                                  false) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userEmail = value!;
                            },
                          ),
                          if (!_isLogin) const SizedBox(height: 10.0),
                          if (!_isLogin)
                            TextFormField(
                              controller: firstNameController,
                              key: const ValueKey('firstName'),
                              decoration: const InputDecoration(
                                  labelText: 'First name',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 93, 90, 90)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.orange))),
                              textCapitalization: TextCapitalization.words,
                              enableSuggestions: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a firstName';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _firstName = value!;
                              },
                            ),
                          if (!_isLogin)
                            TextFormField(
                              controller: lastNameController,
                              key: const ValueKey('lastName'),
                              decoration: const InputDecoration(
                                  labelText: 'Last name',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 93, 90, 90)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.orange))),
                              textCapitalization: TextCapitalization.words,
                              enableSuggestions: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a lastName';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _lastName = value!;
                              },
                            ),
                          TextFormField(
                            controller: passwordController,
                            key: const ValueKey('password'),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(
                                        () => _showPassword = !_showPassword);
                                  },
                                  icon: Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: _showPassword
                                        ? Colors.orange
                                        : const Color.fromARGB(255, 93, 90, 90),
                                  )),
                              labelText: 'Password',
                              labelStyle: const TextStyle(
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 93, 90, 90)),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange)),
                            ),
                            obscureText: !_showPassword,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return 'Please enter a long password';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userPassword = value!;
                            },
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          if (widget.isLoading)
                            const CircularProgressIndicator(),
                          if (!widget.isLoading)
                            SizedBox(
                              height: 45.0,
                              width: 250,
                              child: Material(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                color: const Color.fromARGB(255, 174, 106, 38)
                                    .withOpacity(0.4),
                                elevation: 30.0,
                                child: TextButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              side: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 188, 134, 72))))),
                                  onPressed: _trySubmit,
                                  child: Center(
                                    child: Text(
                                      _isLogin ? "Log In" : "Sign Up",
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 244, 231, 231),
                                          fontSize: 16,
                                          fontFamily: 'Raleway',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (_isLogin)
                            TextButton(
                                onPressed: () {
                                  if (emailController.text != '') {
                                    FirebaseAuth.instance
                                        .sendPasswordResetEmail(
                                            email: emailController.text);
                                  }
                                },
                                child: const Text(
                                  "Forgot password?",
                                  style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 170, 105, 14),
                                      decoration: TextDecoration.underline),
                                )),
                          Container(
                              padding: const EdgeInsets.only(
                                  left: 0.0, right: 50.0, top: 30, bottom: 20),
                              child: const Text.rich(
                                TextSpan(
                                  text: '               ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 47, 45, 45),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '*                             ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 47, 45, 45),
                                        )),
                                    TextSpan(
                                        text: ' or ',
                                        style: TextStyle(
                                          fontFamily: 'Raleway',
                                          color:
                                              Color.fromARGB(255, 47, 45, 45),
                                        )),
                                    TextSpan(
                                        text: '                          *',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color:
                                              Color.fromARGB(255, 47, 45, 45),
                                        )),
                                  ],
                                ),
                              )),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 75,
                            width: 260,
                            padding: const EdgeInsets.only(
                                left: 0.0, right: 0.0, top: 10, bottom: 15),
                            child: ElevatedButton(
                              onPressed: () {
                                signInWithGoogle().then((result) {
                                  // ignore: unnecessary_null_comparison
                                  if (result != null) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return UserScreen();
                                        },
                                      ),
                                    );
                                  }
                                });
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 76, 137, 137)))),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 34, 78, 113)
                                        .withOpacity(0.2)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Image(
                                        image: AssetImage(
                                            "assets/images/google_logo.png"),
                                        height: 35.0),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, top: 0, bottom: 0),
                                      child: Text(
                                        'Sign in with Google',
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
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 85,
                            width: 260,
                            padding: const EdgeInsets.only(
                                left: 0.0, right: 0.0, top: 10, bottom: 27),
                            child: ElevatedButton(
                              onPressed: () {
                                signInWithFacebook().then((result) {
                                  // ignore: unnecessary_null_comparison
                                  if (result != null) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const UserScreen();
                                        },
                                      ),
                                    );
                                  }
                                });
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Color.fromARGB(255, 76, 137, 137)),
                                  borderRadius: BorderRadius.circular(5),
                                )),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 34, 78, 113)
                                        .withOpacity(0.2)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Image(
                                        image: AssetImage(
                                            "assets/images/facebook_logo1.png"),
                                        height: 35.0),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Sign in with Facebook',
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
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 75,
                            width: 260,
                            padding: const EdgeInsets.only(
                                left: 0.0, right: 0.0, top: 0, bottom: 25),
                            child: ElevatedButton(
                              onPressed: () {
                                signInWithGoogle().then((result) {
                                  // ignore: unnecessary_null_comparison
                                  if (result != null) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return UserScreen();
                                        },
                                      ),
                                    );
                                  }
                                });
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 76, 137, 137)))),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 34, 78, 113)
                                        .withOpacity(0.2)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Image(
                                        image: AssetImage(
                                            "assets/images/twitter_logo.png"),
                                        height: 80.0),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, top: 0, bottom: 0),
                                      child: Text(
                                        'Sign in with Twitter',
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
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 75,
                            width: 260,
                            padding: const EdgeInsets.only(
                                left: 0.0, right: 0.0, top: 10, bottom: 15),
                            child: ElevatedButton(
                              onPressed: () {
                                signInWithGoogle().then((result) {
                                  // ignore: unnecessary_null_comparison
                                  if (result != null) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return UserScreen();
                                        },
                                      ),
                                    );
                                  }
                                });
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 76, 137, 137)))),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 34, 78, 113)
                                        .withOpacity(0.2)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Image(
                                        image: AssetImage(
                                            "assets/images/github_logo.png"),
                                        height: 35.0),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, top: 0, bottom: 0),
                                      child: Text(
                                        'Sign in with Github',
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
                          if (!widget.isLoading)
                            if (_isLogin)
                              SizedBox(
                                height: 140.0,
                                child: Material(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(25)),
                                  color: Colors.transparent,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isLogin = !_isLogin;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 70.0, left: 190.0, right: 0.0),
                                      child: const Text(
                                        "New User? Sign up!",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Color.fromARGB(
                                                255, 194, 131, 21),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Raleway'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          if (!widget.isLoading)
                            if (!_isLogin)
                              SizedBox(
                                height: 60.0,
                                //width: 500,
                                child: Material(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(25)),
                                  color: Colors.transparent,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isLogin = !_isLogin;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 0.0,
                                          left: 170.0,
                                          right: 0.0,
                                          bottom: 10),
                                      child: const Text(
                                        "Already User? Sign in!",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Color.fromARGB(
                                                255, 194, 131, 21),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Raleway'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context)
                                      .viewInsets
                                      .bottom)),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
