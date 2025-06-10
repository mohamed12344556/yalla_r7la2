import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';

const double kTabBarHeight = 48.0;

class BookingTabs extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;

  const BookingTabs({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      labelColor: Colors.blueAccent,
      unselectedLabelColor: Colors.grey[600],
      indicatorColor: Colors.blueAccent,
      indicatorWeight: 3,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      tabs: [
        Tab(text: S.of(context).All_Bookings),
        Tab(text: S.of(context).Upcoming_Bookings),
        Tab(text: S.of(context).Past_Bookings),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kTabBarHeight);
}
