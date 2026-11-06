import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/giving_controller.dart';
import '../widgets/giving_header_widget.dart';
import '../widgets/make_donation_form_widget.dart';
import '../widgets/membership_dues_widget.dart';
import '../widgets/giving_ledger_widget.dart';
import '../widgets/campaign_impact_widget.dart';

class GivingScreen extends GetView<GivingController> {
  const GivingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<GivingController>()) {
      Get.put(GivingController());
    }

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header with metrics & 4 segmented tabs
              const GivingHeaderWidget(),
              const SizedBox(height: 18),

              // 2. Tab Content Views
              Obx(() {
                final tab = controller.selectedTabIndex.value;
                switch (tab) {
                  case 0:
                    return const MakeDonationFormWidget();
                  case 1:
                    return const MembershipDuesWidget();
                  case 2:
                    return const GivingLedgerWidget();
                  case 3:
                    return const CampaignImpactWidget();
                  default:
                    return const MakeDonationFormWidget();
                }
              }),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
