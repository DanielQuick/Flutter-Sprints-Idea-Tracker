import 'package:get_it/get_it.dart';
import 'package:idea_tracker/controller/dialog/idea_edit_details_dialog_controller.dart';
import 'package:idea_tracker/controller/page/create_idea_page_controller.dart';
import 'package:idea_tracker/controller/page/idea_edit_details_page_controller.dart';
import 'package:idea_tracker/controller/page/main_page_controller.dart';
import 'service/services.dart';

GetIt locator = GetIt.instance;

void setupLocator() {

  locator.registerFactory(() => MainPageController());
  locator.registerFactory(() => CreateIdeaPageController());
  locator.registerFactory(() => IdeaEditDetailsPageController());
  locator.registerFactory(() => IdeaEditDetailsDialogController());

  /// Services
  locator.registerSingleton(IdeaService());
  locator.registerSingleton(SprintService());
  locator.registerSingleton(AuthenticationService());
  locator.registerSingleton(UserService());
}
