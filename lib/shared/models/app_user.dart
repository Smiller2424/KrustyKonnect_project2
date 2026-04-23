import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/firestore_keys.dart';

class AppUser {
  final String uid;
  final String name;
  final String email;
  final String major;
  final String bio;
  final String profileImageUrl;
  final List<String> courses;
  final List<String> availability;
  final List<String> interests;
  final String fcmToken;
  final Timestamp? createdAt;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.major,
    required this.bio,
    required this.profileImageUrl,
    required this.courses,
    required this.availability,
    required this.interests,
    required this.fcmToken,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      FirestoreKeys.uid: uid,
      FirestoreKeys.name: name,
      FirestoreKeys.email: email,
      FirestoreKeys.major: major,
      FirestoreKeys.bio: bio,
      FirestoreKeys.profileImageUrl: profileImageUrl,
      FirestoreKeys.courses: courses,
      FirestoreKeys.availability: availability,
      FirestoreKeys.interests: interests,
      FirestoreKeys.fcmToken: fcmToken,
      FirestoreKeys.createdAt: createdAt,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map[FirestoreKeys.uid] ?? '',
      name: map[FirestoreKeys.name] ?? '',
      email: map[FirestoreKeys.email] ?? '',
      major: map[FirestoreKeys.major] ?? '',
      bio: map[FirestoreKeys.bio] ?? '',
      profileImageUrl: map[FirestoreKeys.profileImageUrl] ?? '',
      courses: List<String>.from(map[FirestoreKeys.courses] ?? []),
      availability: List<String>.from(map[FirestoreKeys.availability] ?? []),
      interests: List<String>.from(map[FirestoreKeys.interests] ?? []),
      fcmToken: map[FirestoreKeys.fcmToken] ?? '',
      createdAt: map[FirestoreKeys.createdAt],
    );
  }
}
