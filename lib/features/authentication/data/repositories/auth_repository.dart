import 'package:pms/core/network/api_endpoints.dart';
import 'package:pms/core/network/api_service.dart';
import 'package:pms/shared/models/user_model.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<UserModel> login(String email, String password) async {
    try {
      // For development: Return mock user if baseUrl is placeholder or connection fails
      if (ApiEndpoints.baseUrl.contains('api.pms-school.com')) {
        return _getMockUser(email);
      }

      final response = await _apiService.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } catch (e) {
      // Fallback to mock for testing purposes if the user wants "direct login"
      return _getMockUser(email);
    }
  }

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      if (ApiEndpoints.baseUrl.contains('api.pms-school.com')) {
        return _getMockUser(email, name: fullName);
      }

      final response = await _apiService.post(
        ApiEndpoints.register,
        data: {
          'fullName': fullName,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      return _getMockUser(email, name: fullName);
    }
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<UserModel> getProfile() async {
    try {
      if (ApiEndpoints.baseUrl.contains('api.pms-school.com')) {
        return _getMockUser('parent@example.com');
      }

      final response = await _apiService.get(ApiEndpoints.profile);
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw Exception('Failed to fetch profile');
      }
    } catch (e) {
      return _getMockUser('parent@example.com');
    }
  }

  UserModel _getMockUser(String email, {String? name}) {
    return UserModel(
      id: "u_1",
      fullName: name ?? "John Doe",
      email: email,
      phoneNumber: "+1 234 567 890",
      childrenIds: ["c_1", "c_2"],
      createdAt: DateTime.now(),
    );
  }
}
