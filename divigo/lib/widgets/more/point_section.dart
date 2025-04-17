import 'package:flutter/material.dart';

class PointSection extends StatelessWidget {
  const PointSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '포인트',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPointCard(
                  context,
                  title: '보유 포인트',
                  amount: '12,500 P',
                  onTap: () {
                    Navigator.pushNamed(context, '/more/points/history');
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPointCard(
                  context,
                  title: '포인트 교환',
                  amount: 'DIVCHAIN/USDT',
                  onTap: () {
                    Navigator.pushNamed(context, '/more/points/exchange');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPointCard(
    BuildContext context, {
    required String title,
    required String amount,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
