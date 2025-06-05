// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:yalla_r7la2/features/favorites/ui/logic/favorites_cubit.dart';

// import '../../data/model/destination_model.dart';

// class DestinationDetailsScreen extends StatefulWidget {
//   final DestinationModel card;

//   const DestinationDetailsScreen({super.key, required this.card});

//   @override
//   State<DestinationDetailsScreen> createState() =>
//       _DestinationDetailsScreenState();
// }

// class _DestinationDetailsScreenState extends State<DestinationDetailsScreen>
//     with TickerProviderStateMixin {
//   final PageController _pageController = PageController();
//   int _currentImageIndex = 0;
//   late AnimationController _fadeController;
//   late AnimationController _scaleController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
//     );
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
//     );

//     // Start animations
//     _fadeController.forward();
//     _scaleController.forward();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _fadeController.dispose();
//     _scaleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: CustomScrollView(
//         slivers: [
//           // Enhanced App Bar with Image
//           SliverAppBar(
//             expandedHeight: 320,
//             pinned: true,
//             backgroundColor: Colors.white,
//             elevation: 0,
//             leading: Container(
//               margin: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.9),
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.15),
//                     blurRadius: 12,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: IconButton(
//                 icon: const Icon(
//                   Icons.arrow_back_ios_new,
//                   color: Colors.black,
//                   size: 20,
//                 ),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//             ),
//             actions: [
//               Container(
//                 margin: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.9),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.15),
//                       blurRadius: 12,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: BlocBuilder<FavoritesCubit, FavoritesState>(
//                   builder: (context, state) {
//                     final isFavorite = context
//                         .read<FavoritesCubit>()
//                         .isFavorite(widget.card.destinationId);

//                     return IconButton(
//                       icon: AnimatedSwitcher(
//                         duration: const Duration(milliseconds: 300),
//                         transitionBuilder: (child, animation) {
//                           return ScaleTransition(
//                             scale: animation,
//                             child: child,
//                           );
//                         },
//                         child: Icon(
//                           isFavorite ? Icons.favorite : Icons.favorite_border,
//                           color: isFavorite ? Colors.red : Colors.black87,
//                           size: 22,
//                           key: ValueKey(isFavorite),
//                         ),
//                       ),
//                       onPressed: () {
//                         context.read<FavoritesCubit>().toggleFavorite(
//                           widget.card,
//                         );

//                         // Enhanced feedback with haptic
//                         _showFeedbackSnackBar(context, !isFavorite);
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//             flexibleSpace: FlexibleSpaceBar(
//               background: Stack(
//                 children: [
//                   // Enhanced Image Carousel
//                   PageView.builder(
//                     controller: _pageController,
//                     onPageChanged: (index) {
//                       setState(() {
//                         _currentImageIndex = index;
//                       });
//                     },
//                     itemCount: widget.card.images?.length ?? 1,
//                     itemBuilder: (context, index) {
//                       return Hero(
//                         tag: 'destination_${widget.card.destinationId}_$index',
//                         child: Container(
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               image: NetworkImage(
//                                 widget.card.images?[index] ??
//                                     widget.card.imageUrl,
//                               ),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),

//                   // Enhanced gradient overlay
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.transparent,
//                           Colors.black.withOpacity(0.1),
//                           Colors.black.withOpacity(0.4),
//                         ],
//                         stops: const [0.0, 0.7, 1.0],
//                       ),
//                     ),
//                   ),

//                   // Enhanced image indicators
//                   if ((widget.card.images?.length ?? 0) > 1)
//                     Positioned(
//                       bottom: 20,
//                       left: 0,
//                       right: 0,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: List.generate(
//                           widget.card.images!.length,
//                           (index) => AnimatedContainer(
//                             duration: const Duration(milliseconds: 300),
//                             margin: const EdgeInsets.symmetric(horizontal: 4),
//                             width: index == _currentImageIndex ? 12 : 8,
//                             height: 8,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(4),
//                               color:
//                                   index == _currentImageIndex
//                                       ? Colors.white
//                                       : Colors.white.withOpacity(0.5),
//                               boxShadow: [
//                                 if (index == _currentImageIndex)
//                                   BoxShadow(
//                                     color: Colors.white.withOpacity(0.5),
//                                     blurRadius: 8,
//                                     spreadRadius: 2,
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),

//           // Enhanced Content
//           SliverToBoxAdapter(
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: ScaleTransition(
//                 scale: _scaleAnimation,
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(24),
//                       topRight: Radius.circular(24),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Title and Rating Section
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     widget.card.name ?? 'Destination',
//                                     style: const TextStyle(
//                                       fontSize: 28,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black87,
//                                       height: 1.2,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         Icons.location_on,
//                                         size: 18,
//                                         color: Colors.blueAccent,
//                                       ),
//                                       const SizedBox(width: 6),
//                                       Expanded(
//                                         child: Text(
//                                           widget.card.location ??
//                                               'Unknown Location',
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.grey[600],
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             if (widget.card.rating != null)
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 16,
//                                   vertical: 10,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Colors.blueAccent,
//                                       Colors.blue[700]!,
//                                     ],
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomRight,
//                                   ),
//                                   borderRadius: BorderRadius.circular(20),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.blueAccent.withOpacity(0.3),
//                                       blurRadius: 8,
//                                       offset: const Offset(0, 4),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const Icon(
//                                       Icons.star,
//                                       color: Colors.white,
//                                       size: 18,
//                                     ),
//                                     const SizedBox(width: 6),
//                                     Text(
//                                       widget.card.rating!.toStringAsFixed(1),
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                           ],
//                         ),

//                         const SizedBox(height: 24),

//                         // Price Section
//                         Container(
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 Colors.blueAccent.withOpacity(0.1),
//                                 Colors.blue.withOpacity(0.05),
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(
//                               color: Colors.blueAccent.withOpacity(0.2),
//                               width: 1,
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Starting Price',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey[600],
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   RichText(
//                                     text: TextSpan(
//                                       children: [
//                                         TextSpan(
//                                           text:
//                                               '\$${widget.card.price.toStringAsFixed(0) ?? '0'}',
//                                           style: const TextStyle(
//                                             fontSize: 24,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.blueAccent,
//                                           ),
//                                         ),
//                                         TextSpan(
//                                           text: ' /person',
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.grey[600],
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               if (widget.card.category != null)
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 16,
//                                     vertical: 8,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(12),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withOpacity(0.1),
//                                         blurRadius: 4,
//                                         offset: const Offset(0, 2),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Text(
//                                     widget.card.category!,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.blueAccent,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 24),

//                         // Description Section
//                         _buildSection(
//                           'About This Destination',
//                           widget.card.description ??
//                               'Discover this amazing destination with breathtaking views and unforgettable experiences. Perfect for travelers seeking adventure and natural beauty.',
//                         ),

//                         const SizedBox(height: 24),

//                         // Features Section
//                         if (widget.card.features != null &&
//                             widget.card.features!.isNotEmpty)
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildSectionTitle('What\'s Included'),
//                               const SizedBox(height: 12),
//                               Wrap(
//                                 spacing: 12,
//                                 runSpacing: 12,
//                                 children:
//                                     widget.card.features!.map((feature) {
//                                       return Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 16,
//                                           vertical: 10,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.circular(
//                                             20,
//                                           ),
//                                           border: Border.all(
//                                             color: Colors.blueAccent
//                                                 .withOpacity(0.3),
//                                           ),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.black.withOpacity(
//                                                 0.05,
//                                               ),
//                                               blurRadius: 4,
//                                               offset: const Offset(0, 2),
//                                             ),
//                                           ],
//                                         ),
//                                         child: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Icon(
//                                               Icons.check_circle,
//                                               size: 16,
//                                               color: Colors.blueAccent,
//                                             ),
//                                             const SizedBox(width: 8),
//                                             Text(
//                                               feature,
//                                               style: const TextStyle(
//                                                 color: Colors.blueAccent,
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 14,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     }).toList(),
//                               ),
//                               const SizedBox(height: 24),
//                             ],
//                           ),

//                         // Map Section
//                         _buildSection(
//                           'Location',
//                           null,
//                           child: Container(
//                             height: 180,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[100],
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(color: Colors.grey[300]!),
//                             ),
//                             child: Stack(
//                               children: [
//                                 Center(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.map_outlined,
//                                         size: 48,
//                                         color: Colors.grey[400],
//                                       ),
//                                       const SizedBox(height: 12),
//                                       Text(
//                                         'Interactive Map',
//                                         style: TextStyle(
//                                           color: Colors.grey[600],
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         'Coming Soon',
//                                         style: TextStyle(
//                                           color: Colors.grey[500],
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 12,
//                                   right: 12,
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 8,
//                                       vertical: 4,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Colors.blueAccent,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: const Text(
//                                       'View',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 100), // Space for bottom button
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),

//       // Enhanced Bottom booking button
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 20,
//               offset: const Offset(0, -8),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Favorite Button
//             BlocBuilder<FavoritesCubit, FavoritesState>(
//               builder: (context, state) {
//                 final isFavorite = context.read<FavoritesCubit>().isFavorite(
//                   widget.card.destinationId,
//                 );

//                 return Container(
//                   decoration: BoxDecoration(
//                     color:
//                         isFavorite
//                             ? Colors.red.withOpacity(0.1)
//                             : Colors.grey[100],
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color:
//                           isFavorite
//                               ? Colors.red.withOpacity(0.3)
//                               : Colors.grey[300]!,
//                     ),
//                   ),
//                   child: IconButton(
//                     onPressed: () {
//                       context.read<FavoritesCubit>().toggleFavorite(
//                         widget.card,
//                       );
//                       _showFeedbackSnackBar(context, !isFavorite);
//                     },
//                     icon: AnimatedSwitcher(
//                       duration: const Duration(milliseconds: 300),
//                       child: Icon(
//                         isFavorite ? Icons.favorite : Icons.favorite_border,
//                         color: isFavorite ? Colors.red : Colors.grey[600],
//                         size: 24,
//                         key: ValueKey(isFavorite),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),

//             const SizedBox(width: 16),

//             // Book Now Button
//             Expanded(
//               child: Container(
//                 height: 56,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.blueAccent, Colors.blue[700]!],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.blueAccent.withOpacity(0.4),
//                       blurRadius: 12,
//                       offset: const Offset(0, 6),
//                     ),
//                   ],
//                 ),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     _showBookingDialog(context);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     shadowColor: Colors.transparent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.flight_takeoff, color: Colors.white, size: 20),
//                       SizedBox(width: 8),
//                       Text(
//                         'Book Now',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSection(String title, String? content, {Widget? child}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle(title),
//         const SizedBox(height: 12),
//         if (child != null)
//           child
//         else if (content != null)
//           Text(
//             content,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[700],
//               height: 1.6,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//         color: Colors.black87,
//       ),
//     );
//   }

//   void _showFeedbackSnackBar(BuildContext context, bool isAdded) {
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(
//               isAdded ? Icons.favorite : Icons.favorite_border,
//               color: Colors.white,
//               size: 20,
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 isAdded ? 'Added to favorites!' : 'Removed from favorites!',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: isAdded ? Colors.green[600] : Colors.orange[600],
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//         action: SnackBarAction(
//           label: 'View All',
//           textColor: Colors.white,
//           onPressed: () {
//             Navigator.pushNamed(context, '/favorites');
//           },
//         ),
//       ),
//     );
//   }

//   void _showBookingDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Row(
//             children: [
//               Icon(Icons.flight_takeoff, color: Colors.blueAccent),
//               const SizedBox(width: 12),
//               const Text(
//                 'Book Trip',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Ready to book ${widget.card.name}?',
//                 style: const TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 16),
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.blueAccent.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.info_outline, color: Colors.blueAccent),
//                     const SizedBox(width: 12),
//                     const Expanded(
//                       child: Text(
//                         'Booking feature coming soon! You can save this destination to favorites for now.',
//                         style: TextStyle(fontSize: 14),
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
//               child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 context.read<FavoritesCubit>().toggleFavorite(widget.card);
//                 _showFeedbackSnackBar(context, true);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blueAccent,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text('Add to Favorites'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
