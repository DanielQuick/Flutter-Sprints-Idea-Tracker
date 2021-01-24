import 'package:flutter/material.dart';
import 'package:idea_tracker/locator.dart';
import 'package:provider/provider.dart';

class BaseView<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T controller, Widget child)
      builder;
  final Function(T) onControllerReady;
  BaseView({@required this.builder, this.onControllerReady});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends ChangeNotifier> extends State<BaseView<T>> {
  T controller = locator<T>();

  @override
  void initState() {
    if (widget.onControllerReady != null) {
      widget.onControllerReady(controller);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => controller,
      child: Consumer<T>(
        builder: widget.builder,
      ),
    );
  }
}

//  TODO: onLogoutSuccess function for profile_page_controller file
//  BaseView<PageController>(
//     onControllerReady: (controller) {
//         controller.onLogoutSuccess = () {
//         // navigate to landing page
//           Navigator.popAndPushNamed(context, "/landing");
//         }
//     },
//     builder: (context, controller, child) {
//         return Container();
//     }
// )
