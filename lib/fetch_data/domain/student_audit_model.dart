
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'group_model.dart';

class Storage {
  String? address;
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  firebase_storage.Reference? result;
  Future<firebase_storage.ListResult> listFile() async {
    firebase_storage.ListResult result = await storage.ref(groupId!).list();
    for (var ref in result.items) {
      print('................File Found ......$ref...........');

    }
    return result;
  }
  Future<firebase_storage.Reference?> file() async {

    result = storage.ref(groupId!);
    address = result?.name;
    print('................File Address ......$result...........');
    return result;

  }
  Future<String> downloadURL(String imageName) async{
    String downloadImage = await storage.ref('uploads/$imageName').getDownloadURL();
    return downloadImage;
  }
}
