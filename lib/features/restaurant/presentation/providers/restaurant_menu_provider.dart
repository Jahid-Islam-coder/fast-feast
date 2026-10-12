import 'package:flutter/cupertino.dart';
import '../../domain/entities/food_entity.dart';
import '../../domain/usecases/get_restaurant_menu_use_case.dart';

class RestaurantMenuProvider extends ChangeNotifier {
  final GetRestaurantMenuUseCase getRestaurantMenuUseCase;

  final List<FoodEntity> _foods = [];
  List<FoodEntity> _restaurantFoods = [];
  final Map<String, List<FoodEntity>> _menuCache = {};
  bool _isLoading = false;

  List<FoodEntity> get foods => _foods;
  List<FoodEntity> get restaurantFoods => _restaurantFoods;
  bool get isLoading => _isLoading;

  RestaurantMenuProvider({
    required this.getRestaurantMenuUseCase,
  });

  bool isRestaurantCached(String restaurantId) {
    return _menuCache.containsKey(restaurantId);
  }

  void setRestaurantMenu(String restaurantId, List<FoodEntity> foodData) {
    _menuCache[restaurantId] = foodData;
    _restaurantFoods = foodData;
    for (var item in foodData) {
      if (!_foods.any((f) => f.id == item.id)) {
        _foods.add(item);
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<List<FoodEntity>> fetchRestaurantMenu(String restaurantId, {bool forceRefresh = false}) async {
    if (!forceRefresh && _menuCache.containsKey(restaurantId)) {
      _restaurantFoods = _menuCache[restaurantId]!;
      _isLoading = false;
      notifyListeners();
      return _restaurantFoods;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final foodData = await getRestaurantMenuUseCase(restaurantId);

      _menuCache[restaurantId] = foodData;

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

  void getRestaurantFoods(String restaurantId) {
    if (_menuCache.containsKey(restaurantId)) {
      _restaurantFoods = _menuCache[restaurantId]!;
    } else {
      _restaurantFoods = _foods.where((data) => data.restaurantId == restaurantId).toList();
    }
    notifyListeners();
  }

  void emptyRestaurantFoods() {
    _restaurantFoods = [];
    notifyListeners();
  }

  void clearMenuCache() {
    _menuCache.clear();
    _foods.clear();
    _restaurantFoods.clear();
    _isLoading = false;
    notifyListeners();
  }
}
