import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pms/core/constants/app_colors.dart';
import 'package:pms/core/constants/app_theme.dart';
import 'package:pms/features/events/data/models/event_model.dart';
import 'package:pms/features/events/presentation/providers/events_provider.dart';
import 'package:pms/shared/widgets/feedback/loading_indicator.dart';
import 'package:pms/shared/widgets/feedback/empty_state_widget.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventsProvider>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events & Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<EventsProvider>().loadEvents(),
          ),
        ],
      ),
      body: Consumer<EventsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingIndicator(message: 'Loading events...');
          }

          if (provider.errorMessage != null) {
            return EmptyStateWidget(
              icon: Icons.error_outline,
              title: 'Error',
              message: provider.errorMessage!,
              actionButtonText: 'Retry',
              onActionPressed: () => provider.loadEvents(),
            );
          }

          return Column(
            children: [
              _buildCalendar(provider),
              const Divider(height: 1),
              _buildHeader(provider),
              Expanded(
                child: _buildEventList(provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalendar(EventsProvider provider) {
    return Card(
      margin: const EdgeInsets.all(AppTheme.medium),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: TableCalendar<EventModel>(
        firstDay: DateTime.utc(2023, 1, 1),
        lastDay: DateTime.utc(2026, 12, 31),
        focusedDay: provider.focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(provider.selectedDay, day),
        onDaySelected: provider.onDaySelected,
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        eventLoader: provider.getEventsForDay,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          markerDecoration: const BoxDecoration(
            color: AppColors.lightPrimary,
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: AppColors.lightPrimary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppColors.lightPrimary.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonDecoration: BoxDecoration(
            color: AppColors.lightPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          formatButtonTextStyle: const TextStyle(color: AppColors.lightPrimary),
        ),
      ),
    );
  }

  Widget _buildHeader(EventsProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppTheme.medium, AppTheme.medium, AppTheme.medium, AppTheme.small),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Events for ${_formatDate(provider.selectedDay)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (provider.selectedDayEvents.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.lightPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Text(
                '${provider.selectedDayEvents.length} Items',
                style: const TextStyle(
                  color: AppColors.lightPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEventList(EventsProvider provider) {
    final events = provider.selectedDayEvents;

    if (events.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppTheme.large),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event_busy, size: 48, color: Colors.grey),
              SizedBox(height: AppTheme.medium),
              Text(
                'No events scheduled for this day.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.medium),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _buildEventCard(events[index]);
      },
    );
  }

  Widget _buildEventCard(EventModel event) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.medium),
      child: InkWell(
        onTap: () => _showEventDetails(event),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.medium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.small),
                decoration: BoxDecoration(
                  color: _getEventTypeColor(event.type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Icon(
                  _getEventTypeIcon(event.type),
                  color: _getEventTypeColor(event.type),
                ),
              ),
              const SizedBox(width: AppTheme.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          event.startTime != null 
                              ? '${event.startTime} - ${event.endTime}' 
                              : 'All Day',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (event.isRsvpRequired) ...[
                      const SizedBox(height: AppTheme.small),
                      _buildRsvpBadge(event),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRsvpBadge(EventModel event) {
    String label = "RSVP Requested";
    Color color = AppColors.lightInfo;
    
    if (event.rsvpStatus == RsvpStatus.going) {
      label = "You are going";
      color = AppColors.lightSuccess;
    } else if (event.rsvpStatus == RsvpStatus.notGoing) {
      label = "Not going";
      color = AppColors.lightError;
    } else if (event.rsvpStatus == RsvpStatus.maybe) {
      label = "Maybe going";
      color = AppColors.lightWarning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showEventDetails(EventModel event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(AppTheme.large),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.large),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppTheme.medium),
                        decoration: BoxDecoration(
                          color: _getEventTypeColor(event.type).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getEventTypeIcon(event.type),
                          color: _getEventTypeColor(event.type),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: AppTheme.medium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.type.toString().split('.').last.toUpperCase(),
                              style: TextStyle(
                                color: _getEventTypeColor(event.type),
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              event.title,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.large),
                  _buildDetailRow(Icons.calendar_today, "Date", _formatDate(event.date)),
                  _buildDetailRow(Icons.access_time, "Time", event.startTime != null ? "${event.startTime} - ${event.endTime}" : "All Day"),
                  _buildDetailRow(Icons.location_on_outlined, "Location", event.location),
                  if (event.organizer != null)
                    _buildDetailRow(Icons.person_outline, "Organizer", event.organizer!),
                  const SizedBox(height: AppTheme.large),
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppTheme.small),
                  Text(
                    event.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (event.isRsvpRequired) ...[
                    const SizedBox(height: AppTheme.extraLarge),
                    Text(
                      "Will you attend?",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppTheme.medium),
                    Consumer<EventsProvider>(
                      builder: (context, provider, _) {
                        return Row(
                          children: [
                            _buildRsvpButton(
                              context,
                              "Going",
                              Icons.check_circle_outline,
                              RsvpStatus.going,
                              event,
                              provider,
                            ),
                            const SizedBox(width: AppTheme.small),
                            _buildRsvpButton(
                              context,
                              "Maybe",
                              Icons.help_outline,
                              RsvpStatus.maybe,
                              event,
                              provider,
                            ),
                            const SizedBox(width: AppTheme.small),
                            _buildRsvpButton(
                              context,
                              "Not Going",
                              Icons.cancel_outlined,
                              RsvpStatus.notGoing,
                              event,
                              provider,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: AppTheme.extraLarge),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRsvpButton(
    BuildContext context,
    String label,
    IconData icon,
    RsvpStatus status,
    EventModel event,
    EventsProvider provider,
  ) {
    bool isSelected = event.rsvpStatus == status;
    Color color = AppColors.lightPrimary;
    if (status == RsvpStatus.notGoing) color = AppColors.lightError;
    if (status == RsvpStatus.maybe) color = AppColors.lightWarning;

    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          provider.updateRsvp(event.id, status);
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? color.withValues(alpha: 0.1) : null,
          side: BorderSide(color: isSelected ? color : Colors.grey[300]!),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.medium),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: AppTheme.medium),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelSmall),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  Color _getEventTypeColor(EventType type) {
    switch (type) {
      case EventType.holiday: return AppColors.lightError;
      case EventType.academic: return AppColors.lightPrimary;
      case EventType.sports: return AppColors.lightSuccess;
      case EventType.cultural: return AppColors.lightWarning;
      case EventType.meeting: return AppColors.lightInfo;
      case EventType.other: return Colors.grey;
    }
  }

  IconData _getEventTypeIcon(EventType type) {
    switch (type) {
      case EventType.holiday: return Icons.beach_access;
      case EventType.academic: return Icons.school;
      case EventType.sports: return Icons.sports_basketball;
      case EventType.cultural: return Icons.palette;
      case EventType.meeting: return Icons.groups;
      case EventType.other: return Icons.event;
    }
  }
}
