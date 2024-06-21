import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';

class CardCarousel extends StatefulWidget {
  final List<CardData> cards;

  const CardCarousel({Key? key, required this.cards}) : super(key: key);

  @override
  _CardCarouselState createState() => _CardCarouselState();
}

class _CardCarouselState extends State<CardCarousel> {
  int _currentPageIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 150,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 7),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            pauseAutoPlayOnTouch: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) => setState(() => _currentPageIndex = index),
          ),
          items: widget.cards.map((card) => _buildCarouselItem(card)).toList(),
          carouselController: _carouselController,
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.cards.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPageIndex == entry.key
                      ? Colors.blueAccent
                      : Colors.white
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(CardData card) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.title,
                style: CustomTextStyle.poppins3.copyWith(color: Colors.black),
              ),
              SizedBox(height: 8.0),
              Text(
                card.detail,
                style: CustomTextStyle.poppins4.copyWith(fontSize: 8),
              ),
            ],
          ),
      ),
    );
  }
}

class CardData {
  final String title;
  final String detail;

  const CardData({required this.title, required this.detail});
}
