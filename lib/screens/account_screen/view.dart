import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                            // TODO: Implement profile navigation
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
                                onTap: controller.addPaymentMethod,
                              ),
                              const SizedBox(height: 12),
                              const _AccountActionTile(
                                icon: Icons.directions_car,
                                label: 'My Car',
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
                              const _AccountActionTile(
                                icon: Icons.privacy_tip_outlined,
                                label: 'Privacy Policy',
                              ),
                              const SizedBox(height: 12),
                              const _AccountActionTile(
                                icon: Icons.description_outlined,
                                label: 'Terms & Conditions',
                              ),
                              const SizedBox(height: 28),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // TODO: Implement logout
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE74C3C),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  // TODO: Implement account deletion
                                },
                                child: const Text(
                                  'Delete Account',
                                  style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Renergy Version 1.0.7 (9)',
                                style: TextStyle(
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: onProfileTap,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          const SizedBox(height: 24),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Tuan Hee Teo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Output (kWh)',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
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
              children: const [
                _AccountMetric(
                  label: 'Output (kWh)',
                  value: '0',
                ),
                _MetricDivider(),
                _AccountMetric(
                  label: 'Total Duration (h)',
                  value: '0',
                ),
                _MetricDivider(),
                _AccountMetric(
                  label: 'CO2 (g)',
                  value: '0',
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
    return Material(
      color: const Color(0xFFF7F7F7),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFFE60012),
              ),
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
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF999999),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
