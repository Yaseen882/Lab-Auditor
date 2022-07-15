import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
String? title;
String? titleId;
DocumentSnapshot? ds;
List allData = [];
class CourseTitle extends ChangeNotifier{
  CollectionReference courseTitle = FirebaseFirestore.instance.collection('courses');
  final CollectionReference _collectionRef = FirebaseFirestore.instance.collection('courses');

  Future<void> addCourseTitle() {
    return courseTitle.add({'courseTitle': title}).then((value) {
      if (kDebugMode) {
        print('..............course title added..............');

      }
      notifyListeners();
    }).catchError((error) {
      if (kDebugMode) {
        print('.............error course title..............$error');
      }
    });
  }

  Future<void> updateCourseTitle() async {
    return courseTitle.doc(titleId).update({'courseTitle': title}).then(
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

  Future<void> deleteCourseTitle() async {
    courseTitle.doc(titleId).delete().then((value) {
      print('.......................deleted courseTitle................');
      notifyListeners();
    }).catchError((error) {
      print(
          '....................does not delete courseTitle................$error');
    });

  }
  Future<QuerySnapshot> getCourseTitle() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    if (kDebugMode) {
      print('..............get querySnapshot............${querySnapshot.size}');
    }
    // Get data from docs and convert map to List
    allData = querySnapshot.docs.map((doc) => doc['courseTitle']).toList();
    notifyListeners();

    if (kDebugMode) {
      print('..............get title............$allData');
    }
    return querySnapshot;
  }
  void notifyCourseTitle(){
    notifyListeners();
  }
}
