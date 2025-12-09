import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'router.dart';
import 'theme/theme_provider.dart';
import 'localization/app_localizations.dart';
import '../core/utils/locale_provider.dart';
import '../core/utils/product_provider.dart';
import '../core/utils/cart_provider.dart';
import '../core/utils/order_provider.dart';
import '../core/services/agents/agent_manager.dart';

class ShopSyncApp extends StatelessWidget {
  const ShopSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(
          create: (context) => AgentManager(
            productProvider: context.read<ProductProvider>(),
            orderProvider: context.read<OrderProvider>(),
          ),
        ),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return MaterialApp.router(
            title: 'ShopSync',
            debugShowCheckedModeBanner: false,
            
            // Theme
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            
            // Localization
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('en', ''),
              Locale('ta', ''),
              Locale('hi', ''),
              Locale('kn', ''),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            
            // Router
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
