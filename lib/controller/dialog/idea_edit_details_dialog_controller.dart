import 'package:flutter/foundation.dart';

class IdeaEditDetailsDialogController extends ChangeNotifier {
  Function() onConfirmDelete;

  void confirmDelete() async {
    if (onConfirmDelete != null) onConfirmDelete();
  }
}
