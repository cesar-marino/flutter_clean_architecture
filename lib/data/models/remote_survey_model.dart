import 'package:curso/domain/entities/entities.dart';
import 'package:meta/meta.dart';

class RemoteSurveyModel {
  final String id;
  final String question;
  final String date;
  final bool didAnswer;

  RemoteSurveyModel({
    @required this.id,
    @required this.question,
    @required this.date,
    @required this.didAnswer,
  });

  factory RemoteSurveyModel.fromJson(Map json) {
    return RemoteSurveyModel(
      id: json['id'],
      question: json['question'],
      date: json['date'],
      didAnswer: json['didAnswer'],
    );
  }

  SurveyEntity toEntity() {
    return SurveyEntity(
      id: id,
      question: question,
      date: DateTime.parse(date),
      didAnswer: didAnswer,
    );
  }
}
