import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Map<String, UserEX> userMap = <String, UserEX>{};

  final StreamController<Map<String, UserEX>> _usersController =
  StreamController<Map<String, UserEX>>();

  FirebaseService() {
    _firestore.collection('users').snapshots().listen(_usersUpdated);
  }

  Stream<Map<String, UserEX>> get users => _usersController.stream;

  void _usersUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    var users = _getUsersFromSnapshot(snapshot);
    _usersController.add(users);
  }

  Map<String, UserEX> _getUsersFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    for (var element in snapshot.docs) {
      UserEX user = UserEX.fromMap(element.id, element.data());
      userMap[user.id] = user;
    }

    return userMap;
  }
}

class UserEX {
  UserEX({
    required this.id,
    required this.picture,
    required this.name,
  });

  factory UserEX.fromMap(String id, Map<String, dynamic> data) {
    return UserEX(id: id, picture: data['picture'], name: data['display_name']);
  }

  final String id;
  final String? picture;
  final String name;
}