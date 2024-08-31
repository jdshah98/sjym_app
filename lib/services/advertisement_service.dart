import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sjym_app/models/advertisement.dart';
import 'package:sjym_app/provider/storage_provider.dart';
import 'package:sjym_app/repository/advertisement_repository.dart';
import 'package:sjym_app/utils/constants.dart';
import 'package:sjym_app/utils/helper.dart';
import 'package:sjym_app/utils/keys.dart';

class AdvertisementService {
  AdvertisementService._internal();

  static final AdvertisementService _instance = AdvertisementService._internal();

  factory AdvertisementService() => _instance;

  final GetStorage _getStorage = GetStorage(Constants.cacheContainer);

  Future<String?> getWelcomeAdvertisementPath() async {
    Directory localDirectory = await getApplicationDocumentsDirectory();

    // Fetch Advertisement From Cache
    Advertisement? cachedAdvertisement = _getStorage.read<Advertisement>(Keys.advertisement);
    if (cachedAdvertisement != null) {
      if (!Helper.isExpired(cachedAdvertisement.welcomeAdvertisement.expiry)) {
        if (cachedAdvertisement.welcomeAdvertisement.filepath.isNotEmpty) {
          return "${localDirectory.path}/${cachedAdvertisement.welcomeAdvertisement.filepath}";
        }
      }
    }

    // Fetch Advertisement From Storage
    Advertisement? advertisement = await AdvertisementRepository().getAdvertisement();
    if (advertisement != null) {
      if (!Helper.isExpired(advertisement.welcomeAdvertisement.expiry)) {
        if (advertisement.welcomeAdvertisement.filepath.isNotEmpty) {
          String localPath = "${localDirectory.path}/${advertisement.welcomeAdvertisement.filepath}";
          TaskSnapshot taskSnapshot = await StorageProvider().downloadAdvertisementToLocal(
            advertisement.welcomeAdvertisement.filepath,
            File(localPath),
          );

          if (taskSnapshot.state == TaskState.success) {
            _getStorage.write(Keys.advertisement, advertisement);

            return localPath;
          }
        }
      }
    }
    return null;
  }
}
