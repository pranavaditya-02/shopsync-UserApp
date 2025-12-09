# ShopSync - Project Architecture & File Summary

## 📁 Complete File Structure

```
shopsync/
├── android/                              # Android platform files
├── ios/                                  # iOS platform files
├── linux/                                # Linux platform files
├── macos/                                # macOS platform files
├── web/                                  # Web platform files
├── windows/                              # Windows platform files
├── test/
│   └── widget_test.dart                 # Basic widget tests
├── assets/
│   ├── localization/
│   │   ├── en.json                      # English translations
│   │   ├── ta.json                      # Tamil translations
│   │   ├── hi.json                      # Hindi translations
│   │   └── kn.json                      # Kannada translations
│   └── images/                          # Image assets (placeholder)
├── lib/
│   ├── main.dart                        # App entry point
│   ├── app/
│   │   ├── app.dart                     # Main app configuration with providers
│   │   ├── router.dart                  # GoRouter navigation setup
│   │   ├── localization/
│   │   │   └── app_localizations.dart   # Localization implementation
│   │   └── theme/
│   │       ├── light_theme.dart         # Light mode theme
│   │       ├── dark_theme.dart          # Dark mode theme
│   │       └── theme_provider.dart      # Theme state management
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart       # App-wide constants
│   │   ├── utils/
│   │   │   ├── helpers.dart             # Helper functions (currency, dates, snackbars)
│   │   │   ├── locale_provider.dart     # Language state management
│   │   │   ├── product_provider.dart    # Product data & operations
│   │   │   ├── cart_provider.dart       # Shopping cart management
│   │   │   └── order_provider.dart      # Order management
│   │   └── widgets/
│   │       ├── main_scaffold.dart       # Bottom navigation scaffold
│   │       └── product_card.dart        # Reusable product card widget
│   ├── features/
│   │   ├── home/
│   │   │   └── home_screen.dart         # Home screen with all sections
│   │   ├── discover/
│   │   │   └── discover_screen.dart     # Browse/Search with filters
│   │   ├── product/
│   │   │   └── product_detail_screen.dart # Product details page
│   │   ├── cart/
│   │   │   └── cart_screen.dart         # Shopping cart
│   │   ├── checkout/
│   │   │   └── checkout_screen.dart     # Checkout flow
│   │   ├── orders/
│   │   │   └── orders_screen.dart       # Order history & tracking
│   │   ├── chat_ai/
│   │   │   └── chat_screen.dart         # AI assistant chat
│   │   ├── profile/
│   │   │   └── profile_screen.dart      # User profile
│   │   ├── wishlist/
│   │   │   └── wishlist_screen.dart     # Saved products
│   │   ├── notifications/
│   │   │   └── notifications_screen.dart # Notifications list
│   │   ├── store_locator/
│   │   │   └── store_locator_screen.dart # Find nearby stores
│   │   └── settings/
│   │       └── settings_screen.dart     # App settings (theme, language)
│   └── models/
│       ├── product_model.dart           # Product data model
│       ├── cart_model.dart              # Cart item model
│       ├── order_model.dart             # Order & OrderItem models
│       ├── user_model.dart              # User data model
│       └── store_model.dart             # Store location model
├── pubspec.yaml                         # Dependencies & assets
├── README.md                            # Complete documentation
├── QUICKSTART.md                        # Quick start guide
└── ARCHITECTURE.md                      # This file

```

## 🏗️ Architecture Pattern

### Clean Architecture + Feature-Based Structure

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│  (Screens, Widgets, UI Components)      │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│           Application Layer             │
│    (Providers, State Management)        │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│            Domain Layer                 │
│      (Models, Business Logic)           │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│             Data Layer                  │
│  (Currently: Dummy Data Providers)      │
│  (Future: API Services, Local DB)       │
└─────────────────────────────────────────┘
```

## 📊 Key Components Breakdown

### 1. App Layer (`lib/app/`)
**Purpose:** Application-wide configuration

- **app.dart**: Main app widget with providers
- **router.dart**: Navigation configuration with GoRouter
- **localization/**: Multi-language support
- **theme/**: Light & dark theme definitions

### 2. Core Layer (`lib/core/`)
**Purpose:** Shared utilities and widgets

**Constants:**
- App metadata
- Categories, languages
- Colors, styling constants

**Utils:**
- Helper functions (formatting, currency)
- State providers (theme, locale, products, cart, orders)

**Widgets:**
- Bottom navigation scaffold
- Reusable product card

### 3. Features Layer (`lib/features/`)
**Purpose:** Feature-specific screens

Each feature is self-contained with its screen(s):

| Feature | Screen | Key Functionality |
|---------|--------|-------------------|
| home | home_screen.dart | Landing page, offers, quick actions |
| discover | discover_screen.dart | Search, filter, browse products |
| product | product_detail_screen.dart | Product info, add to cart |
| cart | cart_screen.dart | View cart, update quantities |
| checkout | checkout_screen.dart | Address, payment, place order |
| orders | orders_screen.dart | Order history, tracking |
| chat_ai | chat_screen.dart | AI assistant interface |
| profile | profile_screen.dart | User info, menu navigation |
| wishlist | wishlist_screen.dart | Saved products |
| notifications | notifications_screen.dart | Alerts, updates |
| store_locator | store_locator_screen.dart | Find nearby stores |
| settings | settings_screen.dart | Theme, language, account |

### 4. Models Layer (`lib/models/`)
**Purpose:** Data structures

- **ProductModel**: Product information
- **CartItemModel**: Cart item with selections
- **OrderModel + OrderItem**: Order details
- **UserModel**: User profile data
- **StoreModel**: Store location data

## 🔄 State Management Flow

```
User Action
    ↓
Widget Event
    ↓
Provider Method Call
    ↓
State Update
    ↓
notifyListeners()
    ↓
UI Rebuild
    ↓
Updated Screen
```

### Providers Used:

1. **ThemeProvider** (Global)
   - Manages light/dark theme
   - Persists to SharedPreferences

2. **LocaleProvider** (Global)
   - Manages app language
   - Persists to SharedPreferences

3. **ProductProvider** (Global)
   - Product catalog
   - Recently viewed
   - Wishlist
   - Search & filter

4. **CartProvider** (Global)
   - Cart items
   - Quantities
   - Totals

5. **OrderProvider** (Global)
   - Order history
   - Order placement

## 🎨 Theme System

### Structure:
```
ThemeProvider
├── LightTheme (light_theme.dart)
│   ├── Colors
│   ├── TextTheme
│   ├── ComponentThemes
│   └── Spacing
└── DarkTheme (dark_theme.dart)
    ├── Colors
    ├── TextTheme
    ├── ComponentThemes
    └── Spacing
```

### Theme Switching:
1. User toggles theme in Settings
2. ThemeProvider updates state
3. Saves to SharedPreferences
4. MaterialApp rebuilds with new theme

## 🌐 Localization System

### Structure:
```
AppLocalizations
├── Load JSON based on locale
├── Provide translation method
└── Convenient getters for common keys
```

### Language Files:
- `en.json` - English (60+ keys)
- `ta.json` - Tamil (60+ keys)
- `hi.json` - Hindi (60+ keys)
- `kn.json` - Kannada (60+ keys)

### Usage:
```dart
final localizations = AppLocalizations.of(context)!;
Text(localizations.home)  // Displays "Home" in selected language
```

## 🧭 Navigation Structure

### GoRouter Configuration:

**Shell Routes (with Bottom Nav):**
- `/home` → HomeScreen
- `/discover` → DiscoverScreen
- `/cart` → CartScreen
- `/profile` → ProfileScreen

**Standard Routes:**
- `/product/:id` → ProductDetailScreen
- `/chat` → ChatScreen
- `/orders` → OrdersScreen
- `/settings` → SettingsScreen
- `/wishlist` → WishlistScreen
- `/notifications` → NotificationsScreen
- `/store-locator` → StoreLocatorScreen
- `/checkout` → CheckoutScreen

## 📦 Dependency Injection

### Provider Setup in `app.dart`:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(ThemeProvider),
    ChangeNotifierProvider(LocaleProvider),
    ChangeNotifierProvider(ProductProvider),
    ChangeNotifierProvider(CartProvider),
    ChangeNotifierProvider(OrderProvider),
  ],
  child: MaterialApp.router(...)
)
```

## 🔌 Extension Points

### To Add Real API Integration:

1. **Create API Service Layer**
   ```
   lib/
   └── data/
       ├── api/
       │   ├── api_client.dart
       │   ├── product_api.dart
       │   ├── cart_api.dart
       │   └── order_api.dart
       └── repositories/
           ├── product_repository.dart
           ├── cart_repository.dart
           └── order_repository.dart
   ```

2. **Update Providers**
   - Replace dummy data with API calls
   - Add loading states
   - Handle errors

3. **Add Authentication**
   ```
   lib/
   └── features/
       └── auth/
           ├── login_screen.dart
           ├── register_screen.dart
           └── auth_provider.dart
   ```

## 🎯 Design Patterns Used

1. **Provider Pattern**: State management
2. **Repository Pattern**: Data abstraction (ready for API)
3. **Factory Pattern**: Model serialization
4. **Singleton**: Providers (via Provider package)
5. **Observer Pattern**: Provider's notifyListeners

## 🧪 Testing Structure

### Current:
- Basic widget test in `test/widget_test.dart`

### Recommended Structure:
```
test/
├── unit/
│   ├── providers/
│   ├── models/
│   └── utils/
├── widget/
│   ├── screens/
│   └── widgets/
└── integration/
    └── user_flows/
```

## 📊 Data Flow Example

### Adding Product to Cart:

```
1. User taps "Add to Cart" button
   ↓
2. ProductDetailScreen calls:
   cartProvider.addToCart(...)
   ↓
3. CartProvider:
   - Checks if item exists
   - Updates quantity or adds new item
   - Calculates totals
   - Calls notifyListeners()
   ↓
4. All Cart-dependent widgets rebuild:
   - CartScreen updates list
   - Bottom nav badge updates (if implemented)
   - Cart icon updates count
   ↓
5. Helper.showSuccess() displays confirmation
```

## 🎨 UI Component Hierarchy

```
MaterialApp.router
└── Scaffold (from MainScaffold or individual screens)
    ├── AppBar
    │   ├── Title
    │   └── Actions
    ├── Body (Screen Content)
    │   ├── SingleChildScrollView
    │   │   └── Column/ListView
    │   │       ├── Cards
    │   │       ├── Lists
    │   │       └── Custom Widgets
    │   └── GridView (for product grids)
    └── BottomNavigationBar (in MainScaffold)
```

## 🔐 Security Considerations

**Current State:** Demo app with no real security

**For Production:**
1. Implement JWT authentication
2. Secure API endpoints
3. Encrypt sensitive data
4. Add certificate pinning
5. Implement proper error handling
6. Add rate limiting
7. Validate all inputs
8. Use HTTPS only

## 📈 Performance Optimizations

**Already Implemented:**
- Cached network images
- ListView.builder for efficient scrolling
- Provider for minimal rebuilds
- const constructors where possible

**Recommended:**
- Add pagination for product lists
- Implement image lazy loading
- Add response caching
- Use compute() for heavy operations
- Implement debouncing for search

## 🎯 Next Development Steps

1. ✅ Basic app structure (Done)
2. ✅ All screens implemented (Done)
3. ✅ Theme system (Done)
4. ✅ Localization (Done)
5. ⏭️ API integration
6. ⏭️ Authentication
7. ⏭️ Payment gateway
8. ⏭️ Push notifications
9. ⏭️ Analytics
10. ⏭️ Error tracking

---

**Architecture Status:** ✅ Production-Ready Foundation

The app follows industry best practices and is ready for backend integration and further development.
