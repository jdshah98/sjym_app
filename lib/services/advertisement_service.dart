import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../models/advertisement.dart';
import '../provider/cache_provider.dart';
import '../provider/storage_provider.dart';
import '../repository/advertisement_repository.dart';
import '../utils/helper.dart';

class AdvertisementService {
  AdvertisementService._internal();

  static final AdvertisementService _instance = AdvertisementService._internal();

  factory AdvertisementService() => _instance;

  Future<String?> getWelcomeAdvertisementPath() async {
    Directory localDirectory = await getApplicationDocumentsDirectory();

    // Fetch Advertisement From Cache
    Advertisement? cachedAdvertisement = CacheProvider().getAdvertisement();
    if (cachedAdvertisement != null) {
      if (!Helper.isExpired(cachedAdvertisement.welcomeAdvertisement.expiry)) {
        if (cachedAdvertisement.welcomeAdvertisement.filepath.isNotEmpty) {
          return '${localDirectory.path}/${cachedAdvertisement.welcomeAdvertisement.filepath}';
        }
      }
    }

    // Fetch Advertisement From Storage
    Advertisement? advertisement = await AdvertisementRepository().getAdvertisement();
    if (advertisement != null) {
      if (!Helper.isExpired(advertisement.welcomeAdvertisement.expiry)) {
        if (advertisement.welcomeAdvertisement.filepath.isNotEmpty) {
          String localPath = '${localDirectory.path}/${advertisement.welcomeAdvertisement.filepath}';
          TaskSnapshot taskSnapshot = await StorageProvider().downloadAdvertisementToLocal(
            advertisement.welcomeAdvertisement.filepath,
            File(localPath),
          );

          if (taskSnapshot.state == TaskState.success) {
            CacheProvider().setAdvertisement(advertisement);

            return localPath;
          }
        }
      }
    }
    return null;
  }
}
