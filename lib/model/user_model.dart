import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String phoneNumber;
  final DateTime createdAt;
  String? name;
  String? email;
  String? gender;
  String? role;

  UserModel({
    required this.phoneNumber,
    required this.createdAt,
    this.name,
    this.email,
    this.gender,
    this.role,
  });

  // Factory constructor to create a UserModel from Firestore map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      phoneNumber: map['phoneNumber'] is String ? map['phoneNumber'] : '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      name: map['name'] is String ? map['name'] : null,
      email: map['email'] is String ? map['email'] : null,
      gender: map['gender'] is String ? map['gender'] : null,
      role: map['role'] is String ? map['role'] : null,
    );
  }

  // Method to convert UserModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'createdAt': Timestamp.fromDate(createdAt),
      'name': name,
      'email': email,
      'gender': gender,
      'role': role,
    };
  }
}
