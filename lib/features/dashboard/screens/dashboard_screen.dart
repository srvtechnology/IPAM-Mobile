import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/dashboard_controller.dart';
import '../../home/screens/home_screen.dart';
import '../../directory/screens/directory_screen.dart';
import '../../careers/screens/careers_screen.dart';
import '../../events/screens/events_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../../core/theme/app_colors.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeScreen(),
      const DirectoryScreen(),
      const CareersScreen(),
      const EventsScreen(),
      const ProfileScreen(),
    ];

    final isDark = AppColors.isDark(context);
    final navBg = isDark ? const Color(0xFF0B1120) : Colors.white;
    final navBorder = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final selectedColor = isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep;
    const unselectedColor = Color(0xFF64748B);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: navBg,
            border: Border(
              top: BorderSide(
                color: navBorder,
                width: 1.0,
              ),
            ),
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: navBg,
              indicatorColor: Colors.transparent,
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: selectedColor,
                  );
                }
                return GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: unselectedColor,
                );
              }),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return IconThemeData(
                    color: selectedColor,
                    size: 24,
                  );
                }
                return const IconThemeData(
                  color: unselectedColor,
                  size: 24,
                );
              }),
            ),
            child: NavigationBar(
              selectedIndex: controller.currentIndex.value,
              onDestinationSelected: controller.changeTab,
              height: 68,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline_rounded),
                  selectedIcon: Icon(Icons.people_alt_rounded),
                  label: 'Directory',
                ),
                NavigationDestination(
                  icon: Icon(Icons.business_center_outlined),
                  selectedIcon: Icon(Icons.business_center_rounded),
                  label: 'Careers',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_month_outlined),
                  selectedIcon: Icon(Icons.calendar_month_rounded),
                  label: 'Events',
                ),
                NavigationDestination(
                  icon: Icon(Icons.badge_outlined),
                  selectedIcon: Icon(Icons.badge_rounded),
                  label: 'ID & Pass',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
