import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';

import 'components/components.dart';

class SurveysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.strings.surveys), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: CarouselSlider(
          options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 1,
          ),
          items: [
            SurveyItem(),
            SurveyItem(),
            SurveyItem(),
          ],
        ),
      ),
    );
  }
}
