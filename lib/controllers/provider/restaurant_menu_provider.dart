import 'package:flutter/cupertino.dart';
import '../../models/foods_model.dart';
import '../services/restaurants_services/restaurant_services.dart';

class RestaurantMenuProvider extends ChangeNotifier {
  final List<FoodModel> _foods = [];
  List<FoodModel> _restaurantFoods = [];
  final Map<String, List<FoodModel>> _menuCache = {};
  bool _isLoading = false;

  List<FoodModel> get foods => _foods;
  List<FoodModel> get restaurantFoods => _restaurantFoods;
  bool get isLoading => _isLoading;

  // check if restaurant menu is cached
  bool isRestaurantCached(String restaurantId) {
    return _menuCache.containsKey(restaurantId);
  }

  // fetch restaurant menu (uses cache if available)
  Future<List<FoodModel>> fetchRestaurantMenu(String restaurantId, {bool forceRefresh = false}) async {
    // return cached list if we already have it
    if (!forceRefresh && _menuCache.containsKey(restaurantId)) {
      _restaurantFoods = _menuCache[restaurantId]!;
      _isLoading = false;
      notifyListeners();
      return _restaurantFoods;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final foodData = await RestaurantServices.getRestaurantMenu(restaurantId);

      // save to memory cache
      _menuCache[restaurantId] = foodData;

      // append to global food list without dups
      for (var item in foodData) {
        if (!_foods.any((f) => f.id == item.id)) {
          _foods.add(item);
        }
      }

      _restaurantFoods = foodData;
    } catch (e) {
      debugPrint("Error fetching restaurant menu ($restaurantId): $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _restaurantFoods;
  }

  // fetch menus for a list of restaurants
  Future<void> fetchMenusForRestaurants(List<String> restaurantIds, {bool forceRefresh = false}) async {
    if (restaurantIds.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final idsToFetch = forceRefresh
          ? restaurantIds
          : restaurantIds.where((id) => !_menuCache.containsKey(id)).toList();

      if (idsToFetch.isNotEmpty) {
        await Future.wait(idsToFetch.map((id) => fetchRestaurantMenu(id, forceRefresh: forceRefresh)));
      }
    } catch (e) {
      debugPrint("Error in parallel menu prefetching: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFoods(String restaurantId) async {
    await fetchRestaurantMenu(restaurantId);
  }

  // filter food list by restaurant id
  void getRestaurantFoods(String restaurantId) {
    if (_menuCache.containsKey(restaurantId)) {
      _restaurantFoods = _menuCache[restaurantId]!;
    } else {
      _restaurantFoods = _foods.where((data) => data.restaurantId == restaurantId).toList();
    }
    notifyListeners();
  }

  // reset current restaurant selection
  void emptyRestaurantFoods() {
    _restaurantFoods = [];
    notifyListeners();
  }

  // wipe menu cache
  void clearMenuCache() {
    _menuCache.clear();
    _foods.clear();
    _restaurantFoods.clear();
    _isLoading = false;
    notifyListeners();
  }
}

