import 'package:pms/core/network/api_endpoints.dart';
import 'package:pms/core/network/api_service.dart';
import 'package:pms/shared/models/child_model.dart';

class DashboardRepository {
  final ApiService _apiService;

  DashboardRepository(this._apiService);

  Future<List<ChildModel>> getChildren() async {
    try {
      if (ApiEndpoints.baseUrl.contains('api.pms-school.com')) {
        return _getMockChildren();
      }

      final response = await _apiService.get(ApiEndpoints.children);
      if (response.statusCode == 200) {
        final List<dynamic> childrenData = response.data['children'];
        return childrenData.map((json) => ChildModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load children');
      }
    } catch (e) {
      return _getMockChildren();
    }
  }

  List<ChildModel> _getMockChildren() {
    return [
      ChildModel(
        id: "c_1",
        fullName: "Ayaan Ahmed",
        className: "Grade 4",
        section: "A",
        rollNumber: "402",
        dateOfBirth: DateTime(2015, 5, 20),
        bloodGroup: "O+",
        gender: "Male",
        presentDays: 111,
        absentDays: 9,
        pendingFees: 1500,
        profilePictureUrl: "https://i.pravatar.cc/150?u=ayaan",
      ),
      ChildModel(
        id: "c_2",
        fullName: "Zoya Ahmed",
        className: "Grade 1",
        section: "C",
        rollNumber: "115",
        dateOfBirth: DateTime(2018, 8, 12),
        bloodGroup: "B+",
        gender: "Female",
        presentDays: 114,
        absentDays: 6,
        pendingFees: 0,
        profilePictureUrl: "https://i.pravatar.cc/150?u=zoya",
      ),
    ];
  }
}
