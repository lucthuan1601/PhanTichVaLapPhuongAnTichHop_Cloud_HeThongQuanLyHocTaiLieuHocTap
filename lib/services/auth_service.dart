class AuthService {
  Stream<AuthUser?> get userChanges => const Stream.empty();

  Future<AuthUser> signInWithGoogle() async {
    throw UnsupportedError(
      'Đăng nhập Google chưa được cấu hình cho môi trường hiện tại.',
    );
  }

  Future<void> signOut() async {}
}

class AuthUser {
  const AuthUser({required this.id, this.email});

  final String id;
  final String? email;
}
