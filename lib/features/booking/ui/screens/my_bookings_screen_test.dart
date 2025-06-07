// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:yalla_r7la2/core/routes/routes.dart';
// import 'package:yalla_r7la2/core/utils/extensions.dart';
// import 'package:yalla_r7la2/features/booking/data/models/booking_models.dart';

// import '../logic/bookings_cubit.dart';

// class BookingsScreen extends StatefulWidget {
//   const BookingsScreen({super.key});

//   @override
//   State<BookingsScreen> createState() => _BookingsScreenState();
// }

// class _BookingsScreenState extends State<BookingsScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);

//     // إعادة تحميل البيانات عند فتح الشاشة
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<BookingsCubit>().loadBookings();
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text(
//           'My Bookings',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         foregroundColor: Colors.black87,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () {
//             context.pushNamed(Routes.host);
//           },
//           tooltip: 'Back',
//         ),
//         actions: [
//           // زر تحديث البيانات
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               context.read<BookingsCubit>().loadBookings();
//             },
//             tooltip: 'Refresh Bookings',
//           ),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: Colors.blueAccent,
//           unselectedLabelColor: Colors.grey[600],
//           indicatorColor: Colors.blueAccent,
//           indicatorWeight: 3,
//           labelStyle: const TextStyle(fontWeight: FontWeight.bold),
//           tabs: const [
//             Tab(text: 'All'),
//             Tab(text: 'Upcoming'),
//             Tab(text: 'Past'),
//           ],
//         ),
//       ),
//       body: BlocConsumer<BookingsCubit, BookingsState>(
//         listener: (context, state) {
//           if (state is BookingsError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//                 action: SnackBarAction(
//                   label: 'Retry',
//                   textColor: Colors.white,
//                   onPressed: () {
//                     context.read<BookingsCubit>().loadBookings();
//                   },
//                 ),
//               ),
//             );
//           } else if (state is BookingCancelled) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Booking cancelled successfully'),
//                 backgroundColor: Colors.orange,
//               ),
//             );
//           } else if (state is BookingDeleted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Booking deleted successfully'),
//                 backgroundColor: Colors.green,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           // عرض Loading أثناء تحميل البيانات
//           if (state is BookingsLoading) {
//             return const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(color: Colors.blueAccent),
//                   SizedBox(height: 16),
//                   Text(
//                     'Loading your bookings...',
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             );
//           }

//           // عرض رسالة خطأ مع إمكانية إعادة المحاولة
//           if (state is BookingsError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Failed to load bookings',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     state.message,
//                     style: TextStyle(fontSize: 16, color: Colors.grey[500]),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       context.read<BookingsCubit>().loadBookings();
//                     },
//                     icon: const Icon(Icons.refresh),
//                     label: const Text('Try Again'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueAccent,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 12,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           // عرض البيانات عند النجاح
//           if (state is BookingsLoaded ||
//               state is BookingCancelled ||
//               state is BookingDeleted ||
//               state is BookingAdded) {
//             final cubit = context.read<BookingsCubit>();

//             return TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildBookingsList(cubit.bookings, 'All Bookings'),
//                 _buildBookingsList(
//                   cubit.getUpcomingBookings(),
//                   'Upcoming Bookings',
//                 ),
//                 _buildBookingsList(cubit.getPastBookings(), 'Past Bookings'),
//               ],
//             );
//           }

//           // الحالة الافتراضية
//           return _buildEmptyState('Something went wrong', context);
//         },
//       ),
//     );
//   }

//   Widget _buildBookingsList(List<BookingModel> bookings, String tabName) {
//     if (bookings.isEmpty) {
//       return _buildEmptyState(tabName, context);
//     }

//     return RefreshIndicator(
//       onRefresh: () async {
//         context.read<BookingsCubit>().loadBookings();
//       },
//       color: Colors.blueAccent,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: bookings.length,
//         itemBuilder: (context, index) {
//           return _buildBookingCard(bookings[index]);
//         },
//       ),
//     );
//   }

//   Widget _buildEmptyState(String context, BuildContext context1) {
//     String message = 'No bookings found';
//     String subMessage = 'Your bookings will appear here';
//     IconData icon = Icons.flight_takeoff;

//     if (context.contains('Upcoming')) {
//       message = 'No upcoming trips';
//       subMessage = 'Plan your next adventure!';
//       icon = Icons.upcoming;
//     } else if (context.contains('Past')) {
//       message = 'No past trips';
//       subMessage = 'Your travel history will appear here';
//       icon = Icons.history;
//     }

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 80, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           Text(
//             message,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             subMessage,
//             style: TextStyle(fontSize: 16, color: Colors.grey[500]),
//           ),
//           const SizedBox(height: 24),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             decoration: BoxDecoration(
//               color: Colors.blueAccent.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(25),
//               border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
//             ),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.of(context1).pushNamed(Routes.host);
//               },
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.explore, color: Colors.blueAccent, size: 20),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Explore Destinations',
//                     style: TextStyle(
//                       color: Colors.blueAccent,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBookingCard(BookingModel booking) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Header with image and basic info
//           Container(
//             height: 120,
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(16),
//                 topRight: Radius.circular(16),
//               ),
//               image: DecorationImage(
//                 image: NetworkImage(booking.imageUrl),
//                 fit: BoxFit.cover,
//                 onError: (exception, stackTrace) {
//                   // Handle image loading error
//                 },
//               ),
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(16),
//                   topRight: Radius.circular(16),
//                 ),
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 booking.destinationName,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 booking.destinationLocation,
//                                 style: const TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         _buildStatusChip(booking.status),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // Booking details
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 // Booking ID and Date
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Booking ID: ${booking.bookingId.length > 8 ? booking.bookingId.substring(0, 8) : booking.bookingId}...',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     Text(
//                       'Booked: ${booking.formattedBookingDate}',
//                       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 16),

//                 // Travel dates
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildDateInfo(
//                         'Departure',
//                         booking.formattedDepartureDate,
//                         booking.departureTime,
//                         Icons.flight_takeoff,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: _buildDateInfo(
//                         'Return',
//                         booking.formattedReturnDate,
//                         booking.returnArrivalTime,
//                         Icons.flight_land,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 16),

//                 // Passengers and price
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.person,
//                           size: 16,
//                           color: Colors.blueAccent,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           '${booking.passengers} ${booking.passengers == 1 ? 'Passenger' : 'Passengers'}',
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       '\$${booking.totalAmount.toStringAsFixed(0)}',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blueAccent,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 16),

//                 // Action buttons
//                 if (booking.status == BookingStatus.confirmed)
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: () => _showCancelDialog(booking),
//                           icon: const Icon(Icons.cancel, size: 16),
//                           label: const Text('Cancel'),
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: Colors.orange,
//                             side: const BorderSide(color: Colors.orange),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: () => _showBookingDetails(booking),
//                           icon: const Icon(Icons.info, size: 16),
//                           label: const Text('Details'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blueAccent,
//                             foregroundColor: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                 if (booking.status == BookingStatus.cancelled)
//                   SizedBox(
//                     width: double.infinity,
//                     child: OutlinedButton.icon(
//                       onPressed: () => _showDeleteDialog(booking),
//                       icon: const Icon(Icons.delete, size: 16),
//                       label: const Text('Delete'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.red,
//                         side: const BorderSide(color: Colors.red),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusChip(BookingStatus status) {
//     Color color;
//     String text;

//     switch (status) {
//       case BookingStatus.confirmed:
//         color = Colors.green;
//         text = 'Confirmed';
//         break;
//       case BookingStatus.cancelled:
//         color = Colors.red;
//         text = 'Cancelled';
//         break;
//       case BookingStatus.completed:
//         color = Colors.blue;
//         text = 'Completed';
//         break;
//       case BookingStatus.pending:
//         color = Colors.orange;
//         text = 'Pending';
//         break;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Widget _buildDateInfo(String title, String date, String time, IconData icon) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.blueAccent.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, size: 16, color: Colors.blueAccent),
//               const SizedBox(width: 4),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Text(
//             date,
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//           ),
//           Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//         ],
//       ),
//     );
//   }

//   void _showCancelDialog(BookingModel booking) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: const Text(
//             'Cancel Booking',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Are you sure you want to cancel your booking to ${booking.destinationName}?',
//                 style: const TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 16),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.orange.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.warning, color: Colors.orange, size: 20),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'This action cannot be undone. You may be subject to cancellation fees.',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.orange.shade700,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Keep Booking'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 context.read<BookingsCubit>().cancelBooking(booking.bookingId);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text('Cancel Booking'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showDeleteDialog(BookingModel booking) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: const Text(
//             'Delete Booking',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: const Text(
//             'Are you sure you want to permanently delete this booking record? This action cannot be undone.',
//             style: TextStyle(fontSize: 16),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 context.read<BookingsCubit>().deleteBooking(booking.bookingId);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showBookingDetails(BookingModel booking) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.85,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: Column(
//             children: [
//               // Handle
//               Container(
//                 margin: const EdgeInsets.only(top: 8),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),

//               // Header
//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Booking Details',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => Navigator.of(context).pop(),
//                       icon: const Icon(Icons.close),
//                     ),
//                   ],
//                 ),
//               ),

//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Destination Image
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.network(
//                           booking.imageUrl,
//                           height: 200,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Container(
//                               height: 200,
//                               color: Colors.grey[300],
//                               child: const Icon(
//                                 Icons.image_not_supported,
//                                 size: 50,
//                                 color: Colors.grey,
//                               ),
//                             );
//                           },
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       // Destination Info
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   booking.destinationName,
//                                   style: const TextStyle(
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   booking.destinationLocation,
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           _buildStatusChip(booking.status),
//                         ],
//                       ),

//                       const SizedBox(height: 24),

//                       _buildDetailSection('Booking Information', [
//                         _buildDetailRow('Booking ID', booking.bookingId),
//                         _buildDetailRow(
//                           'Booking Date',
//                           booking.formattedBookingDate,
//                         ),
//                         _buildDetailRow(
//                           'Trip Duration',
//                           '${booking.tripDuration} days',
//                         ),
//                       ]),

//                       const SizedBox(height: 20),

//                       _buildDetailSection('Travel Details', [
//                         _buildDetailRow(
//                           'Departure Date',
//                           booking.formattedDepartureDate,
//                         ),
//                         _buildDetailRow(
//                           'Departure Time',
//                           booking.departureTime,
//                         ),
//                         _buildDetailRow('Arrival Time', booking.arrivalTime),
//                         _buildDetailRow(
//                           'Return Date',
//                           booking.formattedReturnDate,
//                         ),
//                         _buildDetailRow(
//                           'Return Departure',
//                           booking.returnDepartureTime,
//                         ),
//                         _buildDetailRow(
//                           'Return Arrival',
//                           booking.returnArrivalTime,
//                         ),
//                       ]),

//                       const SizedBox(height: 20),

//                       _buildDetailSection('Pricing', [
//                         _buildDetailRow(
//                           'Base Price per Person',
//                           '\$${booking.price.toStringAsFixed(0)}',
//                         ),
//                         _buildDetailRow(
//                           'Number of Passengers',
//                           '${booking.passengers}',
//                         ),
//                         _buildDetailRow(
//                           'Subtotal',
//                           '\$${(booking.price * booking.passengers).toStringAsFixed(0)}',
//                         ),
//                         _buildDetailRow(
//                           'Taxes & Fees (15%)',
//                           '\$${(booking.price * booking.passengers * 0.15).toStringAsFixed(0)}',
//                         ),
//                         const Divider(),
//                         _buildDetailRow(
//                           'Total Amount',
//                           '\$${booking.totalAmount.toStringAsFixed(0)}',
//                           isTotal: true,
//                         ),
//                       ]),

//                       const SizedBox(height: 40),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDetailSection(String title, List<Widget> children) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 12),
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.grey[50],
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey[200]!),
//           ),
//           child: Column(children: children),
//         ),
//       ],
//     );
//   }

//   Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: isTotal ? 16 : 14,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               color: isTotal ? Colors.black : Colors.grey[700],
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: isTotal ? 16 : 14,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
//               color: isTotal ? Colors.blueAccent : Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
