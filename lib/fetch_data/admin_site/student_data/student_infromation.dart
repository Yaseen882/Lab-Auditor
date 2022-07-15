
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_assignment_mobile/fetch_data/admin_site/student_data/student_list.dart';
import 'package:student_assignment_mobile/fetch_data/domain/student_model.dart';
import 'package:student_assignment_mobile/fetch_data/teacher_site/audit_student.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:glassmorphism/glassmorphism.dart';

import '../../../Constants.dart';
String? imageName;
String? imageId;
String? documentID;
String? nameCollection;
class StudentInformation extends StatefulWidget {
  const StudentInformation({Key? key}) : super(key: key);

  @override
  _StudentInformationState createState() => _StudentInformationState();
}

class _StudentInformationState extends State<StudentInformation> {
  var reference = FirebaseFirestore.instance.collection(studentCollection!).doc(studentId);

  Map<String, dynamic>? studentInformation;

/*  Future<DocumentSnapshot<Map<String, dynamic>>> getStudentInformation() async {
    var docSnapshot = await reference.get();
    if (docSnapshot.exists) {
      studentInformation = docSnapshot.data();

      setState(() {
        data = studentInformation!['email'];

      });
    }
    return docSnapshot;
  }*/

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> downloadURL(String imageName) async {
    String downloadImage = await storage.ref('$imageId/$imageName').getDownloadURL();



    return downloadImage;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xff382f28),
      appBar: AppBar(
        backgroundColor: const Color(0xff382f28),
        title: const Text('Student'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: reference.get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var data = snapshot.data?.data();
             imageName = data!['imageName'];
             imageId = data['imageId'];
            nameCollection = data['name'];
            debugPrint('.................ImageName...................$imageName');
            debugPrint('.................nameCollection...................$nameCollection');

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FutureBuilder<String>(
                    future: downloadURL(imageName!),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        const SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: Center(
                            child: Text('Something went wrong'),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: FadeInImage.assetNetwork(

                            fit: BoxFit.fill,
                            placeholder:
                            'assets/images/loading (1).gif',
                            placeholderFit: BoxFit.cover,
                            image: '${snapshot.data}',
                          ),
                        );
                      } else {
                        const SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: Center(
                            child: Text('Image not found'),
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.black.withAlpha(25),
                            Colors.red.shade700.withAlpha(45),
                          ],
                          stops: const [
                            0.3,
                            1,
                          ]),
                    ),
                    height: MediaQuery.of(context).size.height * 0.43,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [

                          const Text(
                            'Student Detail',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Name :',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryColor,
                                ),
                              ),
                              Text(
                                '${data['name']}',
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.002,
                          ),
                          Divider(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          SizedBox(
                            height: height * 0.002,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'FatherName :',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryColor,
                                ),
                              ),
                              Text(
                                '${data['fatherName']}',
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.002,
                          ),
                          SizedBox(
                            height: height * 0.002,
                          ),
                          SizedBox(
                            height: height * 0.002,
                          ),
                          Divider(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          SizedBox(
                            height: height * 0.002,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Email :',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryColor,
                                ),
                              ),
                              Text(
                                '${data['email']}',
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.002,
                          ),
                          Divider(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          SizedBox(
                            height: height * 0.002,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Contact :',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryColor,
                                ),
                              ),
                              Text(
                               '${data['contact']}',
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.002,
                          ),
                          Divider(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          SizedBox(
                            height: height * 0.002,
                          ),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Address:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Constants.primaryColor,
                                ),
                              )),
                          SizedBox(height: height*0.005),
                          Text(
                            '${data['address']}',
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),

                        ],
                      ),
                    ),),


                ],
              ),
            );
          } else {
            const Center(
              child: Text('Something went wrong!'),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black87,
          onPressed: () async {
            var collection = FirebaseFirestore.instance.collection(nameCollection!);
            var querySnapshots = await collection.get();
            for (var snapshot in querySnapshots.docs) {
              documentID = snapshot.id;
              print('..................Document Id.....................$documentID');
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const AuditStudent();
                },
              ),
            );

          },
          icon: const Icon(Icons.remove_red_eye),
          label: const Text('Audit')),
    );
  }
}
