import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yalla_r7la2/core/di/dependency_injection.dart';
import 'package:yalla_r7la2/features/favorites/ui/logic/favorites_cubit.dart';
import 'package:yalla_r7la2/features/home/ui/logic/home_cubit.dart';

import '../../data/model/destination_model.dart';
import '../screens/destination_details_screen.dart';
import 'destination_card_content.dart';

class DestinationCard extends StatelessWidget {
  final DestinationModel cardData;

  const DestinationCard({super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: sl<HomeCubit>()),
                    BlocProvider.value(value: sl<FavoritesCubit>()),
                  ],
                  child: DestinationDetailsScreen(
                    destinationId: cardData.destinationId,
                  ),
                ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: DestinationCardContent(cardData: cardData),
      ),
    );
  }
}
