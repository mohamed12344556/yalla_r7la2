import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes.dart';
import '../../../favorites/ui/logic/favorites_cubit.dart';
import '../../data/model/destination_model.dart';

class BottomActionBarWidget extends StatelessWidget {
  final DestinationModel card;
  final Function(BuildContext, bool) onFeedbackShow;

  const BottomActionBarWidget({
    super.key,
    required this.card,
    required this.onFeedbackShow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Favorite Button
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              final isFavorite = context.read<FavoritesCubit>().isFavorite(
                card.destinationId,
              );

              return Container(
                decoration: BoxDecoration(
                  color:
                      isFavorite
                          ? Colors.red.withOpacity(0.1)
                          : Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        isFavorite
                            ? Colors.red.withOpacity(0.3)
                            : Colors.grey[300]!,
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    context.read<FavoritesCubit>().toggleFavorite(card);
                    onFeedbackShow(context, !isFavorite);
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey[600],
                      size: 24,
                      key: ValueKey(isFavorite),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(width: 16),

          // Book Now Button
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.blue[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to BookingScreen
                  Navigator.pushNamed(
                    context,
                    Routes.flightBooking,
                    arguments: card,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flight_takeoff, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Book Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
