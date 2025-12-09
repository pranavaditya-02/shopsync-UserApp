import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/localization/app_localizations.dart';
import '../../app/theme/theme_provider.dart';
import '../../core/utils/locale_provider.dart';
import '../../core/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Settings
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_6),
                  title: Text(localizations.theme),
                  subtitle: Text(
                    themeProvider.isDarkMode
                        ? localizations.darkMode
                        : localizations.lightMode,
                  ),
                ),
                SwitchListTile(
                  secondary: Icon(
                    themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  ),
                  title: Text(
                    themeProvider.isDarkMode
                        ? localizations.darkMode
                        : localizations.lightMode,
                  ),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Language Settings
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(localizations.language),
                  subtitle: Text(
                    AppConstants.supportedLanguages[
                            localeProvider.locale.languageCode] ??
                        'English',
                  ),
                ),
                ...AppConstants.supportedLanguages.entries.map((entry) {
                  return RadioListTile<String>(
                    title: Text(entry.value),
                    value: entry.key,
                    groupValue: localeProvider.locale.languageCode,
                    onChanged: (value) {
                      if (value != null) {
                        localeProvider.setLocale(Locale(value));
                      }
                    },
                  );
                }).toList(),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Account Settings
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(localizations.account),
                  subtitle: const Text('Manage your account'),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email'),
                  subtitle: const Text('jack.anderson@example.com'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Phone'),
                  subtitle: const Text('+91 98765 43210'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // App Info
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(localizations.about),
                ),
                ListTile(
                  title: const Text('App Version'),
                  subtitle: Text(AppConstants.appVersion),
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Notifications Settings
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: Text(localizations.notifications),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active),
                  title: const Text('Push Notifications'),
                  value: true,
                  onChanged: (value) {},
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.email),
                  title: const Text('Email Notifications'),
                  value: true,
                  onChanged: (value) {},
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.local_offer),
                  title: const Text('Promotional Offers'),
                  value: false,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
