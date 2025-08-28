import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/spacers/spacers.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';
import 'package:kenic/features/onboarding/controllers/onboarding_controller.dart';
import 'package:kenic/features/onboarding/routes/onboarding_routes.dart';
import 'package:kenic/core/utils/widgets/custom_dialogs.dart';
import 'package:kenic/features/profile/views/contact_info_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<OnboardingController>();
    final user = authController.user;

    return Scaffold(
      backgroundColor: AppPallete.kenicWhite,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppPallete.kenicWhite,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppPallete.kenicRed.withOpacity(0.1),
                      AppPallete.kenicWhite,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      spaceH40,
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppPallete.kenicRed,
                              AppPallete.kenicRed.withOpacity(0.8),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child:
                              user?.name.isNotEmpty == true
                                  ? Inter(
                                    text: user!.name[0].toUpperCase(),
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    textColor: AppPallete.kenicWhite,
                                  )
                                  : const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: AppPallete.kenicWhite,
                                  ),
                        ),
                      ),
                      spaceH15,
                      Inter(
                        text: user?.name ?? 'Guest User',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        textColor: AppPallete.kenicBlack,
                      ),
                      Inter(
                        text: user?.email ?? 'No email provided',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        textColor: AppPallete.greyColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildProfileSection('Account Settings', [
                    _buildProfileItem(
                      icon: HeroIcons.user,
                      title: 'Personal Information',
                      subtitle: 'Update your profile details',
                      onTap: () {},
                    ),
                    _buildProfileItem(
                      icon: HeroIcons.key,
                      title: 'Change Password',
                      subtitle: 'Update your password',
                      onTap: () => Get.toNamed(OnboardingRoutes.changePassword),
                    ),
                  ]),
                  spaceH30,
                  _buildProfileSection('Support', [
                    _buildProfileItem(
                      icon: HeroIcons.questionMarkCircle,
                      title: 'Help Center',
                      subtitle: 'Get help and support',
                      onTap: () {},
                    ),
                    _buildProfileItem(
                      icon: HeroIcons.chatBubbleLeftRight,
                      title: 'Contact Us',
                      subtitle: 'Reach out to our support team',
                      onTap: () => Get.to(() => const ContactInfoPage()),
                    ),
                    _buildProfileItem(
                      icon: HeroIcons.documentText,
                      title: 'Terms & Privacy',
                      subtitle: 'Read our terms and privacy policy',
                      onTap: () {},
                    ),
                  ]),
                  spaceH30,
                  _buildProfileSection('App', [
                    _buildProfileItem(
                      icon: HeroIcons.informationCircle,
                      title: 'About',
                      subtitle: 'App version and information',
                      onTap: () {},
                      trailing: Inter(
                        text: 'v1.0.0',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: AppPallete.greyColor,
                      ),
                    ),
                    _buildProfileItem(
                      icon: HeroIcons.arrowRightOnRectangle,
                      title: 'Sign Out',
                      subtitle: 'Sign out of your account',
                      onTap: () => CustomDialogs.showLogoutDialog(context),
                      isDestructive: true,
                    ),
                    _buildProfileItem(
                      icon: HeroIcons.trash,
                      title: 'Delete Account',
                      subtitle: 'Permanently delete your account',
                      onTap:
                          () => CustomDialogs.showDeleteAccountDialog(context),
                      isDestructive: true,
                    ),
                  ]),
                  spaceH40,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Inter(
            text: title,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            textColor: AppPallete.kenicBlack,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppPallete.kenicWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildProfileItem({
    required HeroIcons icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              isDestructive
                  ? Colors.red.withOpacity(0.1)
                  : AppPallete.kenicRed.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: HeroIcon(
          icon,
          size: 20,
          color: isDestructive ? Colors.red : AppPallete.kenicRed,
        ),
      ),
      title: Inter(
        text: title,
        textAlignment: TextAlign.left,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        textColor: isDestructive ? Colors.red : AppPallete.kenicBlack,
      ),
      subtitle: Inter(
        text: subtitle,
        textAlignment: TextAlign.left,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        textColor: AppPallete.greyColor,
      ),
      trailing:
          trailing ??
          const HeroIcon(
            HeroIcons.chevronRight,
            size: 16,
            color: AppPallete.greyColor,
          ),
      onTap: onTap,
    );
  }

  // Dialogs moved to CustomDialogs class
}
