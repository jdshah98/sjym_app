import 'package:flutter/material.dart';
import 'components/area_grid_view.dart';
import 'components/native_grid_view.dart';
import 'components/search_member.dart';

class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({super.key});

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabController.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Address Book'),
          bottom: TabBar(
            labelStyle: const TextStyle(color: Colors.white),
            unselectedLabelStyle: const TextStyle(color: Colors.white),
            indicatorColor: Colors.orange,
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.search), text: 'Member Search'),
              Tab(icon: Icon(Icons.place_outlined), text: 'Area'),
              Tab(icon: Icon(Icons.place_outlined), text: 'Native'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            SearchMember(),
            AreaGridView(),
            NativeGridView(),
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
