import 'package:shared_preferences/shared_preferences.dart';

class SessionControler {
  static final SessionControler _singleton = SessionControler._internal();

  factory SessionControler() {
    return _singleton;
  }

  SessionControler._internal();

  String? _userId;

  String? get userId => _userId;

  set userId(String? value) {
    _userId = value;
    _saveUserId(value);
  }

  Future<void> _saveUserId(String? userId) async {
    final prefs = await SharedPreferences.getInstance();
    if (userId != null) {
      await prefs.setString('userId', userId);
    } else {
      await prefs.remove('userId');
    }
  }

  Future<void> initializeSession() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _userId = null;
  }
}
