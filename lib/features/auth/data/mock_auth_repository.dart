import '../domain/entities/app_user.dart';
import '../domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Stream<AppUser?> get authStateChanges => Stream.value(null);

  @override
  AppUser? get currentUser => null;

  @override
  Future<AppUser> signInWithGoogle() async {
    // Batch 8: replace with FirebaseAuthRepository
    throw UnimplementedError('signInWithGoogle not implemented in mock');
  }

  @override
  Future<void> signOut() async {}
}
