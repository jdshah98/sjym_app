import 'package:flutter/material.dart';
import '../../models/family_stat.dart';
import '../../utils/helper.dart';
import '../../widgets/text_icon.dart';

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({super.key, required this.text, required this.familyStat});

  final String text;
  final FamilyStat familyStat;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Helper.getRandomColor(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextIcon(
                width: 70,
                height: 70,
                icon: const Icon(
                  Icons.family_restroom,
                  size: 36,
                  color: Colors.white,
                ),
                text: Text(
                  '${familyStat.familyCount}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
              TextIcon(
                width: 70,
                height: 70,
                icon: const Icon(
                  Icons.person,
                  size: 36,
                  color: Colors.white,
                ),
                text: Text(
                  '${familyStat.familyMemberCount}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
