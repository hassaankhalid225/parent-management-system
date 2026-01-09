import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/routes/app_router.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../../../shared/providers/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.currentUser;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.medium),
            child: Column(
              children: [
                // Premium Profile Header
                _buildProfileHeader(context, user),
                const SizedBox(height: AppTheme.large),

                // Account Settings
                _buildSettingsSection(
                  context,
                  AppStrings.accountSettings,
                  [
                    _buildSettingsTile(
                      context,
                      Icons.person_outline_rounded,
                      'Edit Profile',
                      () => _showComingSoon(context, 'Edit Profile'),
                    ),
                    _buildSettingsTile(
                      context,
                      Icons.lock_outline_rounded,
                      AppStrings.changePassword,
                      () => _showComingSoon(context, 'Change Password'),
                    ),
                    _buildSettingsTile(
                      context,
                      Icons.phone_outlined,
                      AppStrings.updateContactInfo,
                      () => _showComingSoon(context, 'Update Contact Info'),
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.medium),

                // Notifications
                _buildSettingsSection(
                  context,
                  AppStrings.notificationSettings,
                  [
                    _buildSettingsTile(
                      context,
                      Icons.notifications_active_outlined,
                      AppStrings.pushNotifications,
                      () {},
                      trailing: Switch(
                        value: _pushNotifications,
                        onChanged: (value) => setState(() => _pushNotifications = value),
                      ),
                    ),
                    _buildSettingsTile(
                      context,
                      Icons.mail_outline_rounded,
                      AppStrings.emailNotifications,
                      () {},
                      trailing: Switch(
                        value: _emailNotifications,
                        onChanged: (value) => setState(() => _emailNotifications = value),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.medium),

                // Appearance
                _buildSettingsSection(
                  context,
                  AppStrings.appearance,
                  [
                    _buildSettingsTile(
                      context,
                      Icons.palette_outlined,
                      'App Theme',
                      () {},
                      trailing: Consumer<ThemeProvider>(
                        builder: (context, themeProvider, _) {
                          return DropdownButton<ThemeMode>(
                            value: themeProvider.themeMode,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down_rounded),
                            onChanged: (mode) {
                              if (mode != null) {
                                themeProvider.setThemeMode(mode);
                              }
                            },
                            items: const [
                              DropdownMenuItem(
                                value: ThemeMode.system,
                                child: Text('System'),
                              ),
                              DropdownMenuItem(
                                value: ThemeMode.light,
                                child: Text('Light'),
                              ),
                              DropdownMenuItem(
                                value: ThemeMode.dark,
                                child: Text('Dark'),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.medium),

                // Support & About
                _buildSettingsSection(
                  context,
                  AppStrings.about,
                  [
                    _buildSettingsTile(
                      context,
                      Icons.help_outline_rounded,
                      AppStrings.helpSupport,
                      () => _showComingSoon(context, 'Help & Support'),
                    ),
                    _buildSettingsTile(
                      context,
                      Icons.policy_outlined,
                      AppStrings.privacyPolicy,
                      () => _showComingSoon(context, 'Privacy Policy'),
                    ),
                    _buildSettingsTile(
                      context,
                      Icons.info_outline_rounded,
                      'App Version',
                      () {},
                      trailing: const Text(
                        'v1.0.2',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.extraLarge),
                
                // Red Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.small),
                  child: OutlinedButton.icon(
                    onPressed: () => _handleLogout(context),
                    icon: const Icon(Icons.logout_rounded, color: Colors.red),
                    label: const Text(
                      AppStrings.logout,
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.large),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic user) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.large),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusExtraLarge),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.surface,
                  backgroundImage: user?.profilePictureUrl != null
                      ? NetworkImage(user!.profilePictureUrl!)
                      : null,
                  child: user?.profilePictureUrl == null
                      ? Icon(Icons.person, size: 50, color: theme.colorScheme.primary)
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.medium),
          Text(
            user?.fullName ?? 'Parent Name',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? 'parent@school.com',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: AppTheme.medium),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_user_rounded, 
                     size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Verified Parent',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            side: BorderSide(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: onTap,
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.logout),
        content: const Text(AppStrings.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.logout();
      if (mounted) {
        context.go(AppRoutes.login);
      }
    }
  }
}
