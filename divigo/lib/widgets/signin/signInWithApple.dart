import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:convert';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

Future<UserCredential?> signInWithApple() async {
  final AuthorizationCredentialAppleID credential =
      await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    webAuthenticationOptions: WebAuthenticationOptions(
      clientId: "divigo.root37.com",
      redirectUri: Uri.parse(
        "https://api.divcow.com/callbacks/sign_in_with_apple/divigo",
      ),
    ),
  );

  if (credential != null) {
    final payload = parseJwtPayLoad(credential.identityToken!);

    final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode);
    final user = await _firebaseAuth.signInWithCredential(oauthCredential);
    await user.user?.verifyBeforeUpdateEmail(payload['email']);
    return user;
  }
  return null;
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}

Map<String, dynamic> parseJwtPayLoad(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }

  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }

  return payloadMap;
}
