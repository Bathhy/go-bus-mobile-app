class AuthState {
  final bool isLoading;
  final bool isLogout;

  AuthState({this.isLogout = false, this.isLoading = false});

  AuthState copyWith(bool? isLogout, bool? isLoading) {
    return AuthState(
      isLogout: isLogout ?? this.isLogout,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
