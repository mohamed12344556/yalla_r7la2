import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yalla_r7la2/core/routes/routes.dart';
import 'package:yalla_r7la2/core/utils/extensions.dart';

import '../logic/bookings_cubit.dart';
import '../widgets/my_booking/booking_app_bar.dart';
import '../widgets/my_booking/booking_empty_state.dart';
import '../widgets/my_booking/booking_error_state.dart';
import '../widgets/my_booking/booking_list.dart';
import '../widgets/my_booking/booking_loading_state.dart';
import '../widgets/my_booking/booking_tabs.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // إعادة تحميل البيانات عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingsCubit>().loadBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: BookingAppBar(
        title: 'My Bookings',
        onBackPressed: () => context.pushNamed(Routes.host),
        onRefresh: () => context.read<BookingsCubit>().loadBookings(),
        bottom: BookingTabs(controller: _tabController),
      ),
      body: BlocConsumer<BookingsCubit, BookingsState>(
        listener: _handleStateChanges,
        builder: _buildBody,
      ),
    );
  }

  void _handleStateChanges(BuildContext context, BookingsState state) {
    if (state is BookingsError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () => context.read<BookingsCubit>().loadBookings(),
          ),
        ),
      );
    } else if (state is BookingCancelled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking cancelled successfully'),
          backgroundColor: Colors.orange,
        ),
      );
    } else if (state is BookingDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget _buildBody(BuildContext context, BookingsState state) {
    if (state is BookingsLoading) {
      return const BookingLoadingState();
    }

    if (state is BookingsError) {
      return BookingErrorState(
        message: state.message,
        onRetry: () => context.read<BookingsCubit>().loadBookings(),
      );
    }

    if (state is BookingsLoaded ||
        state is BookingCancelled ||
        state is BookingDeleted ||
        state is BookingAdded) {
      final cubit = context.read<BookingsCubit>();

      return TabBarView(
        controller: _tabController,
        children: [
          BookingList(
            bookings: cubit.bookings,
            tabName: 'All Bookings',
            onRefresh: () => context.read<BookingsCubit>().loadBookings(),
          ),
          BookingList(
            bookings: cubit.getUpcomingBookings(),
            tabName: 'Upcoming Bookings',
            onRefresh: () => context.read<BookingsCubit>().loadBookings(),
          ),
          BookingList(
            bookings: cubit.getPastBookings(),
            tabName: 'Past Bookings',
            onRefresh: () => context.read<BookingsCubit>().loadBookings(),
          ),
        ],
      );
    }

    return BookingEmptyState(
      message: 'Something went wrong',
      subMessage: 'Please try again later',
      icon: Icons.error,
      onActionPressed: () => Navigator.of(context).pushNamed(Routes.host),
    );
  }
}
