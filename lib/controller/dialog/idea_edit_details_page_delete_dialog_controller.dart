import 'package:flutter/foundation.dart';

class IdeaEditDetailsPageDeleteDialogController extends ChangeNotifier {
  Function() onConfirmDelete;

  void confirmDelete() async {
    if (onConfirmDelete != null) onConfirmDelete();
  }
}
