import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract interface class AuthRemoteDataSource {
  Stream<User?> get authStateChanges;

  User? get currentUser;

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserCredential> signInWithGoogle();

  Future<void> signOut();

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> updateDisplayName(String displayName);

  Future<String?> getProfilePhone(String uid);

  // [phone] == '' clears the Firestore `phone` field for this user.
  Future<void> updateUserProfile({
    required String displayName,
    required String phone,
    List<int>? profileImageBytes,
  });
}

final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseStorage? storage,
    FirebaseFirestore? firestore,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  static const _kUserProfiles = 'user_profiles';
  static const _kPhone = 'phone';

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseStorage _storage;
  final FirebaseFirestore _firestore;

  @override
  Stream<User?> get authStateChanges => _auth.userChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) => _auth.signInWithEmailAndPassword(email: email, password: password);

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) => _auth.createUserWithEmailAndPassword(email: email, password: password);

  @override
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser;
    try {
      googleUser = await _googleSignIn.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted ||
          e.code == GoogleSignInExceptionCode.uiUnavailable) {
        throw FirebaseAuthException(
          code: 'google_sign_in_aborted',
          message: 'Google sign in was aborted',
        );
      }
      throw FirebaseAuthException(
        code: 'google_sign_in_failed',
        message: e.description ?? 'Google sign in failed',
      );
    }

    final googleAuth = googleUser.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null) {
      throw FirebaseAuthException(
        code: 'google_sign_in_failed',
        message: 'No ID token from Google',
      );
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);
    return _auth.signInWithCredential(credential);
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      _auth.sendPasswordResetEmail(email: email);

  @override
  Future<void> signOut() async {
    await _auth.signOut();

    try {
      await _googleSignIn.signOut();
    } catch (e, st) {
      // Google may already be signed out; still surface success from Firebase.
      debugPrint('AuthRemoteDataSourceImpl.signOut (Google) failed: $e\n$st');
    }
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(displayName);
      await user.reload();
    }
  }

  @override
  Future<String?> getProfilePhone(String uid) async {
    final snap = await _firestore.collection(_kUserProfiles).doc(uid).get();
    final rawPhone = snap.data()?[_kPhone];
    if (rawPhone is! String) return null;
    final trimmedPhone = rawPhone.trim();
    return trimmedPhone.isEmpty ? null : trimmedPhone;
  }

  @override
  Future<void> updateUserProfile({
    required String displayName,
    required String phone,
    List<int>? profileImageBytes,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Not signed in',
      );
    }
    if (profileImageBytes != null && profileImageBytes.isNotEmpty) {
      final ref = _storage.ref('users/${user.uid}/profile.jpg');
      await ref.putData(
        Uint8List.fromList(profileImageBytes),
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final url = await ref.getDownloadURL();
      await user.updatePhotoURL(url);
    }
    await user.updateDisplayName(displayName);
    final doc = _firestore.collection(_kUserProfiles).doc(user.uid);
    final trimmed = phone.trim();
    if (trimmed.isEmpty) {
      await doc.set(
        {_kPhone: FieldValue.delete()},
        SetOptions(merge: true),
      );
    } else {
      await doc.set(
        {_kPhone: trimmed},
        SetOptions(merge: true),
      );
    }
    await user.reload();
  }
}
