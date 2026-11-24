import 'package:flutter/foundation.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

/// Memory-only token; epochs prevent an older login request reviving logout.
class AuthState extends ChangeNotifier {
  AuthState(this._api, {String? initialToken}) : _token = initialToken;
  final ApiClient _api;
  String? _token;
  int _epoch = 0;
  bool _disposed = false;
  String? get token => _token;
  bool get isLoggedIn => _token?.isNotEmpty ?? false;
  Future<void> login(String username, String password) async {
    final epoch = ++_epoch;
    final value = await _api.obtainToken(username, password);
    if (_disposed || epoch != _epoch) return;
    _token = value;
    notifyListeners();
  }

  void invalidate() {
    ++_epoch;
    _token = null;
    if (!_disposed) notifyListeners();
  }

  Future<void> logout() async {
    final current = _token;
    final epoch = ++_epoch;
    try {
      if (current != null) await _api.logout(token: current);
    } finally {
      if (!_disposed && epoch == _epoch) {
        _token = null;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    ++_epoch;
    super.dispose();
  }
}
