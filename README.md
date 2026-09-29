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





🚚 Real-Time Order Tracking On Google Map

FastFeast has a visual order tracking experience that shows the different stages of a delivery.

```text
🟢 Placed
   ↓
🟢 In Progress
   ↓
🟢 Completed
   ↓
🟢 Canceled
```
The tracking screen updates according to the current order status stored in Firebase.





🎨 UI / UX

I spent some time on the loading and overall browsing experience instead of showing empty screens while data is loading.

Shimmer Loading

Shimmer placeholders are used in different parts of the app, including:

* Food lists
* Food grids
* Nearby restaurants
* Categories
* Food details
* Network images
* View Oder Page shimmer

These loading states provide users with immediate visual feedback while asynchronous data is being fetched.





📱 Responsive Layout

FastFeast uses flutter_screenutil to adapt layouts across different screen sizes, including phones and tablets to avoid screen overflow errors.





👋 Onboarding

FastFeast includes a multi-page onboarding experience for first-time users.

The onboarding experience introduces the main concept of the application before users enter the main app.






🏗️ Application Structure

I organized the project into separate folders for views, providers/controllers, services, models, and reusable UI components.

The current structure looks like this:

```text
lib/
├── common/
│   └── shimmers/
├── constants/
├── controllers/
│   ├── provider/
│   └── services/
├── models/
├── views/
│   ├── address/
│   ├── auth/
│   ├── bottom_navigation_bar/
│   ├── cart/
│   ├── food/
│   ├── home/
│   │   └── widgets/
│   ├── onboarding/
│   ├── profile/
│   └── search/
├── firebase_options.dart
└── main.dart
```

This keeps business logic out of individual UI widgets and makes the application easier to maintain.





🗄️ Backend & Data

FastFeast uses Firebase services for backend functionality.

Firebase Authentication

Used for:

User registration
Login
Google authentication
Forgot password
Authentication state

Firebase Realtime Database

Used for real-time location-based restaurant discovery, as well as application data such as restaurant, food, user, and order details.

Geofire

Used for geographic queries to discover restaurants within a specified radius.





🛠️ Tech Stack

Frontend

* Flutter
* Dart
* Material UI
* flutter_screenutil


State Management

* Provider

Backend

* Firebase Authentication
* Firebase Realtime Database

Location

* Device GPS
* Geolocation
* Geofire

Payment

* Stripe

UI / UX

* Shimmer loading
* Responsive layouts
* Network image loading
* Onboarding carousel





🔑 Things I Practiced in This Project

While building FastFeast, I worked with:

* Firebase Authentication
* Google Sign-In
* Provider state management
* Firebase Realtime Database
* Location services
* Geofire radius queries
* Delivery address management
* Cart state management
* Stripe payments
* Order management
* Real-time order tracking and status
* Reusable Flutter widgets
* Responsive layouts
* Loading and error states
* Shimmer effects





🚀 What I Learned

One of the biggest things I learned from this project was how different parts of a Flutter application start interacting as the project becomes bigger.

Some of the key areas explored during development were:

Location-Based Data

Working with latitude/longitude data and radius-based restaurant queries Showed me a different type of data retrieval compared with document-based queries.

State Management

The application contains many independent pieces of state, including authentication, location, search, cart, payment, and order information. Managing these through dedicated providers helped keep the UI and application logic separated.

Payment Integration

Integrating Stripe provided me a practical experience with external payment services and the additional security considerations needed when handling payments and transactions.

Overall, FastFeast helped me understand how to build structure and connect multiple features into one complete application.





📸 Screenshots

Authentication

*

Home & Restaurant Discovery

*

Restaurant & Food Details

*

Cart & Checkout

*

Orders & Tracking

*





🔒 Security

The repository is public, so sensitive credentials and private configuration values are not included.

This public repository is intended to Show the application's architecture, implementation approach, and Flutter development practices without exposing private credentials or secrets.
