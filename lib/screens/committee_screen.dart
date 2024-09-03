import 'package:flutter/material.dart';
import 'package:sjym_app/models/committee_type.dart';
import 'package:sjym_app/screens/components/committee_tab_view.dart';

class CommitteeScreen extends StatefulWidget {
  const CommitteeScreen({super.key});

  @override
  State<CommitteeScreen> createState() => _CommitteeScreenState();
}

class _CommitteeScreenState extends State<CommitteeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabController.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Committee Members"),
          bottom: TabBar(
            labelStyle: const TextStyle(
              color: Colors.white,
            ),
            unselectedLabelStyle: const TextStyle(
              color: Colors.white,
            ),
            indicatorColor: Colors.orange,
            controller: _tabController,
            tabs: const [
              Tab(text: "Main Committee"),
              Tab(text: "Yuva Committee"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            CommitteeTabView(committeeType: CommitteeType.main),
            CommitteeTabView(committeeType: CommitteeType.yuva),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }
}
