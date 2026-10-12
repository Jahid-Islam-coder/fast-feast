
import 'package:flutter/cupertino.dart';
import '../../features/restaurant/domain/entities/restaurant_entity.dart';

class SearchProvider extends ChangeNotifier{
  String _searchQuery = '';
  List<RestaurantEntity> _filteredResults = [];

  List<RestaurantEntity> get filteredResults => _filteredResults;
  void updateData(List<RestaurantEntity> nearbyRestaurants) {
    _performSearch(nearbyRestaurants);
  }

  void updateQuery(String query, List<RestaurantEntity> nearbyRestaurants) {
    _searchQuery = query.toLowerCase().trim();
    _performSearch(nearbyRestaurants);
    notifyListeners();
  }

  void _performSearch(List<RestaurantEntity> sourceList) {
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