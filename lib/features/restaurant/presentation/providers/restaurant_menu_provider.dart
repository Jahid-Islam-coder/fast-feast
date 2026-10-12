import 'package:flutter/cupertino.dart';
import '../../data/models/food_model.dart';
import '../../domain/usecases/get_restaurant_menu_use_case.dart';

class RestaurantMenuProvider extends ChangeNotifier {
  final GetRestaurantMenuUseCase? getRestaurantMenuUseCase;

  final List<FoodModel> _foods = [];
  List<FoodModel> _restaurantFoods = [];
  final Map<String, List<FoodModel>> _menuCache = {};
  bool _isLoading = false;

  List<FoodModel> get foods => _foods;
  List<FoodModel> get restaurantFoods => _restaurantFoods;
  bool get isLoading => _isLoading;

  RestaurantMenuProvider({
    this.getRestaurantMenuUseCase,
  });

  bool isRestaurantCached(String restaurantId) {
    return _menuCache.containsKey(restaurantId);
  }

  void setRestaurantMenu(String restaurantId, List<FoodModel> foodData) {
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

  Future<List<FoodModel>> fetchRestaurantMenu(String restaurantId, {bool forceRefresh = false}) async {
    if (!forceRefresh && _menuCache.containsKey(restaurantId)) {
      _restaurantFoods = _menuCache[restaurantId]!;
      _isLoading = false;
      notifyListeners();
      return _restaurantFoods;
    }

    _isLoading = true;
    notifyListeners();

    try {
      if (getRestaurantMenuUseCase != null) {
        final foodEntities = await getRestaurantMenuUseCase!(restaurantId);
        final foodData = foodEntities.map((e) => e is FoodModel ? e : FoodModel(
          id: e.id,
          name: e.name,
          image: e.image,
          price: e.price,
          description: e.description,
          category: e.category,
          restaurantId: e.restaurantId,
        )).toList();

        _menuCache[restaurantId] = foodData;

        for (var item in foodData) {
          if (!_foods.any((f) => f.id == item.id)) {
            _foods.add(item);
          }
        }

        _restaurantFoods = foodData;
      }
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
