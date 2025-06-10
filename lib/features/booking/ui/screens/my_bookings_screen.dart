import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yalla_r7la2/generated/l10n.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/extensions.dart';

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
        title: S.of(context).My_Bookings,
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
            label: S.of(context).Retry,
            textColor: Colors.white,
            onPressed: () => context.read<BookingsCubit>().loadBookings(),
          ),
        ),
      );
    } else if (state is BookingCancelled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).Booking_cancelled_successfully),
          backgroundColor: Colors.orange,
        ),
      );
    } else if (state is BookingDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).Booking_deleted_successfully),
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
            tabName: S.of(context).All_Bookings,
            onRefresh: () => context.read<BookingsCubit>().loadBookings(),
          ),
          BookingList(
            bookings: cubit.getUpcomingBookings(),
            tabName: S.of(context).Upcoming_Bookings,
            onRefresh: () => context.read<BookingsCubit>().loadBookings(),
          ),
          BookingList(
            bookings: cubit.getPastBookings(),
            tabName: S.of(context).Past_Bookings,
            onRefresh: () => context.read<BookingsCubit>().loadBookings(),
          ),
        ],
      );
    }

    return BookingEmptyState(
      message: S.of(context).Something_went_wrong_message,
      subMessage: S.of(context).Please_try_again_later,
      icon: Icons.error,
      onActionPressed: () => Navigator.of(context).pushNamed(Routes.host),
    );
  }
}
