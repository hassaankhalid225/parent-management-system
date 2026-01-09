import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:pms/core/constants/app_strings.dart';
import 'package:pms/core/constants/app_theme.dart';
import 'package:pms/shared/widgets/feedback/loading_indicator.dart';
import 'package:pms/shared/widgets/feedback/empty_state_widget.dart';
import 'package:pms/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:pms/features/diary/presentation/providers/diary_provider.dart';
import 'package:pms/features/diary/data/models/diary_entry_model.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final dashboardProvider = context.read<DashboardProvider>();
    final childId = dashboardProvider.selectedChild?.id;
    if (childId != null) {
      context.read<DiaryProvider>().loadDiaryForDate(childId, DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dailyDiary),
        centerTitle: true,
      ),
      body: Consumer2<DiaryProvider, DashboardProvider>(
        builder: (context, diaryProvider, dashboardProvider, _) {
          if (diaryProvider.isLoading) {
            return const LoadingIndicator(message: 'Loading diary...');
          }

          final entry = diaryProvider.currentEntry;
          if (entry == null) {
            return EmptyStateWidget(
              title: 'No Entry',
              message: 'No diary record for ${DateFormat('MMM dd, yyyy').format(diaryProvider.selectedDate)}.',
              icon: Icons.event_busy,
              actionButtonText: 'Check Today',
              onActionPressed: () {
                final childId = dashboardProvider.selectedChild?.id;
                if (childId != null) {
                  diaryProvider.loadDiaryForDate(childId, DateTime.now());
                }
              },
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final childId = dashboardProvider.selectedChild?.id;
              if (childId != null) {
                await diaryProvider.loadDiaryForDate(childId, diaryProvider.selectedDate);
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.medium),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Date Header
                  _buildDateHeader(diaryProvider.selectedDate),
                  const SizedBox(height: AppTheme.large),

                  // Diary Table
                  _buildDiaryTable(entry),
                  const SizedBox(height: AppTheme.large),

                  // Teacher's Note
                  if (entry.teacherNote != null && entry.teacherNote!.isNotEmpty)
                    _buildTeacherNote(entry),
                  
                  const SizedBox(height: AppTheme.extraLarge),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _navigateDate(-1),
            ),
            Column(
              children: [
                Text(
                  DateFormat('EEEE').format(date),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Text(
                  DateFormat('MMMM dd, yyyy').format(date),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => _navigateDate(1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiaryTable(DiaryEntryModel entry) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
          },
          border: TableBorder.all(
            color: theme.dividerColor.withValues(alpha: 0.5),
            width: 1,
          ),
          children: [
            // Table Header
            TableRow(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Subject',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Diary Content',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            // Activity Rows
            ...entry.activities.map((activity) {
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      activity.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(activity.description),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherNote(DiaryEntryModel entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            'Teacher\'s Note',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.teacherNote ?? '',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '- ${entry.teacherName ?? "Class Teacher"}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateDate(int days) {
    final provider = context.read<DiaryProvider>();
    final newDate = provider.selectedDate.add(Duration(days: days));
    if (newDate.isAfter(DateTime.now())) return;
    
    final childId = context.read<DashboardProvider>().selectedChild?.id;
    if (childId != null) {
      provider.loadDiaryForDate(childId, newDate);
    }
  }
}
