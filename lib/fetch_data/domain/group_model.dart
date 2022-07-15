import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:student_assignment_mobile/fetch_data/admin_site/groups/course_group.dart';
String? group;
String? groupId;
DocumentSnapshot? groupDS;
List groupData = [];
class GroupTitle extends ChangeNotifier{
  CollectionReference courseTitle = FirebaseFirestore.instance.collection(documentCollection!);
  final CollectionReference _collectionRef = FirebaseFirestore.instance.collection(documentCollection!);

  Future<void> addGroupTitle() {
    return courseTitle.add({'groupTitle': group}).then((value) {
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

  Future<void> updateGroupTitle() async {
    return courseTitle.doc(groupId).update({'groupTitle': group}).then(
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

  Future<void> deleteGroupTitle() async {
    courseTitle.doc(groupId).delete().then((value) {
      print('.......................deleted courseTitle................');
      notifyListeners();
    }).catchError((error) {
      print(
          '....................does not delete courseTitle................$error');
    });

  }
  Future<QuerySnapshot> getGroupTitle() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    if (kDebugMode) {
      print('..............get querySnapshot............${querySnapshot.size}');
    }
    // Get data from docs and convert map to List
    groupData = querySnapshot.docs.map((doc) => doc['groupTitle']).toList();
    print('..............get group data............$groupData');
    notifyListeners();

    if (kDebugMode) {
      print('..............get title............$groupData');
    }
    return querySnapshot;
  }
  void notifyGroupTitle(){
    notifyListeners();
  }
}