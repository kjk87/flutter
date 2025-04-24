import 'package:flutter/material.dart';

Widget rankingHelpModal(BuildContext context) {
  return SizedBox(
    height: 250,
    child: Column(
      children: [
        Card(
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset('assets/images/ranking_point.PNG'),
                  const Text('1,000,000,000')
                ],
              ),
              const Text("This week's prize money")
            ],
          ) 
        ),
        const Text('DIVCow pays out prizes to players who rank high in each game on a weekly basis.'),
        TextButton(
          child: const Text(
            'OK',
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          onPressed:(){ Navigator.pop(context); }
        )
      ],
    ),
  );
}
