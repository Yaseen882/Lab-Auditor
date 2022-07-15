
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../login_screen/login_screen.dart';
List? userData = [];

class SignUpModel extends ChangeNotifier{
  String _userName='';
  String _password='';

  String? get getUserName => _userName;

  set setUserName(String value) {
    _userName = value;
  }

  String? get getPassword => _password;

  set setPassword(String value) {
    _password = value;
  }
/*  CollectionReference reference = FirebaseFirestore.instance.collection('user');
  Future<void> registerUser(){
    return reference.add({
      'userName':getUserName,
      'password':getPassword,
    }).then((value){
     // ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(content: Text('Signup Successfully')));
      userId =  value.id;
      debugPrint('...............userId.....In Model.............$userId');
      notifyListeners();
    }).catchError((error){
      debugPrint('...............SignUp Error..................$error');

    });
  }*/
 /* Future<QuerySnapshot> getStudent() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await reference.get();
    if (kDebugMode) {
      print('..............get User querySnapshot............${querySnapshot.size}');
    }
    // Get data from docs and convert map to List
    userData = querySnapshot.docs.map((doc) => doc['name']).toList();
    print('...................get User Data..............##############............$userData');
    notifyListeners();

    if (kDebugMode) {
      print('..............get User............$userData');
    }
    return querySnapshot;
  }*/
}
