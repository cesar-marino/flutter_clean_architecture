import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';

class LocalSurveyModel extends Equatable {
  final String id;
  final String question;
  final DateTime date;
  final bool didAnswer;

  LocalSurveyModel({
    @required this.id,
    @required this.question,
    @required this.date,
    @required this.didAnswer,
  });

  @override
  List<Object> get props => ['id', 'question', 'date', 'didAnswer'];

  factory LocalSurveyModel.fromJson(Map json) {
    return LocalSurveyModel(
      id: json['id'],
      question: json['question'],
      date: DateTime.parse(json['date']),
      didAnswer: bool.fromEnvironment(json['didAnswer']),
    );
  }

  SurveyEntity toEntity() {
    return SurveyEntity(
      id: id,
      question: question,
      date: date,
      didAnswer: didAnswer,
    );
  }
}
