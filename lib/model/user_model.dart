import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String phone;
  final DateTime createdAt;

  UserModel({required this.phone, required this.createdAt});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      phone: map['phone'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
