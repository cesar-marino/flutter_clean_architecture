import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';
import '../http/http.dart';
import './models.dart';

class RemoteSurveyResultModel {
  final String surveyId;
  final String question;
  final List<RemoteSurveyAnswertModel> answers;

  RemoteSurveyResultModel({
    @required this.surveyId,
    @required this.question,
    @required this.answers,
  });

  factory RemoteSurveyResultModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['surveyId', 'question', 'answers']))
      throw HttpError.invalidData;

    return RemoteSurveyResultModel(
      surveyId: json['surveyId'],
      question: json['question'],
      answers: json['answers']
          .map<RemoteSurveyAnswertModel>(
            (answerJson) => RemoteSurveyAnswertModel.fromJson(answerJson),
          )
          .toList(),
    );
  }

  SurveyResultEntity toEntity() {
    return SurveyResultEntity(
      surveyId: surveyId,
      question: question,
      answers: answers
          .map<SurveyAnswerEntity>((answer) => answer.toEntity())
          .toList(),
    );
  }
}
