import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur')
  ];

  /// No description provided for @hunza.
  ///
  /// In en, this message translates to:
  /// **'Hunza'**
  String get hunza;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @guide.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get guide;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @hotels.
  ///
  /// In en, this message translates to:
  /// **'Hotels'**
  String get hotels;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'online'**
  String get online;

  /// No description provided for @tapToExpand.
  ///
  /// In en, this message translates to:
  /// **'tap to expand'**
  String get tapToExpand;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'offline mode'**
  String get offlineMode;

  /// No description provided for @viewingSavedMapOf.
  ///
  /// In en, this message translates to:
  /// **'viewing saved map of'**
  String get viewingSavedMapOf;

  /// No description provided for @connectToInternetForFullFeatures.
  ///
  /// In en, this message translates to:
  /// **'connect to internet for full features'**
  String get connectToInternetForFullFeatures;

  /// No description provided for @noMapAvailableFor.
  ///
  /// In en, this message translates to:
  /// **'no map available for'**
  String get noMapAvailableFor;

  /// No description provided for @connectToTheInternetToViewThisMap.
  ///
  /// In en, this message translates to:
  /// **'connect to the internet to view this map'**
  String get connectToTheInternetToViewThisMap;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'try again'**
  String get tryAgain;

  /// No description provided for @offlineMap.
  ///
  /// In en, this message translates to:
  /// **'offline map'**
  String get offlineMap;

  /// No description provided for @youAreViewingASavedVersionOfThe.
  ///
  /// In en, this message translates to:
  /// **'you are viewing a saved version of the'**
  String get youAreViewingASavedVersionOfThe;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @checkConnection.
  ///
  /// In en, this message translates to:
  /// **'check connection'**
  String get checkConnection;

  /// No description provided for @cannotOpenMapNoInternetConnectionOrSavedMapAvailable.
  ///
  /// In en, this message translates to:
  /// **'cannot open map. no internet connection or saved map available.'**
  String get cannotOpenMapNoInternetConnectionOrSavedMapAvailable;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'explore'**
  String get explore;

  /// No description provided for @locationServicesUnavailableInOfflineMode.
  ///
  /// In en, this message translates to:
  /// **'location services unavailable in offline mode'**
  String get locationServicesUnavailableInOfflineMode;

  /// No description provided for @youAreViewingASavedMapSomeFeaturesMayBeLimited.
  ///
  /// In en, this message translates to:
  /// **'you are viewing a saved map. some features may be limited.'**
  String get youAreViewingASavedMapSomeFeaturesMayBeLimited;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @addReviews.
  ///
  /// In en, this message translates to:
  /// **'Add Reviews'**
  String get addReviews;

  /// No description provided for @localUser.
  ///
  /// In en, this message translates to:
  /// **'localuser'**
  String get localUser;

  /// No description provided for @noReviewsAvailable.
  ///
  /// In en, this message translates to:
  /// **'no reviews available.'**
  String get noReviewsAvailable;

  /// No description provided for @failedToDeleteReview.
  ///
  /// In en, this message translates to:
  /// **'failed to delete review:'**
  String get failedToDeleteReview;

  /// No description provided for @citySavedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'city saved to favorites'**
  String get citySavedToFavorites;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'select language'**
  String get selectLanguage;

  /// No description provided for @noImageUrlProvidedUsingDefault.
  ///
  /// In en, this message translates to:
  /// **'no image url provided, using default.'**
  String get noImageUrlProvidedUsingDefault;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'no internet'**
  String get noInternet;

  /// No description provided for @islamabad.
  ///
  /// In en, this message translates to:
  /// **'Islamabad'**
  String get islamabad;

  /// No description provided for @lahore.
  ///
  /// In en, this message translates to:
  /// **'Lahore'**
  String get lahore;

  /// No description provided for @peshawar.
  ///
  /// In en, this message translates to:
  /// **'Peshawar'**
  String get peshawar;

  /// No description provided for @murree.
  ///
  /// In en, this message translates to:
  /// **'Murree'**
  String get murree;

  /// No description provided for @gilgit.
  ///
  /// In en, this message translates to:
  /// **'Gilgit'**
  String get gilgit;

  /// No description provided for @skardu.
  ///
  /// In en, this message translates to:
  /// **'Skardu'**
  String get skardu;

  /// No description provided for @swat.
  ///
  /// In en, this message translates to:
  /// **'Swat'**
  String get swat;

  /// No description provided for @chitral.
  ///
  /// In en, this message translates to:
  /// **'Chitral'**
  String get chitral;

  /// No description provided for @kumrat.
  ///
  /// In en, this message translates to:
  /// **'Kumrat'**
  String get kumrat;

  /// No description provided for @kelashValley.
  ///
  /// In en, this message translates to:
  /// **'Kelash Valley'**
  String get kelashValley;

  /// No description provided for @jahazBanda.
  ///
  /// In en, this message translates to:
  /// **'Jahaz Banda'**
  String get jahazBanda;

  /// No description provided for @tirahValley.
  ///
  /// In en, this message translates to:
  /// **'Tirah Valley'**
  String get tirahValley;

  /// No description provided for @kashmir.
  ///
  /// In en, this message translates to:
  /// **'Kashmir'**
  String get kashmir;

  /// No description provided for @neelumValley.
  ///
  /// In en, this message translates to:
  /// **'Neelum Valley'**
  String get neelumValley;

  /// No description provided for @kel.
  ///
  /// In en, this message translates to:
  /// **'Kel'**
  String get kel;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @urdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get urdu;

  /// No description provided for @pashto.
  ///
  /// In en, this message translates to:
  /// **'Pashto'**
  String get pashto;

  /// No description provided for @sindhi.
  ///
  /// In en, this message translates to:
  /// **'Sindhi'**
  String get sindhi;

  /// No description provided for @punjabi.
  ///
  /// In en, this message translates to:
  /// **'Punjabi'**
  String get punjabi;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ur': return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
