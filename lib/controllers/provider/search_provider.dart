
import 'package:flutter/cupertino.dart';

import '../../models/restaurants_model.dart';

class SearchProvider extends ChangeNotifier{
  String _searchQuery = '';
  List<RestaurantDetailModel> _filteredResults = [];

  List<RestaurantDetailModel> get filteredResults => _filteredResults;
  void updateData(List<RestaurantDetailModel> nearbyRestaurants) {
    _performSearch(nearbyRestaurants);
  }

  void updateQuery(String query, List<RestaurantDetailModel> nearbyRestaurants) {
    _searchQuery = query.toLowerCase().trim();
    _performSearch(nearbyRestaurants);
    notifyListeners();
  }

  void _performSearch(List<RestaurantDetailModel> sourceList) {
    if (_searchQuery.isEmpty) {
      _filteredResults = [];
    } else {
      _filteredResults = sourceList.where((res) {
        bool nameMatch = res.name.toLowerCase().contains(_searchQuery);
        
        bool keywordMatch = false;
        if (res.searchKeywords != null) {
          keywordMatch = res.searchKeywords!.keys.any((key) => 
            key.toString().toLowerCase().contains(_searchQuery) && res.searchKeywords![key] == true
          );
        }

        return nameMatch || keywordMatch;
      }).toList();
    }
  }


}