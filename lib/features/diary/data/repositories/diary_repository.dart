import 'package:pms/core/network/api_endpoints.dart';
import 'package:pms/core/network/api_service.dart';
import 'package:pms/features/diary/data/models/diary_entry_model.dart';
import 'package:pms/features/diary/data/models/activity_model.dart';

class DiaryRepository {
  final ApiService _apiService;

  DiaryRepository(this._apiService);

  Future<List<DiaryEntryModel>> getDiaryEntries(String childId, {String? date}) async {
    try {
      if (ApiEndpoints.baseUrl.contains('api.pms-school.com')) {
        return _getMockDiaryEntries(childId);
      }

      final queryParams = date != null ? {'date': date} : <String, dynamic>{};
      final response = await _apiService.get(
        ApiEndpoints.diary(childId),
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> entriesData = response.data['entries'];
        return entriesData.map((json) => DiaryEntryModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load diary');
      }
    } catch (e) {
      return _getMockDiaryEntries(childId);
    }
  }

  Future<void> addComment(String entryId, String comment) async {
    try {
      if (ApiEndpoints.baseUrl.contains('api.pms-school.com')) return;
      await _apiService.post(
        ApiEndpoints.addDiaryComment(entryId),
        data: {'comment': comment},
      );
    } catch (e) {
      // Ignore for mock mode
    }
  }

  List<DiaryEntryModel> _getMockDiaryEntries(String childId) {
    final now = DateTime.now();
    return [
      DiaryEntryModel(
        id: "d_1",
        childId: childId,
        date: now,
        activities: [
          ActivityModel(
            id: "a_1",
            title: "Morning Circle",
            description: "Participated actively in the morning greeting and songs.",
            timestamp: now.subtract(const Duration(hours: 7)),
            type: ActivityType.other,
          ),
          ActivityModel(
            id: "a_2",
            title: "Mathematics",
            description: "Learned about 2D shapes and their properties. Excellent progress!",
            timestamp: now.subtract(const Duration(hours: 5)),
            type: ActivityType.study,
          ),
          ActivityModel(
            id: "a_3",
            title: "Lunch",
            description: "Ate all of his lunch independently.",
            timestamp: now.subtract(const Duration(hours: 2)),
            type: ActivityType.meal,
          ),
        ],
        teacherNote: "Great day today! Focused well on all tasks.",
        teacherName: "Ms. Sarah",
        comments: [
          DiaryComment(
            id: "c_1",
            userId: "u_1",
            userName: "John Doe",
            text: "Thanks for the update!",
            timestamp: now.subtract(const Duration(hours: 1)),
            userType: "parent",
          ),
        ],
      ),
    ];
  }
}
