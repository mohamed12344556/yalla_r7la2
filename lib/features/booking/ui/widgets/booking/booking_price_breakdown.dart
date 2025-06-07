import 'package:flutter/material.dart';
import 'package:yalla_r7la2/core/utils/booking_utils.dart';

class BookingPriceBreakdown extends StatelessWidget {
  final double basePrice;
  final int passengers;

  const BookingPriceBreakdown({
    super.key,
    required this.basePrice,
    required this.passengers,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = BookingUtils.calculateSubtotal(basePrice, passengers);
    final taxes = BookingUtils.calculateTaxes(basePrice, passengers);
    final totalPrice = BookingUtils.calculateTotalPrice(basePrice, passengers);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Breakdown',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              _buildPriceRow(
                'Base Price',
                '\$${basePrice.toStringAsFixed(0)} x $passengers ${BookingUtils.getPassengerText(passengers)}',
                '\$${subtotal.toStringAsFixed(0)}',
              ),
              const SizedBox(height: 12),
              _buildPriceRow(
                'Taxes & Fees',
                '15%',
                '\$${taxes.toStringAsFixed(0)}',
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              _buildPriceRow(
                'Total Amount',
                '',
                '\$${totalPrice.toStringAsFixed(0)}',
                isTotal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(
    String title,
    String subtitle,
    String price, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: isTotal ? 18 : 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                color: isTotal ? Colors.blueAccent : Colors.black87,
              ),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
          ],
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.blueAccent : Colors.black87,
          ),
        ),
      ],
    );
  }
}
