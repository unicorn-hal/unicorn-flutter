import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Service/Firebase/Authentication/authentication_service.dart';

class SignOutController extends ControllerCore {
  FirebaseAuthenticationService get _firebaseAuthenticationService =>
      FirebaseAuthenticationService();

  @override
  void initialize() {
    _firebaseAuthenticationService.signOut();
  }
}
