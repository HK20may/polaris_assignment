import 'package:hive/hive.dart';
import 'package:polaris_assignment/data/models/form_data/form_data.dart';

class SaveDataLocalSource {
  Future<void> saveData(FormData currentFormData) async {
    if (!Hive.isBoxOpen("survey_form_database")) {
      await Hive.openBox("survey_form_database");
    }
    var surveyFormDb = Hive.box("survey_form_database");
    await surveyFormDb.add(currentFormData);
  }
}
