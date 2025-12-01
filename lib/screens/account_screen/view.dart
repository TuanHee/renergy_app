import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/components/components.dart';
import 'package:renergy_app/screens/account_screen/account_screen.dart';

class AccountScreenView extends StatelessWidget {
  const AccountScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Account'),
            centerTitle: true,
          ),
          body: controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _AccountHeader(
                          onProfileTap: () {
                            Get.toNamed(AppRoutes.editProfile);
                          },
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              _AccountActionTile(
                                icon: Icons.credit_card,
                                label: 'Payment Method',
                                onTap: () {
                                  Get.toNamed(AppRoutes.card);
                                },
                              ),
                              const SizedBox(height: 12),
                              _AccountActionTile(
                                icon: Icons.directions_car,
                                label: 'My Car',
                                onTap: () {
                                  Get.toNamed(AppRoutes.car);
                                },
                              ),
                              const SizedBox(height: 12),
                              const _AccountActionTile(
                                icon: Icons.assignment,
                                label: 'Report History',
                              ),
                              const SizedBox(height: 12),
                              const _AccountActionTile(
                                icon: Icons.support_agent,
                                label: 'Get Help',
                              ),
                              const SizedBox(height: 12),
                              const _AccountActionTile(
                                icon: Icons.help_outline,
                                label: 'FAQ',
                              ),
                              const SizedBox(height: 12),
                              _AccountActionTile(
                                icon: Icons.privacy_tip_outlined,
                                label: 'Privacy Policy',
                                onTap: () => Get.toNamed(AppRoutes.privacy),
                              ),
                              const SizedBox(height: 12),
                              _AccountActionTile(
                                icon: Icons.description_outlined,
                                label: 'Terms & Conditions',
                                onTap: () => Get.toNamed(AppRoutes.terms),
                              ),
                              const SizedBox(height: 28),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    controller.logout();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    side: BorderSide(color: Colors.grey.shade300),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Logout',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // TextButton(
                              //   onPressed: () {},
                              //   child: const Text(
                              //     'Delete Account',
                              //     style: TextStyle(
                              //       color: Color(0xFF666666),
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(height: 24),
                              Text(
                                'Renergy Version ${controller.appVersion}',
                                style: const TextStyle(
                                  color: Color(0xFF999999),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: const MainBottomNavBar(
            currentIndex: 3,
          ),
        );
      },
    );
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({
    required this.onProfileTap,
  });

  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountController>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xFFE60012),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: Color(0xFFE60012),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${controller.customer?.name ?? 'User'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: onProfileTap,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'My Profile',
                  style: TextStyle(
                    color: Color(0xFFE60012),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AccountMetric(
                  label: 'Output (kWh)',
                  value: '${controller.customer?.totalCharging ?? 0}',
                ),
                _MetricDivider(),
                _AccountMetric(
                  label: 'Total Duration (h)',
                  value: '${controller.customer?.totalDuration ?? 0}',
                ),
                _MetricDivider(),
                _AccountMetric(
                  label: 'CO2 (g)',
                  value:  '${controller.customer?.totalC02 ?? 0}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountMetric extends StatelessWidget {
  const _AccountMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _MetricDivider extends StatelessWidget {
  const _MetricDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white24,
    );
  }
}

class _AccountActionTile extends StatelessWidget {
  const _AccountActionTile({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF333333)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF999999)),
            ],
          ),
        ),
      ),
    );
  }
}
