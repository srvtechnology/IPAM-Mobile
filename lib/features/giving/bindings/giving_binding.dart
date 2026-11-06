import 'package:get/get.dart';
import '../controllers/giving_controller.dart';
import '../data/giving_provider.dart';

class GivingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GivingProvider>(() => GivingProvider());
    Get.lazyPut<GivingController>(
      () => GivingController(provider: Get.find<GivingProvider>()),
    );
  }
}
