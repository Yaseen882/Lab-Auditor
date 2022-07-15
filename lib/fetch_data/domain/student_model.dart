import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:student_assignment_mobile/fetch_data/admin_site/student_data/student_list.dart';

import '../admin_site/student_data/student_infromation.dart';
String? student;
String? studentId;
DocumentSnapshot? studentDS;
List studentData = [];

class Student extends ChangeNotifier{


 // final CollectionReference collectionRef = FirebaseFirestore.instance.collection(imageId!);

  Future<void> addStudent() {
    CollectionReference std = FirebaseFirestore.instance.collection(studentCollection!);
    return std.add({'student': student}).then((value) {
      if (kDebugMode) {
        print('..............student added..............');

      }
      notifyListeners();
    }).catchError((error) {
      if (kDebugMode) {
        print('.............error course title..............$error');
      }
    });
  }

  Future<void> updateStudent() async {
    CollectionReference std = FirebaseFirestore.instance.collection(studentCollection!);
    return std.doc(studentId).update({'name': student}).then(
          (value) {

        if (kDebugMode) {
          print('...............courseTitle Updated..........');
        }
        notifyListeners();
      },
    ).catchError((error) {
      if (kDebugMode) {
        print(
            '............................error CourseTitle  does not update...............$error');
      }
    });
  }

  Future<void> deleteStudent() async {
    CollectionReference std = FirebaseFirestore.instance.collection(studentCollection!);
    std.doc(studentId).delete().then((value) {
      print('.......................deleted courseTitle................');
      notifyListeners();
    }).catchError((error) {
      print(
          '....................does not delete courseTitle................$error');
    });

  }
  Future<QuerySnapshot> getStudent() async {
    final CollectionReference _collectionRef = FirebaseFirestore.instance.collection(studentCollection!);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    if (kDebugMode) {
      print('..............get Student querySnapshot............${querySnapshot.size}');
      print('..............get studentCollection............$studentCollection');
    }
    // Get data from docs and convert map to List
    studentData = querySnapshot.docs.map((doc) => doc['name']).toList();
    print('...................get Student Data..............##############............$studentData');
    notifyListeners();

    if (kDebugMode) {
      print('..............get Student............$studentData');
    }
    return querySnapshot;
  }
  Future<QuerySnapshot> getStudentProgress() async {
    final CollectionReference _collectionRef = FirebaseFirestore.instance.collection(studentCollection!);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    if (kDebugMode) {
      print('..............get Student querySnapshot............${querySnapshot.size}');
      print('..............get studentCollection............$studentCollection');
    }
    // Get data from docs and convert map to List
    studentData = querySnapshot.docs.map((doc) => doc['name']).toList();
    print('...................get Student Data..............##############............$studentData');
    notifyListeners();

    if (kDebugMode) {
      print('..............get Student............$studentData');
    }
    return querySnapshot;
  }
 /* Future<void> uploadFileToFirebase() async {
    try {
      await FirebaseStorage.instance
          .ref('uploads/$fileName')
          .putData(fileBytes!);
      if (kDebugMode) {
        print('...........File Uploaded Successfully...............');
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('...........File Not Upload...............');
      }
    }

  }*/
  void notifyStudent(){
    notifyListeners();
  }
}