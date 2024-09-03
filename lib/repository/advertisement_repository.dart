import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sjym_app/models/advertisement.dart';

class AdvertisementRepository {
  AdvertisementRepository._internal();

  static final AdvertisementRepository _instance = AdvertisementRepository._internal();

  factory AdvertisementRepository() => _instance;

  final CollectionReference<Map<String, dynamic>> _ref = FirebaseFirestore.instance.collection('advertisement');

  final String _docId = 'jpqnkLBZqS5cVcMpOE6X';

  Future<Advertisement?> getAdvertisement() async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _ref.doc(_docId).get();
    if (!snapshot.exists) {
      return null;
    }
    return Advertisement.fromMap(snapshot.data());
  }

  Future<void> saveAdvertisement(Advertisement advertisement) async {
    await _ref.doc(_docId).set(advertisement.toMap());
  }
}
