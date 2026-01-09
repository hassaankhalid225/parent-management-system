import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pms/core/constants/app_colors.dart';
import 'package:pms/core/constants/app_strings.dart';
import 'package:pms/core/constants/app_theme.dart';
import 'package:pms/shared/widgets/cards/stats_card.dart';
import 'package:pms/shared/widgets/feedback/loading_indicator.dart';
import 'package:pms/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:pms/features/dashboard/presentation/widgets/child_selector_card.dart';
import 'package:pms/features/diary/presentation/pages/diary_page.dart';
import 'package:pms/features/fees/presentation/pages/fees_page.dart';
import 'package:pms/features/events/presentation/pages/events_page.dart';
import 'package:pms/features/profile/presentation/pages/profile_page.dart';
import 'package:pms/features/notifications/presentation/pages/notifications_page.dart';
import 'package:pms/features/notifications/presentation/providers/notification_provider.dart';
import 'package:pms/shared/providers/theme_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardHomeScreen(),
    DiaryPage(),
    FeesPage(),
    EventsPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadDashboardData();
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: AppStrings.dashboard,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: AppStrings.dailyDiary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined),
            activeIcon: Icon(Icons.receipt),
            label: 'Fees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardHomeScreen extends StatelessWidget {
  const DashboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<DashboardProvider>(
          builder: (context, dashboardProvider, _) {
            final child = dashboardProvider.selectedChild;
            return Text(
              '${AppStrings.hello}, ${child?.fullName.split(' ').first ?? 'Parent'}!',
            );
          },
        ),
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, _) => IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.notifications_outlined),
                  if (notificationProvider.unreadCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.lightError,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${notificationProvider.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsPage()),
                );
              },
            ),
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => IconButton(
              icon: Icon(
                themeProvider.themeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () {
                themeProvider.setThemeMode(
                  themeProvider.themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark,
                );
              },
            ),
          ),
        ],
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, dashboardProvider, _) {
          if (dashboardProvider.isLoading) {
            return const LoadingIndicator(
              message: 'Loading dashboard...',
            );
          }

          if (dashboardProvider.children.isEmpty) {
            return const Center(
              child: Text('No children found'),
            );
          }

          return RefreshIndicator(
            onRefresh: dashboardProvider.refreshDashboard,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppTheme.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Child Selector
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: dashboardProvider.children.length + 1,
                      itemBuilder: (context, index) {
                        if (index == dashboardProvider.children.length) {
                          return _buildAddChildCard(context);
                        }

                        final child = dashboardProvider.children[index];
                        return ChildSelectorCard(
                          child: child,
                          isSelected:
                              index == dashboardProvider.selectedChildIndex,
                          onTap: () {
                            dashboardProvider.selectChild(index);
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: AppTheme.large),

                  // Quick Stats Grid
                  Text(
                    AppStrings.quickStats,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  const SizedBox(height: AppTheme.medium),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: AppTheme.medium,
                    mainAxisSpacing: AppTheme.medium,
                    childAspectRatio: 1.1,
                    children: [
                      StatsCard(
                        title: AppStrings.attendance,
                        value: '${dashboardProvider.selectedChild?.attendancePercentage.toStringAsFixed(0)}%',
                        subtitle:
                            '${dashboardProvider.selectedChild?.presentDays}/${dashboardProvider.selectedChild?.totalDays} ${AppStrings.daysPresent}',
                        icon: Icons.calendar_today,
                        gradientColors: AppColors.successGradient,
                        onTap: () {
                          // TODO: Navigate to attendance details
                        },
                      ),
                      StatsCard(
                        title: AppStrings.feeStatus,
                        value: dashboardProvider.selectedChild?.pendingFees == 0
                            ? AppStrings.paid
                            : '₨${dashboardProvider.selectedChild?.pendingFees.toStringAsFixed(0)}',
                        subtitle: dashboardProvider.selectedChild?.pendingFees ==
                                0
                            ? 'All fees paid'
                            : '${AppStrings.nextDue}: Jan 15',
                        icon: Icons.account_balance_wallet,
                        gradientColors: dashboardProvider.selectedChild
                                    ?.pendingFees ==
                                0
                            ? AppColors.successGradient
                            : AppColors.warningGradient,
                        onTap: () {
                          // TODO: Navigate to fees
                        },
                      ),
                      StatsCard(
                        title: AppStrings.todaysDiary,
                        value: '3 Updates',
                        subtitle: '${AppStrings.lastUpdated}: 2h ago',
                        icon: Icons.book,
                        gradientColors: AppColors.infoGradient,
                        onTap: () {
                          // TODO: Navigate to diary
                        },
                      ),
                      StatsCard(
                        title: AppStrings.upcomingEvents,
                        value: '2 Events',
                        subtitle: '${AppStrings.nextEvent}: Sports Day',
                        icon: Icons.event,
                        gradientColors: AppColors.secondaryGradient,
                        onTap: () {
                          // TODO: Navigate to events
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.large),

                  // Today's Activities Preview
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          AppStrings.todaysActivities,
                          style: Theme.of(context).textTheme.headlineSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to diary
                        },
                        child: const Text(AppStrings.viewAll),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.medium),

                  _buildActivityPreview(context),

                  const SizedBox(height: AppTheme.large),

                  // Recent Announcements
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          AppStrings.recentAnnouncements,
                          style: Theme.of(context).textTheme.headlineSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to notifications
                        },
                        child: const Text(AppStrings.seeAllNotifications),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.medium),

                  _buildAnnouncementCard(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddChildCard(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: AppTheme.medium),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Add child functionality
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppTheme.small),
            Text(
              'Add Child',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityPreview(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.medium),
        child: Column(
          children: [
            _buildActivityItem(
              context,
              '10:30 AM',
              'Lunch Time',
              'Ate well and enjoyed the meal',
              Icons.restaurant,
              AppColors.mealColor,
            ),
            const Divider(),
            _buildActivityItem(
              context,
              '2:00 PM',
              'Play Time',
              'Played with friends in the playground',
              Icons.sports_soccer,
              AppColors.playColor,
            ),
            const Divider(),
            _buildActivityItem(
              context,
              '3:30 PM',
              'Study Time',
              'Completed math homework',
              Icons.book,
              AppColors.studyColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String time,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.small),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: AppTheme.medium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    time,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: AppTheme.small),
                  Text(
                    '•',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: AppTheme.small),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.extraSmall),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnnouncementCard(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppTheme.small),
          decoration: BoxDecoration(
            color: AppColors.lightInfo.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: const Icon(
            Icons.campaign,
            color: AppColors.lightInfo,
          ),
        ),
        title: const Text('School Closed Tomorrow'),
        subtitle: const Text('Due to public holiday • 2 hours ago'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.small,
            vertical: AppTheme.extraSmall,
          ),
          decoration: BoxDecoration(
            color: AppColors.lightError.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: const Text(
            'Important',
            style: TextStyle(
              color: AppColors.lightError,
              fontSize: AppTheme.fontSizeCaption,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
