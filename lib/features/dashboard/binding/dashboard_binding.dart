import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../directory/controllers/directory_controller.dart';
import '../../careers/controllers/careers_controller.dart';
import '../../events/controllers/events_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<DirectoryController>(() => DirectoryController(), fenix: true);
    Get.lazyPut<CareersController>(() => CareersController(), fenix: true);
    Get.lazyPut<EventsController>(() => EventsController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
