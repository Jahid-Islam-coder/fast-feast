import 'package:flutter/cupertino.dart';

class CategoryController extends ChangeNotifier {

  String _category = '';
  String get categoryValue => _category;

  set updateCategory(String value){

    if(_category != value){
      _category = value;
      notifyListeners();
    }
  }

  String _title = '';
  String get titleValue => _title;

  set updateTitle(String value){

    if(_title != value){
      _title = value;
      notifyListeners();
    }
  }


}