import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_assignment_mobile/fetch_data/domain/sign_up_model.dart';
import 'package:student_assignment_mobile/fetch_data/login_screen/signUp_screen.dart';

import '../../Connectivity.dart';
import '../../Constants.dart';
import '../Provider/provider.dart';
import '../admin_site/courses/add_student_courses.dart';
bool? _passwordVisible = false;
class MySignInPage extends StatelessWidget {
  const MySignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CUserProvider>(create: (context) => CUserProvider(),child: const SignUpScreen(),);
  }
}
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpUser(),
    );
  }
}

class SignUpUser extends StatefulWidget {
  const SignUpUser({Key? key}) : super(key: key);

  @override
  State<SignUpUser> createState() => _SignUpUserState();
}

class _SignUpUserState extends State<SignUpUser> {
  final _keyForm = GlobalKey<FormState>();
  String userName = '';
  String password = '';
  bool isLoading = true;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final CollectionReference _reference = FirebaseFirestore.instance.collection('user');
  final SignUpModel _signUpModel = SignUpModel();
  String? userId;
  Future<void> registerUser({required String email, required String password}) async {

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password:password,
      );
      isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signup Successfully')));
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Home(),));
      emailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        isLoading = true;

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('No user found for that email.')));
      } else if (e.code == 'wrong-password') {
        isLoading = true;

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Wrong password provided for that user.')));
      }
    }

  }
/*  void showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final message = hasInternet
        ? 'You have again on ${result.name}'
        : 'You have no internet';
    final color = hasInternet ? Constants.primaryColor : Colors.red;
    final icon = hasInternet
        ? const Icon(
      Icons.wifi,
      size: 40,
    )
        : const Icon(Icons.wifi_off, size: 40);
    Utils.showTopSnackBar(context, message, color, icon);
  }*/
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var reference = FirebaseFirestore.instance.collection('user').doc(userId);
  //  debugPrint('...................userId........Build................$userId');
    SignUpModel signUpProvider =
        Provider.of<SignUpModel>(context, listen: false);
    var user = Provider.of<CUserProvider>(context);
    // debugPrint('...................user................$userData');
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromARGB(255, 116, 103, 93), Color(0xff291F1A)])),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 7,
                    child: Form(
                      key: _keyForm,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                           const Text(
                            'Auditor',
                            maxLines: 1,
                            style: TextStyle(color: Constants.primaryColor,fontSize: 30,fontWeight: FontWeight.bold),

                          ),
                          SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                color: Colors.white, fontSize: width * 0.05),
                            // validator: EmailValidator(
                            //     errorText: 'enter a valid email address'),
                            onChanged: (value) {
                              userName = value;
                            },
                            maxLines: 1,
                            showCursor: true,
                            cursorColor: Constants.primaryColor,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Constants.primaryColor,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  width: 1,
                                  //color: Colors.white,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              //filled: true,
                              prefixIcon: Icon(
                                Icons.mail_outline,
                                color: Colors.white,
                                size: Constants.defaultIconSize,
                              ),
                              fillColor: Colors.transparent,
                              hintStyle: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.white,
                                  fontFamily: Constants.defaultFontFamily,
                                  fontSize: Constants.defaultFontSize),
                              hintText: "Email",
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            style: TextStyle(
                                color: Colors.white, fontSize: width * 0.05),
                            onChanged: (value) {
                              password = value;
                            },
                            showCursor: true,
                            obscureText: !_passwordVisible!,
                            cursorColor: Constants.primaryColor,

                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible!
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toggle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisible = !_passwordVisible!;
                                  });
                                },
                              ),

                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Constants.primaryColor,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  width: 1,
                                  //color: Colors.black,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              //filled: true,
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Colors.white,
                                size: Constants.defaultIconSize,
                              ),

                              fillColor: Colors.transparent,
                              hintStyle: const TextStyle(
                                color: Colors.white,
                                fontFamily: Constants.defaultFontFamily,
                                fontSize: Constants.defaultFontSize,
                              ),
                              hintText: "Password",
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          // Container(
                          //   width: double.infinity,
                          //   child: Text(
                          //     "Forgot your password?",
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       fontFamily: Constants.defaultFontFamily,
                          //       fontSize: Constants.defaultFontSize,
                          //       fontStyle: FontStyle.normal,
                          //     ),
                          //     textAlign: TextAlign.end,
                          //   ),
                          // ),
                          SizedBox(
                            height: 25,
                          ),
                          isLoading ?Container(
                            width: 200,
                            height: 45,
                            decoration: const BoxDecoration(
                              // border: Border.all(
                              //     color: Constants.primaryColor,
                              //     width: 2,
                              //     style: BorderStyle.solid),
                                borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                                color: Constants.primaryColor),
                            child: MaterialButton(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.white,
                                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                child:
                                const Text(
                                  "SIGN IN",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                )
                                ,
                                onPressed: () async {
                                  if (FocusScope.of(context).isFirstFocus) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  }


                                    if (_keyForm.currentState!.validate()) {
                                     // final SignUpModel _signUpModel = SignUpModel();
                                      registerUser(email:userName,password: password );



                                  }
                                }),
                          ): Container(

                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Constants.primaryColor,),
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                          SizedBox(
                            height: 2,
                          ),

                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.white70,
                                fontFamily: Constants.defaultFontFamily,
                                fontSize: 19,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MySignUpPage(),))
                            },
                            child: Container(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                    fontFamily: Constants.defaultFontFamily,
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
