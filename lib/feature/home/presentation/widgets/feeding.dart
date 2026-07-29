import 'package:flutter/material.dart';




class FeedingCard extends StatefulWidget {
  const FeedingCard({
    super.key,

  });

  @override
  State<FeedingCard> createState() => _FeedingCardState();
}

class _FeedingCardState extends State<FeedingCard> {
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: _onTap,
      child: Card(
        child: Center(
          child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.food_bank,
              size: 70,
              color: Colors.cyan,
            ),
            const SizedBox(height: 8),
            const Text(
              "Feeding",
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  void _onTap() {
  }
}