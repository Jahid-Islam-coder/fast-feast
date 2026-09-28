# Refactor Codebase: Clean Unnecessary Files and Standardize Reusable Appbar & Text

This plan outlines the cleanup of unnecessary files and the codebase-wide refactoring to use the project's reusable appbar and text components (`CustomAppbar` / reusable appbar patterns and `ReusableText`) everywhere while keeping the exact same design and size.

## User Review Required

> [!IMPORTANT]
> - **Unnecessary Files**: We will delete unused/empty files (such as `lib/views/entrypoint.dart`).
> - **Appbar Standardization**: We will ensure that pages utilizing custom headers or standardizing appbars use reusable components where applicable.
> - **Text Standardization**: We will replace raw `Text(...)` widgets with `ReusableText(text: ..., style: ...)` across all views and components while preserving existing styling, size, and constraints.

## Open Questions

- None. The project already contains `ReusableText` (`lib/common/reusable_text.dart`) and `CustomAppbar` (`lib/common/custom_appbar.dart`).

## Proposed Changes

### Clean Unnecessary Files
#### [DELETE] [entrypoint.dart](file:///C:/Users/Jahid Islam Mamun/StudioProjects/fastfeast/lib/views/entrypoint.dart)

### Refactor Views and Components to Use `ReusableText` and Reusable Appbar
We will systematically update all UI files in `lib/views/` and `lib/common/` where raw `Text` widgets are used, replacing them with `ReusableText` while keeping the exact same styles and properties.

- [MODIFY] [set_address_page.dart](file:///C:/Users/Jahid Islam Mamun/StudioProjects/fastfeast/lib/views/address/set_address_page.dart)
- [MODIFY] [forgot_password_page.dart](file:///C:/Users/Jahid Islam Mamun/StudioProjects/fastfeast/lib/views/auth/forgot_password_page.dart)
- [MODIFY] [bottom_navigation_bar.dart](file:///C:/Users/Jahid Islam Mamun/StudioProjects/fastfeast/lib/views/bottom_navigation_bar/bottom_navigation_bar.dart)
- [MODIFY] [cart_page.dart](file:///C:/Users/Jahid Islam Mamun/StudioProjects/fastfeast/lib/views/cart/cart_page.dart)
- [MODIFY] [checkout_page.dart](file:///C:/Users/Jahid Islam Mamun/StudioProjects/fastfeast/lib/views/cart/checkout_page.dart)
- [MODIFY] [order_success_page.dart](file:///C:/Users/Jahid Islam Mamun/StudioProjects/fastfeast/lib/views/cart/order_success_page.dart)
- [MODIFY] [order_tracking_page.dart](file:///C:/Users/Jahid Islam Mamun/StudioProjects/fastfeast/lib/views/cart/order_tracking_page.dart)
- [MODIFY] [food_page.dart](file:///C:/Users/Jahid Islam Mamun/StudioProjects/fastfeast/lib/views/food/food_page.dart)
- [MODIFY] [all_nearby_restaurants.dart](file:///C:/Users/Jahid Islam Mamun/StudioProjects/fastfeast/lib/views/home/all_nearby_restaurants.dart)
- [MODIFY] [recommendations_page.dart](file:///C:/Users/Jahid Islam Mamun/StudioProjects/fastfeast/lib/views/home/recommendations_page.dart)
- [MODIFY] [food_widget.dart](file:///C:/Users/Jahid Islam Mamun/StudioProjects/fastfeast/lib/views/home/widgets/food_widget.dart)
- [MODIFY] [restaurant_widget.dart](file:///C:/Users/Jahid Islam Mamun/StudioProjects/fastfeast/lib/views/home/widgets/restaurant_widget.dart)
- [MODIFY] [restaurants_page.dart](file:///C:/Users/Jahid Islam Mamun/StudioProjects/fastfeast/lib/views/home/widgets/restaurants_page.dart)
- [MODIFY] [onboarding_page.dart](file:///C:/Users/Jahid Islam Mamun/StudioProjects/fastfeast/lib/views/onboarding/onboarding_page.dart)
- [MODIFY] [order_history_page.dart](file:///C:/Users/Jahid Islam Mamun/StudioProjects/fastfeast/lib/views/profile/order_history_page.dart)
- [MODIFY] [profile_page.dart](file:///C:/Users/Jahid Islam Mamun/StudioProjects/fastfeast/lib/views/profile/profile_page.dart)
- [MODIFY] [search_page.dart](file:///C:/Users/Jahid Islam Mamun/StudioProjects/fastfeast/lib/views/search/search_page.dart)

## Verification Plan

### Automated Tests
- Run `flutter test` to ensure all existing widget tests and unit tests pass successfully.
- Run `flutter analyze` to check for compilation errors, linter warnings, or unused imports.

### Manual Verification
- Review updated code structures and ensure UI components maintain their design integrity.
