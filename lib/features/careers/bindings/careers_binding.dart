import 'package:get/get.dart';
import '../controllers/careers_controller.dart';

class CareersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CareersController>(() => CareersController(), fenix: true);
  }
}
