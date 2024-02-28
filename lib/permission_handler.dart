import 'package:permission_handler/permission_handler.dart';

Future<bool> requestFilePermission() async {
  try {
    await Permission.storage.request();
  } catch (e) {
    print('Could not request storage permission $e');
  }
  return true;
}
  // var status = await Permission.storage.request();
//   // if (status.isGranted) {
//   //   print('File permission granted');
//   //   // You can now create files
//   //   return true;
//   // } else {
//   //   print('File permission denied');
//   //   // Handle permission denied
//   //   return false;
//   // }
// }
