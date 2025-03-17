import 'package:flutter/material.dart';

class CityAppBar extends StatelessWidget implements PreferredSizeWidget {
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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: showTitle ? theme.primaryColor : Colors.transparent,
      elevation: showTitle ? 4 : 0,
      title: AnimatedOpacity(
        opacity: showTitle ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: Text(
          cityName,
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
          onPressed: () => _showLanguageDialog(context, onLocaleChanged, theme),
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('City saved to favorites'),
                duration: Duration(seconds: 2),
              ),
            );
          },
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Select Language',
            style: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: DropdownButton<Locale>(
            isExpanded: true,
            underline: Container(
              height: 2,
              color: theme.primaryColor,
            ),
            value: Localizations.localeOf(context),
            items: const [
              DropdownMenuItem(value: Locale('en'), child: Text('English')),
              DropdownMenuItem(value: Locale('ur'), child: Text('اردو')),
            ],
            onChanged: (value) {
              if (value != null) {
                onLocaleChanged(value);
                Navigator.pop(context);
              }
            },
          ),
        );
      },
    );
  }
}
