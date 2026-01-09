import 'package:flutter/material.dart';
import 'package:pms/features/fees/data/models/fee_model.dart';
import 'package:pms/features/fees/data/repositories/fee_repository.dart';
import 'package:pms/core/network/api_error_handler.dart';

class FeeProvider extends ChangeNotifier {
  FeeRepository _feeRepository;
  List<FeeModel> _fees = [];
  bool _isLoading = false;
  String? _errorMessage;

  FeeProvider(this._feeRepository);

  void updateRepo(FeeRepository repo) {
    _feeRepository = repo;
  }

  List<FeeModel> get fees => _fees;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Filtered lists
  List<FeeModel> get pendingFees => _fees.where((f) => f.status == FeeStatus.pending || f.status == FeeStatus.overdue).toList();
  List<FeeModel> get paidFees => _fees.where((f) => f.status == FeeStatus.paid).toList();

  // Summary stats
  double get totalPendingAmount => pendingFees.fold(0.0, (sum, item) => sum + item.remainingAmount);
  double get totalPaidAmount => paidFees.fold(0.0, (sum, item) => sum + item.paidAmount);

  Future<void> loadFees(String childId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _fees = await _feeRepository.getFees(childId);
    } catch (e) {
      _errorMessage = ApiErrorHandler.handleErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void refreshFees(String childId) {
    loadFees(childId);
  }
}
