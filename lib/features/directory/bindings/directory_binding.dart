import 'package:get/get.dart';
import '../controllers/directory_controller.dart';

class DirectoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DirectoryController>(() => DirectoryController(), fenix: true);
  }
}
