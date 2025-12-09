import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String> _localizedStrings = {};

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Future<bool> load() async {
    String jsonString = await rootBundle
        .loadString('assets/localization/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Convenient getters
  String get appName => translate('app_name');
  String get home => translate('home');
  String get discover => translate('discover');
  String get cart => translate('cart');
  String get profile => translate('profile');
  String get search => translate('search');
  String get settings => translate('settings');
  String get offers => translate('offers');
  String get greetingMorning => translate('greeting_morning');
  String get greetingAfternoon => translate('greeting_afternoon');
  String get greetingEvening => translate('greeting_evening');
  String get activeOffers => translate('active_offers');
  String get quickActions => translate('quick_actions');
  String get recentlyViewed => translate('recently_viewed');
  String get recommended => translate('recommended');
  String get dealsBanner => translate('deals_banner');
  String get shopByCategory => translate('shop_by_category');
  String get availableNearby => translate('available_nearby');
  String get loyaltyStatus => translate('loyalty_status');
  String get recentOrders => translate('recent_orders');
  String get continueShopping => translate('continue_shopping');
  String get chatAssistant => translate('chat_assistant');
  String get typeMessage => translate('type_message');
  String get productDetails => translate('product_details');
  String get addToCart => translate('add_to_cart');
  String get buyNow => translate('buy_now');
  String get description => translate('description');
  String get reviews => translate('reviews');
  String get ratings => translate('ratings');
  String get size => translate('size');
  String get color => translate('color');
  String get price => translate('price');
  String get discount => translate('discount');
  String get inStock => translate('in_stock');
  String get outOfStock => translate('out_of_stock');
  String get checkout => translate('checkout');
  String get myOrders => translate('my_orders');
  String get orderTracking => translate('order_tracking');
  String get wishlist => translate('wishlist');
  String get notifications => translate('notifications');
  String get storeLocator => translate('store_locator');
  String get findNearbyStores => translate('find_nearby_stores');
  String get account => translate('account');
  String get language => translate('language');
  String get theme => translate('theme');
  String get lightMode => translate('light_mode');
  String get darkMode => translate('dark_mode');
  String get about => translate('about');
  String get logout => translate('logout');
  String get filter => translate('filter');
  String get sortBy => translate('sort_by');
  String get categories => translate('categories');
  String get trendingNow => translate('trending_now');
  String get brands => translate('brands');
  String get apply => translate('apply');
  String get clearAll => translate('clear_all');
  String get subtotal => translate('subtotal');
  String get total => translate('total');
  String get deliveryAddress => translate('delivery_address');
  String get paymentMethod => translate('payment_method');
  String get placeOrder => translate('place_order');
  String get orderPlaced => translate('order_placed');
  String get trackOrder => translate('track_order');
  String get cancelOrder => translate('cancel_order');
  String get viewAll => translate('view_all');
  String get addToWishlist => translate('add_to_wishlist');
  String get removeFromWishlist => translate('remove_from_wishlist');
  String get share => translate('share');
  String get pointsEarned => translate('points_earned');
  String get nextReward => translate('next_reward');
  String get searchHere => translate('search_here');
  String get noItems => translate('no_items');
  String get emptyCart => translate('empty_cart');
  String get emptyWishlist => translate('empty_wishlist');
  String get continueBrowsing => translate('continue_browsing');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ta', 'hi', 'kn'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
