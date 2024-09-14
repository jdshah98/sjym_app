import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/member.dart';
import '../provider/cache_provider.dart';
import 'about_screen.dart';
import 'address_book_screen.dart';
import 'admin_panel.dart';
import 'blood_bank_screen.dart';
import 'committee_screen.dart';
import 'contact_us_screen.dart';
import 'events_screen.dart';
import 'jobs_screen.dart';
import 'login_screen.dart';
import 'matrimony_screen.dart';
import 'news_screen.dart';
import 'profile_screen.dart';
import 'samaj_info_screen.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../widgets/thumbnail_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Member? _loggedInMember;

  @override
  void initState() {
    super.initState();
    _loggedInMember = CacheProvider().getLoggedInMember();
    if (_loggedInMember == null) {
      _logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
        actions: [
          PopupMenuButton(
            icon: ThumbnailImage(
              image: _loggedInMember!.profile.thumbnail,
              width: 36,
              height: 36,
            ),
            offset: const Offset(0, 8),
            position: PopupMenuPosition.under,
            onSelected: (value) {
              switch (value) {
                case 1:
                  {
                    Get.to(() => const ProfileScreen());
                    break;
                  }
                case 2:
                  {
                    Get.to(() => const AdminPanel());
                    break;
                  }
                case 3:
                  {
                    Get.to(() => const AboutScreen());
                    break;
                  }
                case 4:
                  {
                    _logout();
                    break;
                  }
                default:
                  break;
              }
            },
            itemBuilder: actionItemBuilder,
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _Icon(
            assetImage: Assets.samajInfo,
            text: 'Samaj Info',
            onTap: () => Get.to(() => const SamajInfoScreen()),
          ),
          _Icon(
            assetImage: Assets.committee,
            text: 'Committee',
            onTap: () => Get.to(() => const CommitteeScreen()),
          ),
          _Icon(
            assetImage: Assets.news,
            text: 'News',
            onTap: () => Get.to(() => const NewsScreen()),
          ),
          _Icon(
            assetImage: Assets.addressBook,
            text: 'Address Book',
            onTap: () => Get.to(() => const AddressBookScreen()),
          ),
          _Icon(
            assetImage: Assets.events,
            text: 'Events',
            onTap: () => Get.to(() => const EventsScreen()),
          ),
          _Icon(
            assetImage: Assets.matrimony,
            text: 'Matrimony',
            onTap: () => Get.to(() => const MatrimonyScreen()),
          ),
          _Icon(
            assetImage: Assets.jobs,
            text: 'Jobs',
            onTap: () => Get.to(() => const JobsScreen()),
          ),
          _Icon(
            assetImage: Assets.bloodBank,
            text: 'Blood Bank',
            onTap: () => Get.to(() => const BloodBankScreen()),
          ),
          _Icon(
            assetImage: Assets.contacts,
            text: 'Contact Us',
            onTap: () => Get.to(() => const ContactUsScreen()),
          ),
        ],
      ),
    );
  }

  List<PopupMenuEntry> actionItemBuilder(BuildContext context) {
    TextStyle menuItemTextStyle = const TextStyle(
      fontSize: 18,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.normal,
    );
    return [
      PopupMenuItem<int>(
        value: 1,
        child: Text('Profile', style: menuItemTextStyle),
      ),
      if (_loggedInMember!.isAdmin) ...[
        PopupMenuItem<int>(
          value: 2,
          child: Text('Admin Panel', style: menuItemTextStyle),
        ),
      ],
      PopupMenuItem<int>(
        value: 3,
        child: Text('About App', style: menuItemTextStyle),
      ),
      PopupMenuItem<int>(
        value: 4,
        child: Text('Logout', style: menuItemTextStyle),
      ),
    ];
  }

  _logout() {
    CacheProvider().eraseUserCache();
    Get.offAll(() => const LoginScreen());
  }
}

class _Icon extends StatelessWidget {
  const _Icon({
    required this.assetImage,
    required this.text,
    this.onTap,
  });

  final String assetImage;
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(
            image: AssetImage(assetImage),
            width: 60,
            height: 60,
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.primaryColor,
            ),
            softWrap: true,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
