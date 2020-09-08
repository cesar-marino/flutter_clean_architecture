import 'survey_viewmodel.dart';

abstract class SurveysPresenter {
  Stream<bool> isLoadingStream;
  Stream<List<SurveyViewModel>> surveysStream;

  Future<void> loadData();
}
