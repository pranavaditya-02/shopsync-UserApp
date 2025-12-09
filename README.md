# ShopSync - Complete E-Commerce Flutter Application

A modern, feature-rich e-commerce mobile application built with Flutter following Clean Architecture principles.

## 🎯 Features

### Core Features
- ✅ **Multi-language Support** - English, Tamil, Hindi, Kannada
- ✅ **Theme Support** - Light and Dark mode with persistent storage
- ✅ **Clean Architecture** - Modular, scalable, and maintainable code structure
- ✅ **State Management** - Provider-based state management
- ✅ **Navigation** - GoRouter for declarative routing
- ✅ **Responsive UI** - Beautiful, modern UI with smooth animations

### Screens & Functionality

#### 1. Home Screen
- Greeting banner (time-based)
- Active offers carousel
- Quick action buttons
- Recently viewed products
- Recommended products
- Deals banner
- Shop by category
- Trending products
- Loyalty status card
- Recent orders preview

#### 2. Discover/Browse
- Search functionality
- Category filters
- Brand filters
- Price range slider
- Sort options (Price, Rating, Newest)
- Grid view of products

#### 3. Product Details
- Image carousel
- Product information
- Ratings and reviews
- Size and color selectors
- Add to cart/Buy now buttons
- Store availability
- Discount badges

#### 4. Shopping Cart
- Cart items management
- Quantity controls
- Remove items
- Price summary
- Checkout navigation

#### 5. Checkout
- Delivery address selection
- Payment method selection
- Order summary
- Place order functionality

#### 6. Orders & Tracking
- Order history
- Order status tracking
- Order details

#### 7. Chat/AI Assistant
- WhatsApp-style chat interface
- Message bubbles
- Quick replies
- Attachment and camera buttons
- Voice input button

#### 8. Profile
- User information
- Loyalty tier display
- Quick navigation to other screens
- Logout functionality

#### 9. Wishlist
- Save favorite products
- Add/remove from wishlist
- Grid view display

#### 10. Notifications
- Order updates
- Promotional offers
- Price drop alerts
- Delivery notifications

#### 11. Store Locator
- Map view placeholder
- Nearby stores list
- Store details (address, phone, hours)
- Distance calculation
- Get directions and call buttons

#### 12. Settings
- Theme toggle (Light/Dark)
- Language selector
- Account management
- Notification preferences
- App information

## 🏗️ Project Structure

```
lib/
├── app/
│   ├── app.dart                    # Main app configuration
│   ├── router.dart                 # GoRouter configuration
│   ├── localization/
│   │   └── app_localizations.dart  # Localization implementation
│   └── theme/
│       ├── light_theme.dart        # Light theme
│       ├── dark_theme.dart         # Dark theme
│       └── theme_provider.dart     # Theme state management
├── core/
│   ├── constants/
│   │   └── app_constants.dart      # App-wide constants
│   ├── utils/
│   │   ├── helpers.dart            # Helper functions
│   │   ├── locale_provider.dart    # Language state management
│   │   ├── product_provider.dart   # Product data provider
│   │   ├── cart_provider.dart      # Cart state management
│   │   └── order_provider.dart     # Order data provider
│   └── widgets/
│       ├── main_scaffold.dart      # Bottom navigation scaffold
│       └── product_card.dart       # Reusable product card
├── features/
│   ├── home/                       # Home screen
│   ├── discover/                   # Browse/Search screen
│   ├── product/                    # Product details screen
│   ├── cart/                       # Shopping cart screen
│   ├── checkout/                   # Checkout screen
│   ├── orders/                     # Orders screen
│   ├── chat_ai/                    # AI chat screen
│   ├── profile/                    # Profile screen
│   ├── wishlist/                   # Wishlist screen
│   ├── notifications/              # Notifications screen
│   ├── store_locator/              # Store locator screen
│   └── settings/                   # Settings screen
├── models/
│   ├── product_model.dart          # Product data model
│   ├── cart_model.dart             # Cart item model
│   ├── order_model.dart            # Order model
│   ├── user_model.dart             # User model
│   └── store_model.dart            # Store model
└── main.dart                       # App entry point
```

## 🎨 Design Specifications

### Colors
- **Primary Color**: #DBBC58 (Gold)
- **Background (Light)**: #FFFFFF
- **Background (Dark)**: #121212
- **Surface (Dark)**: #1E1E1E

### Typography
- **Font Family**: Open Sans (via Google Fonts)
- Consistent font weights and sizes throughout

### UI Elements
- Rounded corners (12px radius)
- Smooth transitions and animations
- Material Design 3 components
- Consistent spacing and padding

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1              # State management
  go_router: ^14.0.2            # Navigation
  shared_preferences: ^2.2.2    # Local storage
  shimmer: ^3.0.0               # Loading effects
  cached_network_image: ^3.3.1  # Image caching
  carousel_slider: ^5.0.0       # Carousels
  smooth_page_indicator: ^1.1.0 # Page indicators
  intl: ^0.19.0                 # Internationalization
  google_fonts: ^6.2.1          # Custom fonts
  flutter_rating_bar: ^4.0.1    # Rating displays
  url_launcher: ^6.2.5          # URL launching
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.5.3 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android/iOS emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   cd "f:\ShopSync App\shopsync"
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android APK**
```bash
flutter build apk --release
```

**Android App Bundle**
```bash
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
```

## 🌐 Localization

The app supports 4 languages:
- English (en)
- Tamil (ta)
- Hindi (hi)
- Kannada (kn)

Localization files are located in `assets/localization/`

### Adding a New Language

1. Create a new JSON file in `assets/localization/` (e.g., `fr.json`)
2. Add translations for all keys
3. Update `AppConstants.supportedLanguages` in `lib/core/constants/app_constants.dart`
4. Add locale to `supportedLocales` in `lib/app/app.dart`

## 🎯 State Management

The app uses **Provider** for state management:

- **ThemeProvider** - Manages light/dark theme
- **LocaleProvider** - Manages app language
- **ProductProvider** - Manages product data and operations
- **CartProvider** - Manages shopping cart
- **OrderProvider** - Manages orders

## 📱 Navigation Structure

GoRouter with bottom navigation:

**Main Routes (Bottom Nav)**
- `/home` - Home screen
- `/discover` - Browse/Search screen
- `/cart` - Shopping cart
- `/profile` - User profile

**Secondary Routes**
- `/product/:id` - Product details
- `/chat` - AI Assistant
- `/orders` - Order history
- `/settings` - App settings
- `/wishlist` - Saved items
- `/notifications` - Notifications
- `/store-locator` - Find stores
- `/checkout` - Checkout process

## 🔒 Data & Privacy

Currently using dummy data for demonstration purposes. In production:
- Integrate with your backend API
- Implement proper authentication
- Add secure payment gateway
- Store user data securely

## 🛠️ Development Notes

### Dummy Data
The app includes comprehensive dummy data for testing:
- 8 sample products across various categories
- Sample orders with different statuses
- Store locations
- Notifications

### API Integration Points
To connect to a real backend, update:
- `lib/core/utils/product_provider.dart` - Product fetching
- `lib/core/utils/cart_provider.dart` - Cart synchronization
- `lib/core/utils/order_provider.dart` - Order management

## 📄 License

This project is created for demonstration purposes.

## 🤝 Contributing

This is a complete demo project. Feel free to use it as a template for your own e-commerce applications.

## 📧 Support

For questions and support, please refer to the Flutter documentation:
- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [GoRouter Package](https://pub.dev/packages/go_router)

## ✨ Highlights

- ✅ **Complete E-commerce Flow** - From browsing to checkout
- ✅ **Modern UI/UX** - Beautiful, intuitive interface
- ✅ **Multilingual** - 4 languages supported
- ✅ **Theme Support** - Light and dark modes
- ✅ **Clean Code** - Well-organized, documented, and maintainable
- ✅ **Ready for Production** - Just add your backend API

---

**Built with ❤️ using Flutter**

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
