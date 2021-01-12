import 'package:get_it/get_it.dart';
import 'package:idea_tracker/controller/page/create_idea_controller.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => CreateIdeaController());
}
