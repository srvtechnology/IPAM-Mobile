import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/careers_controller.dart';
import '../widgets/career_my_postings_view.dart';

class CareerMyPostingsScreen extends GetView<CareersController> {
  const CareerMyPostingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CareersController>()) {
      Get.put(CareersController());
    }

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: CareerMyPostingsView(
            onBack: () => Get.back(),
          ),
        ),
      ),
    );
  }
}
