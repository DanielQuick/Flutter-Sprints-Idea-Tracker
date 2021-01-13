import 'package:get_it/get_it.dart';
import 'package:idea_tracker/controller/page/main_page_controller.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory(() => MainPageController());
}
