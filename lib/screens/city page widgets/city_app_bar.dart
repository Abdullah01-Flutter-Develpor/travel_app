import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:travel_app/l10n/app_localizations.dart';
import 'package:travel_app/l10n/traslates_city.dart';
import 'package:travel_app/routers/route_path_class.dart';

class CityAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String cityName;
  final bool showTitle;
  final Function(Locale) onLocaleChanged;

  const CityAppBar({
    super.key,
    required this.cityName,
    required this.showTitle,
    required this.onLocaleChanged,
  });

  @override
  State<CityAppBar> createState() => _CityAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CityAppBarState extends State<CityAppBar> {
  // Locale? _dialogLocale; // Store the locale for the dialog

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.go(RoutePathClass.initialPath),
      ),
      backgroundColor:
          widget.showTitle ? theme.primaryColor : Colors.transparent,
      elevation: widget.showTitle ? 4 : 0,
      title: AnimatedOpacity(
        opacity: widget.showTitle ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: Text(
          getTranslatedCityName(context, widget.cityName),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.language, color: Colors.white),
          onPressed: () =>
              _showLanguageDialog(context, widget.onLocaleChanged, theme),
        ),
      ],
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    Function(Locale) onLocaleChanged,
    ThemeData theme,
  ) {
    final ValueNotifier<Locale> _localeNotifier =
        ValueNotifier(Localizations.localeOf(context));

    showDialog(
      context: context,
      builder: (context) {
        return ValueListenableBuilder<Locale>(
          valueListenable: _localeNotifier,
          builder: (context, selectedLocale, _) {
            // Hardcoded Urdu text
            final isUrdu = selectedLocale.languageCode == 'ur';
            final title = isUrdu ? 'زبان منتخب کریں' : 'Select Language';
            final englishLabel = isUrdu ? 'انگریزی' : 'English';
            final urduLabel = isUrdu ? 'اردو' : 'Urdu';
            final cancelText = isUrdu ? 'منسوخ کریں' : 'Cancel';
            final okText = isUrdu ? 'ٹھیک ہے' : 'OK';

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<Locale>(
                    title: Text(englishLabel),
                    value: const Locale('en'),
                    groupValue: selectedLocale,
                    onChanged: (Locale? value) {
                      if (value != null) {
                        _localeNotifier.value = value;
                      }
                    },
                  ),
                  RadioListTile<Locale>(
                    title: Text(urduLabel),
                    value: const Locale('ur'),
                    groupValue: selectedLocale,
                    onChanged: (Locale? value) {
                      if (value != null) {
                        _localeNotifier.value = value;
                      }
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(cancelText),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text(okText),
                  onPressed: () {
                    onLocaleChanged(
                        _localeNotifier.value); // Update the app locale
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
