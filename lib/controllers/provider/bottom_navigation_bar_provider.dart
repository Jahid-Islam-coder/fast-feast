
import 'package:flutter/cupertino.dart';


class TabIndexController extends ChangeNotifier{
  int _tabIndex = 0;

  int get tabIndex => _tabIndex;

  set tabIndex(int newValue){

    _tabIndex = newValue;
    notifyListeners();

  }

}