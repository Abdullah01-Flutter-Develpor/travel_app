import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseReference {
  /// Firebase Reference
  CollectionReference userDetail =
      FirebaseFirestore.instance.collection('UserDetail');
  CollectionReference travelPost =
      FirebaseFirestore.instance.collection('travelPost');
  CollectionReference favorites =
      FirebaseFirestore.instance.collection('favorites');

  /// Firebase Auth
  final auth = FirebaseAuth.instance;
}
