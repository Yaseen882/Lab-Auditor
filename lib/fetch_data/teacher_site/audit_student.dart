import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:student_assignment_mobile/fetch_data/domain/student_audit_model.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../Constants.dart';
import '../admin_site/student_data/student_infromation.dart';

String? imageName;
String? imageId;

class AuditStudent extends StatefulWidget {
  const AuditStudent({Key? key}) : super(key: key);

  @override
  State<AuditStudent> createState() => _AuditStudentState();
}

class _AuditStudentState extends State<AuditStudent> {
/*
  Future<void> openFileOne() async {
    print(
        '.........................before........open file result....${storage.result}...........');
    final _result = await OpenFile.open('${storage.result}', type: 'file/dart');
    print(
        '.................................open file result...............${_result.type}');
    setState(() {
      _openResult = 'type:${_result.type}   message:${_result.message}';
    });
  }*/

  Future<String> downloadURL(String imageName) async {
    final firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    String downloadImage =
        await storage.ref('$imageId/$imageName').getDownloadURL();

    return downloadImage;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    var reference =
        FirebaseFirestore.instance.collection(nameCollection!).doc(documentID);
    print(
        '....................................nameCollection.................$nameCollection');
    return Scaffold(
      backgroundColor: const Color(0xff382f28),
      appBar: AppBar(
        backgroundColor: const Color(0xff382f28),
        title: const Text('Student Progress'),
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
            final Timestamp timestamp = snapshot.data!['date'] as Timestamp;
            //final Timestamp time = snapshot.data!['time'] as Timestamp;
            final DateTime dateTime = timestamp.toDate();
            final dateString = DateFormat('dd-MM-yyyy').format(dateTime);

            String time = data!['time'].toString();
            String seconds = data['seconds'].toString();
            String minutes = data['minutes'].toString();
            String hours = data['hours'].toString();
            imageId = data['imageID'];
            String screenshoot = data['imageName'];
            debugPrint('.................Date...................$dateString');
            debugPrint(
                '.................Timer........Hours :$hours..........Minutes :$minutes.............Seconds : $seconds');
            debugPrint('.................Time...................$time');
            debugPrint('.................imageId...................$imageId');

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

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
                    height: MediaQuery.of(context).size.height * 0.5,
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
                                'Start Time :',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryColor,
                                ),
                              ),
                              Text(
                                '${data['time']}',
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
                                'Date :',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryColor,
                                ),
                              ),
                              Text(
                                '$dateString',
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
                                'Working Time :',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryColor,
                                ),
                              ),
                              Text(
                                ' $hours : $minutes : $seconds',
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          FutureBuilder<String>(
                            future: downloadURL(screenshoot),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                const SizedBox(
                                  width: double.infinity,
                                  height: 150,
                                  child: Center(
                                    child: Text('Something went wrong'),
                                  ),
                                );
                              }
                              if (snapshot.connectionState == ConnectionState.done &&
                                  snapshot.hasData) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 150,
                                  child: Image.network(
                                    '${snapshot.data}',
                                    fit: BoxFit.fill,
                                  ),
                                );
                              } else {
                                const SizedBox(
                                  width: double.infinity,
                                  height: 150,
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

                        ],
                      ),
                    ),
                  ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //openFileOne();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
