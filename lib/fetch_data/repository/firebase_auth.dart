import 'package:firebase_auth/firebase_auth.dart';


class UserAuthentication {
  // CreateUserWithEmailAndPassword Response Code
  static const String _weakPassword = 'weak-password';
  static const String _emailAlreadyUsed = 'email-already-in-use';

  // SignInWithEmailAndPassword Response Code
  static const String _userNotFound = 'user-not-found';
  static const String _wrongPassword = 'wrong-password';
  // Google SignIn response code
  static const String _accountExistWithDifferentCredentials =
      'account-exists-with-different-credential';
  static const String _invalidCredentials = 'invalid-credential';

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // To Access Firebase User Data out side
  static User? firebaseUser;



  bool _isVerificationMailSent = false;

  bool _isEmailAlreadyUsed = false;
  bool _isWeekPassword = false;
  bool _isUserNotFound = false;
  bool _isWrongPassword = false;
  bool _isUserLogin = false;
  bool _isUserLogout = false;
  bool _isInvalidGoogleCredentials = false;
  bool _isGoogleAccountExistWithDifferentCredentials = false;

  bool get isGoogleAccountExistWithDifferentCredentials =>
      _isGoogleAccountExistWithDifferentCredentials;
  bool get isInvalidGoogleCredentials => _isInvalidGoogleCredentials;
  bool get isVerificationMailSent => _isVerificationMailSent;
  bool get isUserLogin => _isUserLogin;
  bool get isUserLogout => _isUserLogout;

  bool get isEmailAlreadyUsed => _isEmailAlreadyUsed;
  bool get isWeekPassword => _isWeekPassword;

  bool get isUserNotFound => _isUserNotFound;

  bool get isWrongPassword => _isWrongPassword;

  Future<void> userRegistration(
      {String? userName, String? email, String? password}) async {
    UserCredential? userCredential;
    try {
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      firebaseUser = userCredential.user;

      // Verifying Email
      await firebaseUser!
          .sendEmailVerification()
          .then((value) => _isVerificationMailSent = true);
      firebaseUser!.updateDisplayName(userName);
    } on FirebaseAuthException catch (e) {
      if (e.code == _weakPassword) {
        _isEmailAlreadyUsed = false;
        _isWeekPassword = true;
      } else if (e.code == _emailAlreadyUsed) {
        _isVerificationMailSent = false;
        _isWeekPassword = false;
        _isEmailAlreadyUsed = true;
      }
    }
  }

  Future<User?> userSignInWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential? userCredential;

    try {
      userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      // Email Verified or not
      firebaseUser = userCredential.user;

      return firebaseUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == _userNotFound) {
        _isWrongPassword = false;
        _isUserNotFound = true;
      } else if (e.code == _wrongPassword) {
        _isUserNotFound = false;
        _isWrongPassword = true;
      }
    }
  }



  Future<void> logOut() async {


    await _firebaseAuth.signOut();

    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event == null) {
        _isUserLogin = false;
        _isUserLogout = true;
      } else {
        _isUserLogout = false;
        _isUserLogin = true;
      }
    });
  }
}