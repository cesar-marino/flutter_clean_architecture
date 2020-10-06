import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';

import '../http/http.dart';

class RemoteSurveyAnswertModel {
  final String image;
  final String answer;
  final bool isCurrentAccountAnswer;
  final int percent;

  RemoteSurveyAnswertModel({
    this.image,
    @required this.answer,
    @required this.isCurrentAccountAnswer,
    @required this.percent,
  });

  factory RemoteSurveyAnswertModel.fromJson(Map json) {
    if (!json.keys
        .toSet()
        .containsAll(['answer', 'isCurrentAccountAnswer', 'percent'])) {
      throw HttpError.invalidData;
    }

    return RemoteSurveyAnswertModel(
      image: json['image'],
      answer: json['answer'],
      isCurrentAccountAnswer: json['isCurrentAccountAnswer'],
      percent: json['percent'],
    );
  }

  SurveyAnswerEntity toEntity() {
    return SurveyAnswerEntity(
      image: image,
      answer: answer,
      isCurrentAnswer: isCurrentAccountAnswer,
      percent: percent,
    );
  }
}
