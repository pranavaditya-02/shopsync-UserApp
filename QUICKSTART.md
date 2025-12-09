# ShopSync - Quick Start Guide

Welcome to ShopSync! This guide will help you get started with the app quickly.

## 🚀 First Time Setup

### 1. Install Dependencies
```bash
cd "f:\ShopSync App\shopsync"
flutter pub get
```

### 2. Run the App
```bash
flutter run
```

## 📱 App Features Overview

### Bottom Navigation
- **Home** - Browse products, see offers, recent orders
- **Discover** - Search and filter products
- **Cart** - View and manage shopping cart
- **Profile** - User profile and settings

### Key Features to Try

#### 1. Browse Products
- Open the app → Home screen displays various product categories
- Scroll through "Trending Now", "Recommended", and other sections
- Tap any product to view details

#### 2. Search & Filter
- Tap "Discover" in bottom navigation
- Use search bar to find products
- Apply filters (Category, Brand, Price Range)
- Sort products by price, rating, etc.

#### 3. Product Details
- Tap any product card
- View images, description, reviews
- Select size/color (if available)
- Add to cart or buy now

#### 4. Shopping Cart
- Tap "Cart" in bottom navigation
- Adjust quantities with +/- buttons
- Remove items if needed
- Proceed to checkout

#### 5. Checkout & Orders
- From cart, tap "Checkout"
- Select delivery address
- Choose payment method
- Place order
- View orders from Profile → My Orders

#### 6. AI Chat Assistant
- Tap chat icon in top-right of Home screen
- Ask questions about products
- Get personalized recommendations

#### 7. Wishlist
- Tap heart icon on any product
- View all wishlist items from Profile menu

#### 8. Change Theme
- Go to Profile → Settings
- Toggle between Light/Dark mode
- Changes persist across app restarts

#### 9. Change Language
- Go to Profile → Settings
- Select from 4 languages:
  - English
  - Tamil (தமிழ்)
  - Hindi (हिंदी)
  - Kannada (ಕನ್ನಡ)

#### 10. Store Locator
- Profile → Store Locator
- View nearby stores
- Get directions and contact information

## 🎨 Theme Customization

### Light Mode
- White background
- Gold primary color (#DBBC58)
- Black text

### Dark Mode
- Dark background (#121212)
- Gold primary color (#DBBC58)
- White text

## 🌐 Language Support

All UI elements and labels are translated into 4 languages. Change language anytime from Settings.

## 🔧 Troubleshooting

### App won't run?
```bash
flutter clean
flutter pub get
flutter run
```

### Build errors?
Make sure you have:
- Flutter SDK 3.5.3 or higher
- All dependencies installed (`flutter pub get`)

### Emulator/Device not detected?
```bash
flutter devices  # Check available devices
flutter emulators  # List available emulators
flutter emulators --launch <emulator_id>  # Launch specific emulator
```

## 📦 Building Release Version

### Android APK
```bash
flutter build apk --release
```
APK location: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### iOS (requires macOS)
```bash
flutter build ios --release
```

## 🎯 Test Accounts & Data

The app comes with dummy data for testing:

### Products
- 8 sample products across various categories
- Electronics, Fashion, Home & Kitchen, etc.

### Orders
- 3 sample orders with different statuses
- Pending, Shipped, Delivered

### Stores
- 3 nearby store locations with contact info

## 🛠️ Development Tips

### Hot Reload
Press `r` in terminal while app is running to hot reload changes.

### Hot Restart
Press `R` in terminal to perform a full restart.

### Flutter DevTools
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (iOS 12+)
- ✅ Web (coming soon)
- ✅ Windows (desktop)
- ✅ macOS (desktop)
- ✅ Linux (desktop)

## 🎨 Color Palette

Primary: `#DBBC58` (Gold)
- Use for buttons, active states, highlights

Backgrounds:
- Light: `#FFFFFF`
- Dark: `#121212`

Surface (Dark): `#1E1E1E`

## 🔐 Privacy & Security Notes

**Important:** This is a demo app with dummy data.

For production use:
- Connect to a real backend API
- Implement user authentication
- Add payment gateway integration
- Store sensitive data securely
- Add proper error handling
- Implement analytics

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider State Management](https://pub.dev/packages/provider)
- [GoRouter Navigation](https://pub.dev/packages/go_router)
- [Material Design 3](https://m3.material.io/)

## 🆘 Need Help?

1. Check the main README.md for detailed documentation
2. Review the code comments in the source files
3. Refer to Flutter documentation
4. Check package documentation on pub.dev

## ✨ Next Steps

1. ✅ Run the app and explore all features
2. ✅ Customize the theme colors
3. ✅ Add your own products
4. ✅ Connect to a backend API
5. ✅ Add authentication
6. ✅ Integrate payment gateway
7. ✅ Deploy to app stores

---

**Happy Coding! 🚀**
