import 'package:flutter/material.dart';
import 'package:idea_tracker/controller/page/main_page_controller.dart';
import 'package:idea_tracker/view/page/sprints_page.dart';
import 'package:idea_tracker/view/widget/state_management/base_view.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ideasTab = Navigator(
      initialRoute: "/",
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Text("Ideas Tab"),
              ),
            ),
        );
      },
    );
    final sprintsTab = Navigator(
      initialRoute: "/",
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => SprintsPage()
        );
      },
    );
    final profileTab = Navigator(
      initialRoute: "/",
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text("Profile Tab"),
            ),
          ),
        );
      },
    );

    return BaseView<MainPageController>(
      builder: (context, controller, child) {
        return Scaffold(
          body: IndexedStack(
            index: controller.tab,
            children: [
              ideasTab,
              sprintsTab,
              profileTab,
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: controller.onTabSelected,
            currentIndex: controller.tab,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.lightbulb),
                label: "Ideas",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.run_circle),
                label: "Sprints",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: "Profile",
              ),
            ],
          ),
        );
      },
    );
  }
}
