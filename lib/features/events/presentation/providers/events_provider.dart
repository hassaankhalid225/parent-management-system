import 'package:flutter/material.dart';
import 'package:pms/features/events/data/models/event_model.dart';
import 'package:pms/features/events/data/repositories/events_repository.dart';
import 'package:pms/core/network/api_error_handler.dart';

class EventsProvider extends ChangeNotifier {
  EventsRepository _eventsRepository;
  List<EventModel> _events = [];
  bool _isLoading = false;
  String? _errorMessage;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  EventsProvider(this._eventsRepository);

  void updateRepo(EventsRepository repo) {
    _eventsRepository = repo;
  }

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;

  // Filtered events
  List<EventModel> get selectedDayEvents {
    return _events.where((event) => 
      DateUtils.isSameDay(event.date, _selectedDay)
    ).toList();
  }

  // Get events for a specific day (used by calendar markers)
  List<EventModel> getEventsForDay(DateTime day) {
    return _events.where((event) => 
      DateUtils.isSameDay(event.date, day)
    ).toList();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    notifyListeners();
  }

  Future<void> loadEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _events = await _eventsRepository.getEvents();
    } catch (e) {
      _errorMessage = ApiErrorHandler.handleErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRsvp(String eventId, RsvpStatus status) async {
    try {
      await _eventsRepository.updateRsvp(eventId, status);
      
      final index = _events.indexWhere((e) => e.id == eventId);
      if (index != -1) {
        _events[index] = _events[index].copyWith(rsvpStatus: status);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = ApiErrorHandler.handleErrorMessage(e);
      notifyListeners();
    }
  }
}
