import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/address_type.dart';
import '../models/address_statistics.dart';

class AddressRepository {
  AddressRepository._internal();

  static final AddressRepository _instance = AddressRepository._internal();

  factory AddressRepository() => _instance;

  final CollectionReference<Map<String, dynamic>> _addressRef = FirebaseFirestore.instance.collection('address');

  final String _areaDocumentId = 'area';
  final String _nativePlaceDocumentId = 'native';

  Future<AddressStatistics?> fetchAreaStatistics() async {
    final DocumentSnapshot<Map<String, dynamic>> areaSnapshot = await _addressRef.doc(_areaDocumentId).get();
    if (!areaSnapshot.exists) {
      return null;
    }
    return AddressStatistics.fromMap(AddressType.area, areaSnapshot.data());
  }

  Future<AddressStatistics?> fetchNativePlaceStatistics() async {
    final DocumentSnapshot<Map<String, dynamic>> nativePlaceSnapshot =
        await _addressRef.doc(_nativePlaceDocumentId).get();
    if (!nativePlaceSnapshot.exists) {
      return null;
    }
    return AddressStatistics.fromMap(AddressType.native, nativePlaceSnapshot.data());
  }
}
