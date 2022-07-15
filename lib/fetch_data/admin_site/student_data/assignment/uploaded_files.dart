import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:student_assignment_mobile/fetch_data/admin_site/student_data/student_list.dart';

import '../../../../main.dart';

List<File>? listOfFile;

class UploadedFiles extends StatefulWidget {
  const UploadedFiles({Key? key}) : super(key: key);

  @override
  _UploadedFilesState createState() => _UploadedFilesState();
}

class _UploadedFilesState extends State<UploadedFiles> {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  firebase_storage.Reference? result;
  Uint8List? fileBytes;
  String? fileName = '';
  FilePickerResult? resultOfFilePick;
  String? deleteFileName;

  void pickFileFromMobile() async {
    resultOfFilePick = await FilePicker.platform
        .pickFiles(type: FileType.any, allowMultiple: false, withData: true);

    if (resultOfFilePick?.files.first != null) {
      //listOfFile = result?.paths.map((path)=> File(path!)).toList();
      fileBytes = resultOfFilePick?.files.first.bytes;
      fileName = resultOfFilePick?.files.first.name;
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

  Future<firebase_storage.ListResult> listOfUploadedFile() async {
    firebase_storage.ListResult result = await storage.ref('$studentCollection').list();
    for (var ref in result.items) {
      print('...............Upload File Found ......$ref...........');
    }
    return result;
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

  Future<void> deleteFile() async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('/$studentCollection/$deleteFileName')
          .delete();
      setState(() {

      });
      print('.................Deleted Successfully...............');
    } catch (e) {
      debugPrint('Error deleting: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uploaded Files'),
      ),
      body: FutureBuilder<firebase_storage.ListResult>(
          future: listOfUploadedFile(),
          builder: (context, snapshot) {
            print(
                '.....................length of Uploaded Files..............${snapshot.data?.items.length}');
            if (snapshot.hasError) {
              const Center(
                child: Text('Something went wrong!'),
              );
            }
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.items.length,
                itemBuilder: (context, index) {
                  print('.....................Builder.............');
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.blue,
                      child: ListTile(
                        trailing: IconButton(onPressed: () {
                          setState(() {
                            deleteFileName = snapshot.data?.items[index].name;
                          });
                           deleteFile();
                        }, icon: const Icon(Icons.delete)),
                        onLongPress: () {},
                        title: Text('${snapshot.data?.items[index].name}'),
                      ),
                    ),
                  );
                },
              );
            } else {
              const Center(
                child: Text('File Not Found'),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          pickFileFromMobile();
        },
        label: const Text('Open More'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
