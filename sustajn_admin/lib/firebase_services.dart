import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/utility.dart';
import 'constants/network_urls.dart';

class FirebaseServices {
  static final FirebaseServices _instance = FirebaseServices._internal();

  factory FirebaseServices() {
    return _instance;
  }

   FirebaseServices. _internal();

  Future<void> initialize() async {}
}

  