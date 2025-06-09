import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:yalla_r7la2/features/auth/ui/logic/forgot_password_cubit.dart';
import 'package:yalla_r7la2/features/auth/ui/screens/forgot_password_screen.dart';
import 'package:yalla_r7la2/features/booking/ui/logic/bookings_cubit.dart';
import 'package:yalla_r7la2/features/booking/ui/screens/flight_booking_screen.dart';
import 'package:yalla_r7la2/features/booking/ui/screens/my_bookings_screen.dart';
import 'package:yalla_r7la2/features/chat/ui/screens/chat_bot_screen.dart';
import 'package:yalla_r7la2/features/favorites/ui/logic/favorites_cubit.dart';
import 'package:yalla_r7la2/features/favorites/ui/screens/favorites_screen.dart';
import 'package:yalla_r7la2/features/home/data/model/destination_model.dart';
import 'package:yalla_r7la2/features/home/ui/logic/home_cubit.dart';

import '../../features/auth/ui/logic/login_cubit.dart';
import '../../features/auth/ui/logic/register_cubit.dart';
import '../../features/auth/ui/screens/login_screen.dart';
import '../../features/auth/ui/screens/register_screen.dart';
import '../../features/home/ui/screens/home_screen.dart';
import '../../features/home/ui/screens/host_screen.dart';
import '../../features/profile/ui/logic/profile_cubit.dart';
import '../../features/profile/ui/screens/Profile_edit_screen.dart';
import '../../features/profile/ui/screens/profile_view_screen.dart';
import 'routes.dart';

final sl = GetIt.instance;

class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => sl<LoginCubit>(),
                child: const LoginScreen(),
              ),
        );

      case Routes.register:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => sl<RegisterCubit>(),
                child: const RegisterScreen(),
              ),
        );

      case Routes.forgotPassword:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => sl<ForgotPasswordCubit>(),
                child: const ForgotPasswordScreen(),
              ),
        );

      case Routes.host:
        return MaterialPageRoute(builder: (_) => const HostScreen());

      case Routes.home:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => sl<HomeCubit>(),
                child: const HomeScreen(),
              ),
        );

      case Routes.chatBot:
        return MaterialPageRoute(builder: (_) => const ChatBotScreen());

      case Routes.flightBooking:
        return MaterialPageRoute(
          builder: (context) {
            final destination = arguments as DestinationModel;
            return BlocProvider.value(
              value: sl<BookingsCubit>(),
              child: FlightBookingScreen(destination: destination),
            );
          },
        );

      case Routes.myBookings:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: sl<BookingsCubit>(),
                child: const MyBookingsScreen(),
              ),
        );

      case Routes.favorites:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: sl<FavoritesCubit>(),
                child: const FavoritesScreen(),
              ),
        );

      case Routes.profile:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => sl<ProfileCubit>(),
                child: const ProfileViewScreen(),
              ),
        );

      case Routes.editProfile:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider.value(
              value: sl<ProfileCubit>(),
              child: const ProfileEditScreen(),
            );
          },
        );

      // default:
      //   return MaterialPageRoute(
      //     builder:
      //         (_) => Scaffold(
      //           appBar: AppBar(title: const Text('Error')),
      //           body: const Center(
      //             child: Text(
      //               'Page not found!',
      //               style: TextStyle(
      //                 fontSize: 20,
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.red,
      //               ),
      //             ),
      //           ),
      //         ),
      //   );
    }
    return null;
  }
}
