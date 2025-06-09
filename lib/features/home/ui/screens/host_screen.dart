import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../booking/ui/logic/bookings_cubit.dart';
import '../../../booking/ui/screens/my_bookings_screen.dart';
import '../../../chat/ui/screens/chat_bot_screen.dart';
import '../../../favorites/ui/logic/favorites_cubit.dart';
import '../../../favorites/ui/screens/favorites_screen.dart';
import '../../../profile/ui/logic/profile_cubit.dart';
import '../../../profile/ui/screens/profile_view_screen.dart';
import '../logic/home_cubit.dart';
import 'home_screen.dart';

class HostScreen extends StatefulWidget {
  const HostScreen({super.key});

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _buildCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF30B0C7),
        unselectedItemColor: const Color(0xFFAFAFAF),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online_outlined),
            activeIcon: Icon(Icons.book_online),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl<HomeCubit>()),
            BlocProvider.value(value: sl<FavoritesCubit>()),
          ],
          child: const HomeScreen(),
        );
      case 1:
        return BlocProvider.value(
          value: sl<FavoritesCubit>(),
          child: const FavoritesScreen(),
        );
      case 2:
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl<HomeCubit>()),
            BlocProvider.value(value: sl<BookingsCubit>()),
          ],
          child: const MyBookingsScreen(),
        );
      case 3:
        return const ChatBotScreen();
      case 4:
        return BlocProvider.value(
          value: sl<ProfileCubit>(),
          child: const ProfileViewScreen(),
        );
      default:
        return const HomeScreen();
    }
  }
}
