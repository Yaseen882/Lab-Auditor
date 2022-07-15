import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../Constants.dart';
import '../Provider/provider.dart';
import '../domain/sign_up_model.dart';
import 'login_screen.dart';
bool? _passwordVisible = false;

class MySignUpPage extends StatelessWidget {
  const MySignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CUserProvider>(create: (context) => CUserProvider(),child: const SignUp(),);
  }
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _keyForm = GlobalKey<FormState>();
  String userName = '';
  String password = '';
  bool isLoading = true;

  String? userId;
  Future<void> registerUser({required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen(),));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('The password provided is too weak.')));

      } else if (e.code == 'email-already-in-use') {

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('The account already exists for that email.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Something went wrong!')));
    }
  }
  @override
  Widget build(BuildContext context) {
    //var userProvider = Provider.of<CUserProvider>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromARGB(255, 116, 103, 93), Color(0xff291F1A)])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Form(
          key: _keyForm,
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          height: height*0.17,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Icon(
                              Icons.close,
                              size: width*0.06,
                              color: Colors.amber.shade300,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Flexible(
                        flex: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'Auditor',
                              style: TextStyle(color: Constants.primaryColor,fontSize: 30,fontWeight: FontWeight.bold),


                            ),
                            SizedBox(
                              height: height*0.07,
                            ),



                            SizedBox(
                              height: height*0.03,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email';
                                }
                                return null;
                              },

                              style:  TextStyle(color: Colors.white,fontSize:width*0.05 ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(' '),
                                FilteringTextInputFormatter.deny('!'),
                                FilteringTextInputFormatter.deny('#'),
                                FilteringTextInputFormatter.deny('%'),
                                FilteringTextInputFormatter.deny('^'),
                                FilteringTextInputFormatter.deny('&'),
                                FilteringTextInputFormatter.deny('*'),
                                FilteringTextInputFormatter.deny('('),
                                FilteringTextInputFormatter.deny(')'),
                                FilteringTextInputFormatter.deny('-'),
                                FilteringTextInputFormatter.deny('+'),
                                FilteringTextInputFormatter.deny('='),
                                FilteringTextInputFormatter.deny(';'),
                                FilteringTextInputFormatter.deny('?'),
                                FilteringTextInputFormatter.deny(','),
                                FilteringTextInputFormatter.deny('~'),
                                FilteringTextInputFormatter.deny(':'),
                                FilteringTextInputFormatter.deny('}'),
                                FilteringTextInputFormatter.deny('{'),
                                FilteringTextInputFormatter.deny('['),
                                FilteringTextInputFormatter.deny(']'),
                                FilteringTextInputFormatter.deny('/'),
                                FilteringTextInputFormatter.deny(']'),
                                FilteringTextInputFormatter.deny('_'),
                                FilteringTextInputFormatter.deny("'"),
                                FilteringTextInputFormatter.deny('"'),
                                FilteringTextInputFormatter.deny('<'),
                                FilteringTextInputFormatter.deny('>'),
                                FilteringTextInputFormatter.deny("\$"),
                              ],
                              //controller: emailController,
                              onChanged: (value) {
                                userName = value;
                              },
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
                                    width: 2,
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                //filled: true,
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.white,
                                  size: Constants.defaultIconSize,
                                ),
                                fillColor: Colors.transparent,
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: Constants.defaultFontFamily,
                                    fontSize: Constants.defaultFontSize),
                                hintText: "Email",
                              ),
                            ),
                            SizedBox(
                              height: height*0.03,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter password';
                                }
                                return null;
                              },
                              style:  TextStyle(color: Colors.white,fontSize:width*0.05 ),
                              onChanged: (value) {
                                password = value;
                              },
                              showCursor: true,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: !_passwordVisible!,
                              cursorColor: Constants.primaryColor,
                              obscuringCharacter: '●',
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
                                    // Update the state i.e. toogle the state of passwordVisible variable
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

                                    style: BorderStyle.solid,
                                  ),
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                filled: true,
                                prefixIcon: const Icon(
                                  Icons.lock_outlined,
                                  color: Colors.white,

                                ),
                                fillColor: Colors.transparent,
                                hintStyle: const TextStyle(
                                  color: Colors.white,

                                ),
                                hintText: "Password",
                              ),
                            ),

                            SizedBox(
                              height: height*0.05,
                            ),
                            /// SignUp Button
                            Container(
                              width: 200,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                  color: Constants.primaryColor),
                              child: MaterialButton(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.white,
                                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                child: const Text(
                                  "SIGN UP",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                 if(_keyForm.currentState!.validate()){
                                   registerUser(email: userName,password: password);
                                   isLoading = false;

                                 }






                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      /// Already Account

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
