import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../constants/firestore_constants.dart';
import 'package:equatable/equatable.dart';

class MyUser extends Equatable {
  final String id;
  final String photoUrl;
  final String? gender;
  final String? aboutMe;
  final String? provider;
  final String? nickname;
  final String? birthDate;

  const MyUser({
    required this.id,
    required this.photoUrl,
    this.provider,
    this.gender,
    this.aboutMe,
    this.nickname,
    this.birthDate,
  });

  Map<String, dynamic> toJson() => {
        FirestoreConstants.gender: gender,
        FirestoreConstants.aboutMe: aboutMe,
        FirestoreConstants.nickname: nickname,
        FirestoreConstants.photoUrl: photoUrl,
        FirestoreConstants.provider: provider,
        FirestoreConstants.birthDate: birthDate,
      };

  factory MyUser.fromDocument(DocumentSnapshot snapshot) {
    String gender = "";
    String aboutMe = "";
    String provider = "";
    String nickname = "";
    String photoUrl = "";
    String birthDate = "";

    try {
      gender = snapshot.get(FirestoreConstants.gender);
      provider = snapshot.get(FirestoreConstants.provider);
      birthDate = snapshot.get(FirestoreConstants.birthDate);
      photoUrl = snapshot.get(FirestoreConstants.photoUrl);
      nickname = snapshot.get(FirestoreConstants.nickname);
      aboutMe = snapshot.get(FirestoreConstants.aboutMe);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return MyUser(
      id: snapshot.id,
      gender: gender,
      aboutMe: aboutMe,
      provider: provider,
      nickname: nickname,
      photoUrl: photoUrl,
      birthDate: birthDate,
    );
  }

  @override
  List<Object?> get props =>
      [id, photoUrl, nickname, aboutMe, provider, birthDate, gender];
}
