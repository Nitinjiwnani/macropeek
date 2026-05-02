import 'dart:async';

import '../domain/entities/app_user.dart';
import '../domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  MockAuthRepository({AppUser? initialUser}) : _currentUser = initialUser;

  final StreamController<AppUser?> _authController =
      StreamController<AppUser?>.broadcast();

  AppUser? _currentUser;

  @override
  Stream<AppUser?> get authStateChanges async* {
    yield _currentUser;
    yield* _authController.stream;
  }

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Future<AppUser> signInWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _currentUser = const AppUser(
      uid: 'mock-user-001',
      email: 'nitin@example.com',
      displayName: 'Nitin Jiwnani',
      photoUrl: null,
    );
    _authController.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _authController.add(null);
  }

  void dispose() {
    _authController.close();
  }
}
