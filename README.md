🍔 FastFeast — Food Delivery App

FastFeast is a food delivery app built with Flutter. Users can find nearby restaurants, browse their menus, search for food, add items to a cart, place orders, and track their order status.

I built this project to get practical experience with Flutter and Firebase while working on a larger application with features such as location-based restaurant discovery, payment processing, cart management, and real-time order updates.

Note: FastFeast is a portfolio project built for learning and demonstrating my Flutter development skills.  





📱 Project Overview

The main idea of FastFeast is to provide a complete food ordering experience, starting from user authentication and location selection and ending with checkout, payment, and order tracking.

The main user flow looks like this

```text
Sign In / Sign Up
       ↓
Set Delivery Location
       ↓
Find Nearby Restaurants
       ↓
Browse Food
       ↓
Add to Cart
       ↓
Checkout
       ↓
Stripe Payment
       ↓
Place Order
       ↓
Real-Time Order Tracking
```





✨ Features

🔐 Authentication & Profile

FastFeast uses Firebase Authentication for user accounts.


* Sign in
* Sign up
* Google authentication
* Forgot password
* Authentication state handling
* User profile management
* Order history
* Saved delivery addresses

The app uses an AuthWrapper to check the user's authentication state and decide which part of the application should be displayed.  





📍 Location & Delivery Address

Restaurant discovery is based on the user's location.

Users can:

* Get their current location using GPS
* Select a custom delivery address
* Location search and address selection
* Manage their delivery address
* Find restaurants within a specific radius

I used Geofire with Firebase Realtime Database to perform location-based restaurant queries.

For example:

```text
User Location
     ↓
Latitude / Longitude
     ↓
Geofire Radius Query
     ↓
Nearby Restaurants
```
This allows the restaurant list to change based on the user's selected location.  





🏪 Restaurant Discovery

Users can browse restaurants based on their location and food categories.

Some of the available categories are:

🍔 Burgers
🍕 Pizza
🍝 Pasta
🍰 Cake

Categories can be used to filter the available restaurants and food items nearby.

The restaurant listing includes information such as:


* Nearby restaurant listing
* Distance-based restaurant discovery
* Restaurant images
* Restaurant name
* Address
* Ratings
* Complete restaurant menu

Each restaurant also has its own detail page where users can view the available food items.  





🍔 Food & Recommendations

Users can browse food from every restaurants also recommended items from different restaurants.

Food Details

The food details page includes:

* Food image
* Food name
* Description
* Price
* Quantity selector
* Add to Cart
* Buy Now

I also created reusable food cards so items can be added to the cart directly from restaurant menus and recommendation sections.  





🔍 Search

FastFeast has a search page for finding restaurants and food items.

* Search restaurants
* Search food items
* Filter results while typing
* Display nearby search results

Search-related state and logic are handled through SearchProvider.





🛒 Cart & Checkout

The cart allows users to review and modify their order before checkout.

Users can:

* Add food items
* Increase or decrease quantity
* Remove items
* View the subtotal
* Review their order

The checkout page has:

* Delivery address
* Cart items
* Item prices
* Delivery fee
* Total amount
* Payment option





💳 Stripe Payment

FastFeast uses Stripe for card payments.

The basic flow is:

```text
Cart
 ↓
Checkout
 ↓
Payment
 ↓
Stripe
 ↓
Payment Result
 ↓
Order
```
Sensitive payment credentials and configuration values are not included in the public repository.





📦 Order Management

After completing checkout, FastFeast stores the order information in Firebase.

Order records contain information like:

* Ordered items
* Quantities
* Prices
* Order timestamp
* Delivery address
* Order status

Users can view their old purchases through the view order section in profile page.

View Order

The order history screen provides:

* Old orders
* Order details
* Ordered food items
* Pricing information
* Delivery information
* Current/old order status





🚚 Real-Time Order Tracking

FastFeast has a visual order tracking experience that shows the different stages of a delivery.

🟢 Placed
   ↓
🟢 In Progress
   ↓
🟢 Completed
   ↓
🟢 Canceled

The tracking screen updates according to the current order status stored in Firebase.
