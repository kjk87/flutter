import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

Future<UserCredential?> signInWithApple() async {
  final AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    webAuthenticationOptions: WebAuthenticationOptions(
      clientId: "wocvid.73toor.moc",
      redirectUri: Uri.parse("https://api.divcow.com/callbacks/sign_in_with_apple/divcow",),
    ),
  );

  if (credential != null) {

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode
    );
    final user = await _firebaseAuth.signInWithCredential(oauthCredential);
    return user;
  }
  return null;
}