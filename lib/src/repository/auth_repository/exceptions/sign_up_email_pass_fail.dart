class SignupEmailPassFailure {
  final String message;

  const SignupEmailPassFailure([
    this.message = "An unknown error has occurred",
  ]);

  factory SignupEmailPassFailure.code(String code) {
    switch (code) {
      case 'user-not-found':
        return const SignupEmailPassFailure("This email is not registered.");
      case 'weak-password':
        return const SignupEmailPassFailure('Please enter a stronger password');
      case 'invalid-email':
        return const SignupEmailPassFailure('Email is in wrong format or not valid');
      case 'email-already-in-use':
        return const SignupEmailPassFailure('An account already exists for this email');
      case 'operation-not-allowed':
        return const SignupEmailPassFailure('Operation is not allowed. please contact Support!');
      case 'user-disabled':
        return const SignupEmailPassFailure('This user has been disabled,contact user');
      default:
        return const SignupEmailPassFailure();
    }
  }
}
