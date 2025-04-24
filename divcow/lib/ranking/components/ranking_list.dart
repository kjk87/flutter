
import 'package:flutter/material.dart';

Widget rankingList(List list) {

  return GridView.count(
    crossAxisCount: 1,
    scrollDirection: Axis.vertical,
    childAspectRatio: 3,
    children: List.generate(list.length, (index) {
      return Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    list[index]['image'],
                    width: 50,
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  children: [
                    Text(list[index]['name']),
                    Row(
                      children: [
                        Image.asset('assets/images/ranking_point.PNG'),
                        const Text('100,000')
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network( list[index]['image'], width: 25, ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network( list[index]['image'], width: 25, ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network( list[index]['image'], width: 25, ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network( list[index]['image'], width: 25, ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network( list[index]['image'], width: 25, ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      );
    })

  );
}
