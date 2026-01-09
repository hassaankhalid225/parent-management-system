import 'package:flutter/material.dart';
import 'package:pms/features/diary/data/models/diary_entry_model.dart';
import 'package:pms/features/diary/data/repositories/diary_repository.dart';
import 'package:pms/core/network/api_error_handler.dart';

class DiaryProvider extends ChangeNotifier {
  DiaryRepository _diaryRepository;
  DiaryEntryModel? _currentEntry;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String? _errorMessage;

  DiaryProvider(this._diaryRepository);

  void updateRepo(DiaryRepository repo) {
    _diaryRepository = repo;
  }

  DiaryEntryModel? get currentEntry => _currentEntry;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadDiaryForDate(String childId, DateTime date) async {
    _isLoading = true;
    _selectedDate = date;
    _errorMessage = null;
    notifyListeners();

    try {
      final entries = await _diaryRepository.getDiaryEntries(
        childId, 
        date: "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      );
      
      if (entries.isNotEmpty) {
        _currentEntry = entries.first;
      } else {
        _currentEntry = null;
      }
      
    } catch (e) {
      _errorMessage = ApiErrorHandler.handleErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    } 
  }

  void updateSelectedDate(String childId, DateTime date) {
    if (DateUtils.isSameDay(_selectedDate, date)) return;
    loadDiaryForDate(childId, date);
  }
  
  Future<void> addComment(String text) async {
    if (_currentEntry == null) return;
    
    try {
      await _diaryRepository.addComment(_currentEntry!.id, text);
      
      // OPTIONAL: Refresh entry or manually add locally
      // For now, let's manually add locally for instant feedback
      final newComment = DiaryComment(
        id: "local_${DateTime.now().millisecondsSinceEpoch}",
        userId: "current_user",
        userName: "You",
        text: text,
        timestamp: DateTime.now(),
        userType: "parent",
      );
      
      final updatedComments = List<DiaryComment>.from(_currentEntry!.comments ?? []);
      updatedComments.add(newComment);
      
      _currentEntry = _currentEntry!.copyWith(comments: updatedComments);
      notifyListeners();
    } catch (e) {
      _errorMessage = ApiErrorHandler.handleErrorMessage(e);
      notifyListeners();
    }
  }
}
