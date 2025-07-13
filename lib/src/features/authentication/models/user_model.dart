import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String fullName;
  final String eMail;
  final String? password;

  const UserModel({
    required this.fullName,
    required this.eMail,
    this.password,
    this.id,
  });
  factory UserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    return UserModel(
      id: snapshot.id,
      fullName: data["Fullname"],
      eMail: data["Email"],
      password: data["Password"],
    );
  }
  Map<String,dynamic>toJson() {
    return {
      "Fullname": fullName,
      "Email": eMail,
      if (password != null) "Password": password,
    };
  }
}
