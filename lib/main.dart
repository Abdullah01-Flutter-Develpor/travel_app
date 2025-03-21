import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/control_room/control_data.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:travel_app/l10n/app_localizations.dart';
import 'package:travel_app/routers/go_router.dart';
import 'package:travel_app/uitlity/Sessions.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SessionControler().initializeSession();
  Get.put(DataController());

  await AppRouter.initRouter((locale) {
    Get.find<MyAppState>().updateLocale(locale);
  });

  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');
  final DataController _dataController = Get.find<DataController>();

  @override
  void initState() {
    super.initState();
    _updateAuthStatus();
    _updateLocale(WidgetsBinding.instance.platformDispatcher.locale);
    WidgetsBinding.instance.platformDispatcher.onLocaleChanged =
        _onLocaleChanged;
  }

  void _onLocaleChanged() {
    _updateLocale(WidgetsBinding.instance.platformDispatcher.locale);
  }

  void _updateLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  void updateLocale(Locale newLocale) {
    _updateLocale(newLocale);
  }

  Future<void> _updateAuthStatus() async {
    _dataController.auth.authStateChanges().listen((user) async {
      final bool isLoggedIn = user != null;
      await AppRouter.setLoggedIn(isLoggedIn);
      if (isLoggedIn) {
        await AppRouter.completeFirstLaunch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Travel App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      routerDelegate: AppRouter.router.routerDelegate,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routeInformationProvider: AppRouter.router.routeInformationProvider,
    );
  }
}
