import 'package:flutter/material.dart';
import 'package:idea_tracker/view/widget/state_management/base_view.dart';
import 'package:idea_tracker/controller/page/create_idea_controller.dart';

class CreateIdeaPage extends StatelessWidget {
  final String title;

  CreateIdeaPage({this.title});

  @override
  Widget build(BuildContext context) {
    return BaseView<CreateIdeaController>(
      onModelReady: (controller) {
        controller.counter = 10;
      },
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '${controller.counter}',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: controller.onIncrementFabPressed,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
