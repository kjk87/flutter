import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _currentIndex = 0;
  final List<BannerItem> _banners = [
    BannerItem(
      imageUrl: 'assets/images/banner1.jpg',
      link: '/event/1',
      title: '신규 이벤트',
    ),
    BannerItem(
      imageUrl: 'assets/images/banner2.jpg',
      link: '/notice/2',
      title: '업데이트 안내',
    ),
    BannerItem(
      imageUrl: 'assets/images/banner3.jpg',
      link: '/reward/game',
      title: '미니게임 오픈',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterCarousel(
          options: CarouselOptions(
            height: 200,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: _banners.map((banner) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, banner.link);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(banner.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_currentIndex + 1}/${_banners.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BannerItem {
  final String imageUrl;
  final String link;
  final String title;

  BannerItem({
    required this.imageUrl,
    required this.link,
    required this.title,
  });
}
