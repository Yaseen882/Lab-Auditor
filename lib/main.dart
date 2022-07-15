import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_assignment_mobile/fetch_data/domain/sign_up_model.dart';
import 'package:student_assignment_mobile/fetch_data/login_screen/login_screen.dart';

import 'Connectivity.dart';
import 'Constants.dart';
import 'fetch_data/admin_site/courses/add_student_courses.dart';

Function? setTheState;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final message =
        hasInternet ? 'You have on ${result.name}' : 'You have no internet';
    final color = hasInternet ? Constants.primaryColor : Colors.red;
    final icon = hasInternet
        ? const Icon(
            Icons.wifi,
            size: 40,
          )
        : const Icon(Icons.wifi_off, size: 40);
    Utils.showTopSnackBar(context, message, color, icon);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTheState = () {
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      home: ChangeNotifierProvider<SignUpModel>(
          create: (context) {
            return SignUpModel();
          },
          child: const MySignInPage()),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
