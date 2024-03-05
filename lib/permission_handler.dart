import 'package:just_share/logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestFilePermission() async {
  try {
    await Permission.storage.request();
  } catch (e) {
    logger.d('Could not request storage permission $e');
  }
  return true;
}
  // var status = await Permission.storage.request();
//   // if (status.isGranted) {
//   //   logger.d'File permission granted');
//   //   // You can now create files
//   //   return true;
//   // } else {
//   //   logger.d'File permission denied');
//   //   // Handle permission denied
//   //   return false;
//   // }
// }
