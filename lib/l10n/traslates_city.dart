// lib/utils/app_utils.dart
import 'package:flutter/material.dart';
import 'app_localizations.dart'; // Import your AppLocalizations

String getTranslatedCityName(BuildContext context, String cityName) {
  switch (cityName) {
    case 'Islamabad':
      return AppLocalizations.of(context).islamabad;
    case 'Lahore':
      return AppLocalizations.of(context).lahore;
    case 'Peshawar':
      return AppLocalizations.of(context).peshawar;
    case 'Murree':
      return AppLocalizations.of(context).murree;
    case 'Gilgit':
      return AppLocalizations.of(context).gilgit;
    case 'Skardu':
      return AppLocalizations.of(context).skardu;
    case 'Swat':
      return AppLocalizations.of(context).swat;
    case 'Chitral':
      return AppLocalizations.of(context).chitral;
    case 'Hunza':
      return AppLocalizations.of(context).hunza;
    case 'Kumrat':
      return AppLocalizations.of(context).kumrat;
    case 'Kelash Valley':
      return AppLocalizations.of(context).kelashValley;
    case 'Jahaz Banda':
      return AppLocalizations.of(context).jahazBanda;
    case 'Tirah Valley':
      return AppLocalizations.of(context).tirahValley;
    case 'Kashmir':
      return AppLocalizations.of(context).kashmir;
    case 'Neelum Valley':
      return AppLocalizations.of(context).neelumValley;
    case 'Kel':
      return AppLocalizations.of(context).kel;
    default:
      return cityName; // Fallback to the original name
  }
}
