import 'package:flutter/foundation.dart';

class IdeaEditDetailsDialogController extends ChangeNotifier {
  Function() onConfirmDelete;

  void confirmDelete() async {
    // TODO: delete idea throught IdeaService
    await Future.delayed(Duration(milliseconds: 1000), () {});
    if (onConfirmDelete != null) onConfirmDelete();
    print("Idea deleted");
  }
}
