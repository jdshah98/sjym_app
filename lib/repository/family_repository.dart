import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyRepository {
  FamilyRepository._internal();

  static final FamilyRepository _instance = FamilyRepository._internal();

  factory FamilyRepository() => _instance;

  final CollectionReference<Map<String, dynamic>> _ref = FirebaseFirestore.instance.collection('family');
}
