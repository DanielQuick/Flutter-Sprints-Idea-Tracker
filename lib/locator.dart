import 'package:get_it/get_it.dart';
import 'package:idea_tracker/controller/dialog/idea_edit_details_page_delete_dialog_controller.dart';
import 'package:idea_tracker/controller/dialog/landing_page_recover_password_dialog_controller.dart';
import 'package:idea_tracker/controller/page/create_idea_page_controller.dart';
import 'package:idea_tracker/controller/page/idea_edit_details_page_controller.dart';
import 'package:idea_tracker/controller/page/ideas_main_page_controller.dart';
import 'package:idea_tracker/controller/page/main_page_controller.dart';
import 'service/services.dart';
import 'package:idea_tracker/controller/page/sprints_page_controller.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory(() => MainPageController());
  locator.registerFactory(() => CreateIdeaPageController());
  locator.registerFactory(() => IdeaEditDetailsPageController());
  locator.registerFactory(() => IdeasMainPageController());
  locator.registerFactory(() => IdeaEditDetailsPageDeleteDialogController());
  locator.registerFactory(() => LandingPageRecoverPasswordDialogController());
  locator.registerFactory(() => SprintsPageController());

  /// Services
  locator.registerSingleton(IdeaService());
  locator.registerSingleton(SprintService());
  locator.registerSingleton(AuthenticationService());
  locator.registerSingleton(UserService());
}
