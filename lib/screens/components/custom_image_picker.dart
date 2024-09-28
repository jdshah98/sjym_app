import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/api_response.dart';
import '../../models/image_picker_response.dart';
import '../../services/member_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/helper.dart';
import '../../widgets/text_icon.dart';

class CustomImagePicker extends StatefulWidget {
  const CustomImagePicker({super.key, required this.imageFilepath});

  final String? imageFilepath;

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  final ImagePicker _imagePicker = ImagePicker();

  static const double _iconWidth = 90;
  static const double _iconHeight = 90;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Profile Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryColor,
                  ),
                ),
                InkWell(
                  onTap: () => Get.back(result: ImagePickerResponse()),
                  child: const Icon(
                    Icons.delete,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    ImagePickerResponse imagePickerResponse = await _openImagePicker(ImageSource.camera);
                    if (mounted) {
                      Get.back(result: imagePickerResponse);
                    }
                  },
                  child: const TextIcon(
                    width: _iconWidth,
                    height: _iconHeight,
                    icon: Icon(
                      Icons.camera_alt,
                      size: 32,
                      color: AppColors.primaryColor,
                    ),
                    text: Text(
                      'Camera',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    ImagePickerResponse imagePickerResponse = await _openImagePicker(ImageSource.gallery);
                    if (mounted) {
                      Get.back(result: imagePickerResponse);
                    }
                  },
                  child: const TextIcon(
                    width: _iconWidth,
                    height: _iconHeight,
                    icon: Icon(
                      Icons.photo_library,
                      size: 32,
                      color: AppColors.primaryColor,
                    ),
                    text: Text(
                      'Gallery',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<ImagePickerResponse> _openImagePicker(ImageSource source) async {
    final XFile? pickedImage = await _imagePicker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );

    if (pickedImage != null && mounted) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressFormat: ImageCompressFormat.png,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Edit',
            toolbarColor: AppColors.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            cropStyle: CropStyle.circle,
          ),
          IOSUiSettings(
            title: 'Edit',
            cropStyle: CropStyle.circle,
          ),
        ],
      );
      if (croppedFile != null) {
        // If crop image is successful
        String localFilePath = croppedFile.path;
        log('Local File Path: $localFilePath');

        Uint8List? thumbnailBytes = await Helper.generateThumbnail(File(localFilePath), 256, 256);

        String thumbnail = Helper.encodeImage(thumbnailBytes);

        String imageFilepath = widget.imageFilepath ?? Helper.getRandomImageName();

        ApiResponse<void> result = await MemberService().setProfileImageUrl(
          File(localFilePath),
          imageFilepath,
        );

        if (!result.isError) {
          return ImagePickerResponse(
            localFile: File(localFilePath),
            thumbnail: thumbnail,
            filename: imageFilepath,
          );
        }
      }
    }
    return ImagePickerResponse();
  }
}
