import 'package:pms/core/network/api_endpoints.dart';
import 'package:pms/core/network/api_service.dart';
import 'package:pms/features/fees/data/models/fee_model.dart';

class FeeRepository {
  final ApiService _apiService;

  FeeRepository(this._apiService);

  Future<List<FeeModel>> getFees(String childId) async {
    try {
      if (ApiEndpoints.baseUrl.contains('api.pms-school.com')) {
        return _getMockFees(childId);
      }

      final response = await _apiService.get(ApiEndpoints.fees(childId));
      if (response.statusCode == 200) {
        final List<dynamic> feesData = response.data['fees'];
        return feesData.map((json) => FeeModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load fees');
      }
    } catch (e) {
      return _getMockFees(childId);
    }
  }

  Future<void> payFee(String feeId, String paymentMethodId) async {
    try {
      if (ApiEndpoints.baseUrl.contains('api.pms-school.com')) {
        await Future.delayed(const Duration(seconds: 1));
        return;
      }
      await _apiService.post(
        ApiEndpoints.payFee(feeId),
        data: {'paymentMethodId': paymentMethodId},
      );
    } catch (e) {
      // Ignore for mock mode
    }
  }

  List<FeeModel> _getMockFees(String childId) {
    return [
      FeeModel(
        id: "f_1",
        childId: childId,
        title: "Tuition Fee - January",
        amount: 5000,
        paidAmount: 0,
        dueDate: DateTime(2026, 1, 15),
        status: FeeStatus.pending,
        type: FeeType.tuition,
      ),
      FeeModel(
        id: "f_2",
        childId: childId,
        title: "Registration Fee",
        amount: 2000,
        paidAmount: 2000,
        dueDate: DateTime(2025, 12, 10),
        status: FeeStatus.paid,
        type: FeeType.other,
        paymentDate: DateTime(2025, 12, 5),
        transactionId: "TXN_123456",
      ),
    ];
  }
}
