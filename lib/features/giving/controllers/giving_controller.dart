import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/network/auth_storage_service.dart';
import '../../../core/network/models/user_model.dart';
import '../../../core/theme/app_colors.dart';
import '../data/giving_provider.dart';
import '../models/donation_record.dart';
import '../models/membership_subscription_model.dart';

class GivingController extends GetxController {
  final GivingProvider _provider;
  final AuthStorageService _authStorage;

  GivingController({
    GivingProvider? provider,
    AuthStorageService? authStorage,
  })  : _provider = provider ?? GivingProvider(),
        _authStorage = authStorage ??
            (Get.isRegistered<AuthStorageService>()
                ? Get.find<AuthStorageService>()
                : Get.put(AuthStorageService()));

  // Active top tab (0: Make a Gift, 1: Membership Dues, 2: My Ledger, 3: Impact Feed)
  final selectedTabIndex = 0.obs;

  // Donation Form States
  final selectedFund = 'Student Scholarship Endowment'.obs;
  final fundsList = const [
    'Student Scholarship Endowment',
    'STEM Laboratory Fund',
    'Campus Digitalization Fund',
    'Tower Hill Infrastructure & Innovation Fund',
    'General University Fund',
  ];

  final amountPresets = const [25.0, 50.0, 100.0, 250.0];
  final selectedAmount = 50.0.obs;
  final isCustomAmount = false.obs;
  final customAmountController = TextEditingController();

  final selectedFrequency = 'ONE_TIME'.obs; // 'ONE_TIME' or 'MONTHLY'
  final selectedPaymentMethod = 'CARD'.obs; // 'CARD', 'MOMO', 'BANK', 'PAYPAL'
  final isAnonymous = false.obs;
  final messageController = TextEditingController();
  final isSubmittingDonation = false.obs;

  // Membership & Dues State
  late final Rx<MembershipStatus> membershipStatus;
  final selectedTierKey = 'GOLD_PATRON'.obs;
  final selectedBillingCycle = 'ANNUAL'.obs; // 'ANNUAL' or 'LIFETIME'
  final isUpdatingDues = false.obs;

  // History & Public Feed
  final myDonations = <DonationRecord>[].obs;
  final recentDonations = <DonationRecord>[].obs;
  final isLoadingData = false.obs;

  // Campaign Metrics
  final campaignGoal = 250000.0;
  final campaignRaised = 185450.0;

  UserModel get user =>
      _authStorage.user ??
      UserModel(
        id: 'usr_pranab',
        fullName: 'Pranabesh Sarkar',
        email: 'pranabesh.sarkar@alumni.ipam.edu',
        phone: '+232 76 998 877',
        graduationYear: 2020,
        degree: 'B.Sc',
        isVerified: true,
      );

  double get totalLifetimeGiven {
    final donationsSum = myDonations.fold<double>(
      0.0,
      (sum, item) => sum + item.amount,
    );
    final duesPaid = membershipStatus.value.annualDuesPaid.toDouble();
    return donationsSum + duesPaid;
  }

  @override
  void onInit() {
    super.onInit();
    membershipStatus = MembershipStatus.sampleActivePatron().obs;
    loadAllData();
  }

  @override
  void onClose() {
    customAmountController.dispose();
    messageController.dispose();
    super.onClose();
  }

  Future<void> loadAllData() async {
    isLoadingData.value = true;
    try {
      final results = await Future.wait([
        _provider.fetchMyDonations(),
        _provider.fetchRecentDonations(),
        _provider.fetchMembershipStatus(),
      ]);

      myDonations.assignAll(results[0] as List<DonationRecord>);
      recentDonations.assignAll(results[1] as List<DonationRecord>);
      membershipStatus.value = results[2] as MembershipStatus;
    } catch (_) {
      myDonations.assignAll(DonationRecord.sampleDonations());
      recentDonations.assignAll(DonationRecord.sampleDonations());
    } finally {
      isLoadingData.value = false;
    }
  }

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  void selectAmountPreset(double amount) {
    isCustomAmount.value = false;
    selectedAmount.value = amount;
    customAmountController.clear();
  }

  void setCustomAmount(String value) {
    isCustomAmount.value = true;
    final parsed = double.tryParse(value);
    if (parsed != null && parsed > 0) {
      selectedAmount.value = parsed;
    }
  }

  /// Submits donation with API integration
  Future<void> submitDonation() async {
    final amountToDonate = selectedAmount.value;
    if (amountToDonate <= 0) {
      Get.snackbar(
        'Invalid Amount',
        'Please enter a valid gift amount greater than 0.',
        backgroundColor: Colors.red.shade900,
        colorText: Colors.white,
      );
      return;
    }

    isSubmittingDonation.value = true;
    try {
      final record = await _provider.submitDonation(
        donorName: user.fullName,
        donorEmail: user.email,
        donorPhone: user.phone ?? '+232 76 100 200',
        amount: amountToDonate,
        fund: selectedFund.value,
        currency: 'USD',
        frequency: selectedFrequency.value,
        paymentMethod: selectedPaymentMethod.value,
        isAnonymous: isAnonymous.value,
        message: messageController.text.trim().isNotEmpty
            ? messageController.text.trim()
            : null,
      );

      // Prepend to personal and recent lists
      myDonations.insert(0, record);
      recentDonations.insert(0, record);

      messageController.clear();
      _showDonationSuccessDialog(record);
    } catch (e) {
      Get.snackbar(
        'Donation Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red.shade900,
        colorText: Colors.white,
      );
    } finally {
      isSubmittingDonation.value = false;
    }
  }

  /// Upgrades or Renews Membership Dues
  Future<void> upgradeMembership(MembershipTierInfo tier) async {
    isUpdatingDues.value = true;
    try {
      final success = await _provider.upgradeMembershipTier(
        tier: tier.key,
        billingCycle: selectedBillingCycle.value,
        paymentMethod: selectedPaymentMethod.value,
      );

      if (success) {
        final current = membershipStatus.value;
        membershipStatus.value = MembershipStatus(
          currentTier: tier.key,
          status: 'ACTIVE',
          startDate: DateTime.now(),
          validUntil: selectedBillingCycle.value == 'LIFETIME'
              ? DateTime(2099, 1, 1)
              : DateTime.now().add(const Duration(days: 365)),
          autoRenew: current.autoRenew,
          annualDuesPaid: selectedBillingCycle.value == 'LIFETIME'
              ? tier.lifetimePrice
              : tier.annualPrice,
          availableTiers: current.availableTiers,
        );

        Get.snackbar(
          'Membership Confirmed',
          'Successfully upgraded to ${tier.name}. Tier privileges are now active.',
          backgroundColor: AppColors.emeraldDarker,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } finally {
      isUpdatingDues.value = false;
    }
  }

  /// Toggles automatic annual dues renewal
  Future<void> toggleAutoRenew(bool enable) async {
    final updated = await _provider.toggleAutoRenew(enable);
    final cur = membershipStatus.value;
    membershipStatus.value = MembershipStatus(
      currentTier: cur.currentTier,
      status: cur.status,
      startDate: cur.startDate,
      validUntil: cur.validUntil,
      autoRenew: updated,
      annualDuesPaid: cur.annualDuesPaid,
      availableTiers: cur.availableTiers,
    );

    Get.snackbar(
      'Renewal Preference',
      updated ? 'Auto-renew enabled for annual dues.' : 'Auto-renew disabled.',
      backgroundColor: AppColors.emeraldDarker,
      colorText: Colors.white,
    );
  }

  void _showDonationSuccessDialog(DonationRecord record) {
    Get.dialog(
      Builder(builder: (context) {
        final isDark = AppColors.isDark(context);
        return Dialog(
          backgroundColor: AppColors.card(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: AppColors.tealPillBg(context),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.volunteer_activism_rounded,
                      color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Thank You for Your Generosity!',
                  style: GoogleFonts.libreCaslonText(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your gift of \$${record.amount.toStringAsFixed(0)} to the ${record.fund} has been officially recorded.',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: AppColors.textSecondary(context),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reference ID',
                        style: GoogleFonts.manrope(fontSize: 12, color: AppColors.textSecondary(context)),
                      ),
                      Text(
                        record.paymentRef ?? 'DON-2026-9812',
                        style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary(context)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emeraldDarker,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Get.back();
                      selectTab(2); // Jump to My Ledger tab to view the gift
                    },
                    child: const Text('View Giving Ledger', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
