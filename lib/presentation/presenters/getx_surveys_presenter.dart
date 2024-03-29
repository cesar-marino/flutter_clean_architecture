import 'package:meta/meta.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSurveysPresenter implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  final _isLoading = true.obs;
  final _surveys = Rx<List<SurveyViewModel>>();

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  @override
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  GetxSurveysPresenter({@required this.loadSurveys});

  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      final surveys = await loadSurveys.load();

      _surveys.value = surveys
          .map(
            (survey) => SurveyViewModel(
              id: survey.id,
              question: survey.question,
              date: DateFormat('dd MMM yyyy').format(survey.date),
              didAnswer: survey.didAnswer,
            ),
          )
          .toList();
    } on DomainError {
      _surveys.subject.addError(UIError.unexpeted.description);
    } finally {
      _isLoading.value = false;
    }
  }
}
