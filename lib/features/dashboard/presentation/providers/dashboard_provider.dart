import 'package:flutter/foundation.dart';
import 'package:pms/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:pms/shared/models/child_model.dart';
import 'package:pms/core/network/api_error_handler.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardRepository _dashboardRepository;
  List<ChildModel> _children = [];
  int _selectedChildIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  DashboardProvider(this._dashboardRepository);

  void updateRepo(DashboardRepository repo) {
    _dashboardRepository = repo;
  }

  // Getters
  List<ChildModel> get children => _children;
  ChildModel? get selectedChild =>
      _children.isNotEmpty ? _children[_selectedChildIndex] : null;
  int get selectedChildIndex => _selectedChildIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Set error message
  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Select child
  void selectChild(int index) {
    if (index >= 0 && index < _children.length) {
      _selectedChildIndex = index;
      notifyListeners();
    }
  }

  // Load dashboard data
  Future<void> loadDashboardData() async {
    _setLoading(true);
    _setError(null);

    try {
      _children = await _dashboardRepository.getChildren();
      _setLoading(false);
    } catch (e) {
      _setError(ApiErrorHandler.handleErrorMessage(e));
      _setLoading(false);
    }
  }

  // Refresh dashboard data
  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }
}
