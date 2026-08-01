import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/legacy.dart';

final networkProvider = StateNotifierProvider<NetworkNotifier, bool>((ref) {
  return NetworkNotifier();
});

class NetworkNotifier extends StateNotifier<bool> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _subscription;

  NetworkNotifier() : super(false) {
    _init();
  }

  Future<void> _init() async {
    await _checkNetworkStatus();

    _subscription = _connectivity.onConnectivityChanged.listen((_) async {
      await _checkNetworkStatus();
    });
  }

  Future<void> _checkNetworkStatus() async {
    final result = await _connectivity.checkConnectivity();

    // connectivity_plus v7 returns List<ConnectivityResult>
    if (result is List<ConnectivityResult>) {
      state = !result.contains(ConnectivityResult.none);
    }
    // connectivity_plus v6 and below returns ConnectivityResult
    else if (result is ConnectivityResult) {
      state = result != ConnectivityResult.none;
    } else {
      state = false;
    }
  }

  Future<bool> isNetworkAvailable() async {
    await _checkNetworkStatus();
    return state;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}