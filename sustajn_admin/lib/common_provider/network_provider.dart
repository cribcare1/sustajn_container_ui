import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/legacy.dart';

final networkProvider = StateNotifierProvider<NetworkNotifier, bool>((ref) {
  return NetworkNotifier();
});

class NetworkNotifier extends StateNotifier<bool> {
  NetworkNotifier() : super(false) {
    isNetworkAvailable();

    // FIXED for new connectivity_plus API
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      isNetworkAvailable(); // just re-check internet
    });
  }

  Future<void> _checkNetworkStatus() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      state = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      state = false;
    }
  }

  Future<bool> isNetworkAvailable() async {
    await _checkNetworkStatus();
    return state;
  }
}
