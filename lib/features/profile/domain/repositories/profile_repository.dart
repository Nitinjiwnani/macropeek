import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile?> getProfile(String userId);
  Future<void> saveProfile(UserProfile profile);
  Future<void> updateProfile(String userId, Map<String, dynamic> updates);
  Stream<UserProfile?> watchProfile(String userId);
}
