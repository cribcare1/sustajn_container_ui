import 'dart:io';

import 'package:flutter/cupertino.dart';

class ContainerState extends ChangeNotifier{
  bool _isSaving = false;
  BuildContext? _context;
  File? _image;
  bool? get isSaving => _isSaving;
  File? get image => _image;
  BuildContext get context => _context!;
  void setIsLoading(bool b){
    _isSaving = b;
    notifyListeners();
  }
  void setContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }
  void setImage(File? file){
    _image = file;
    notifyListeners();
  }
}