class AppConstants {
  // App Info
  static const String appName = 'ShopSync';
  static const String appVersion = '1.0.0';
  
  // Colors (hex values)
  static const String primaryColorHex = '#DBBC58';
  
  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  
  // Dummy Image URLs (placeholders)
  static const String placeholderImage = 'https://via.placeholder.com/400';
  
  // API Endpoints (dummy)
  static const String baseUrl = 'https://api.shopsync.com';
  
  // Pagination
  static const int itemsPerPage = 20;
  
  // Animation Durations
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;
  
  // Categories
  static const List<String> categories = [
    'Electronics',
    'Fashion',
    'Home & Kitchen',
    'Beauty & Personal Care',
    'Sports & Outdoors',
    'Books',
    'Toys & Games',
    'Grocery',
  ];
  
  // Sort Options
  static const List<String> sortOptions = [
    'Relevance',
    'Price: Low to High',
    'Price: High to Low',
    'Rating',
    'Newest First',
  ];
  
  // Languages
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'ta': 'தமிழ்',
    'hi': 'हिंदी',
    'kn': 'ಕನ್ನಡ',
  };
}
