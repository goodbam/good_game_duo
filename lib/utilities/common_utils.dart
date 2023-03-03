import 'package:firebase_storage/firebase_storage.dart';
import '../constants/storage_constants.dart';

class CommonUtils {
  static Future<String> getDefaultProfileImage() async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child(StorageConstants.pathDefaultAvatarImages);
    return await reference.getDownloadURL();
  }
}
