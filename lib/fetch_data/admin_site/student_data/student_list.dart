import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_assignment_mobile/fetch_data/admin_site/student_data/student_infromation.dart';
import 'package:student_assignment_mobile/fetch_data/domain/student_model.dart';
import 'package:student_assignment_mobile/fetch_data/admin_site/student_data/assignment/uploaded_files.dart';

import '../../../main.dart';

String? studentCollection;

class StudentData extends StatelessWidget {
  const StudentData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Student>(
      create: (context) {
        return Student();
      },
      child: const StudentList(),
    );
  }
}

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  Uint8List? fileBytes;
  String? fileName = '';
  FilePickerResult? result;


  void pickFileFromMobile() async {
    result = await FilePicker.platform
        .pickFiles(type: FileType.any, allowMultiple: false, withData: true);

    if (result?.files.first != null) {
      //listOfFile = result?.paths.map((path)=> File(path!)).toList();
      fileBytes = result?.files.first.bytes;
      fileName = result?.files.first.name;
      print(
          '.......................file name is ........................$fileName');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Container(
            color: Colors.white,
            child: Text('$fileName'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                uploadFileToFirebase();
              },
              child: const Text('upload'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  fileName = '';
                });
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      );

      setTheState!();
    } else {
      // User canceled the picker
    }
  }

  Future<void> uploadFileToFirebase() async {
    Navigator.pop(context);
    try {
      await FirebaseStorage.instance
          .ref('/$studentCollection/$fileName')
          .putData(fileBytes!);
      if (kDebugMode) {
        print('...........File Uploaded Successfully...............');
      }
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
            setState(() {
              fileName = '';
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UploadedFiles(),
                ));
          });
          return AlertDialog(
            title: Column(
              children: const [
                Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 50,
                ),
                Text('Success!')
              ],
            ),
          );
        },
      );
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('...........File Not Upload...............');
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    Student studentProvider = Provider.of<Student>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xff382f28),
      appBar: AppBar(
        title: const Text('Students'),
        backgroundColor: const Color(0xff382f28),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              print(
                  '.....................PopMenu Value ...................$value');
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: '0',
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UploadedFiles(),
                        ),
                      );
                    },
                    child: const Text('Uploaded Files'),
                  ),
                )
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: Student().getStudent(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            const Center(
              child: Text('Something went wrong!'),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            print('..................Student  data................${studentData.length}');
            return studentData.isNotEmpty ? ListView.builder(
              itemCount: studentData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(

                    child: GestureDetector(
                      onTap: () {},
                      onLongPress: () {
                        studentDS = snapshot.data?.docs[index];
                        studentId = studentDS?.id;
                        studentProvider.notifyStudent();

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Do you want to delete?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    studentProvider.deleteStudent();
                                    setState(() {});

                                    Navigator.pop(context);
                                  },
                                  child: const Text('delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: GestureDetector(
                        onTap: () {
                          studentDS = snapshot.data?.docs[index];
                          studentId = studentDS?.id;
                          studentProvider.notifyStudent();
                          print('...................student Id...............$studentId');
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentInformation(),));

                        },
                        child: Container(

                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.white,),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading:  const CircleAvatar(
                                radius: 25.0,
                                child: Icon(Icons.person),
                              ),
                              title: Text(
                                '${studentData[index]}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ):const Center(child: Text('Oop\'s Empty!',style: TextStyle(color: Colors.white),),);
          } else {
            const Center(
              child: Text('Student not found!'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black87,
        onPressed: () {
          pickFileFromMobile();
        },
        label: const Text('Open Files'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
