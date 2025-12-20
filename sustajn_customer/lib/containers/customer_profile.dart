import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyProfileScreen(),
    ),
  );
}

class AppColors {
  static final Color darkGreen = Color(0xFF0F3727);
  static final Color yellow = Color(0xFFD4AE37);
  static final Color white = Color(0xFFFFFFFF);
  static final Color white5 = Color(0x0DFFFFFF);
  static final Color white20 = Color(0x33FFFFFF);
}

class AppText {
  static final TextStyle header = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.darkGreen,
  );

  static final TextStyle name = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static final TextStyle label = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.white.withOpacity(.7),
  );

  static final TextStyle value = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static final TextStyle menu = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static final TextStyle logout = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.yellow,
  );
}

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGreen,
      body: Column(
        children: [
          _topSection(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _infoCard(),
                SizedBox(height: 24),
                _menuItem(Icons.history, "History"),
                _menuItem(Icons.currency_rupee, "Payment Type"),
                _menuItem(Icons.qr_code, "QR Code"),
                _menuItem(Icons.star_border, "Feedback"),
                _menuItem(Icons.calendar_month, "Subscription Plan"),
                _menuItem(Icons.headset_mic, "Contact us"),
                SizedBox(height: 32),
                _logoutButton(),
                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topSection(BuildContext context) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 50,
            left: 16,
            child: Row(
              children: [
                _backButton(context),
                SizedBox(width: 12),
                Text("My Profile", style: AppText.header),
              ],
            ),
          ),
          Positioned(
            bottom: -45,
            child: _profileAvatar(),
          ),
        ],
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white20,
        ),
        child: Icon(Icons.arrow_back_ios_new, size: 18),
      ),
    );
  }

  Widget _profileAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage("assets/images/profile_photo.jpg"),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: 28,
            width: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
            ),
            child: Icon(Icons.edit, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _infoCard() {
    return Container(
      margin: EdgeInsets.only(top: 64),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white5,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text("John Dee", style: AppText.name),
          SizedBox(height: 16),
          _infoRow(Icons.email, "Email", "hello597@gmail.com"),
          _divider(),
          _infoRow(
            Icons.location_on,
            "Address",
            "Al Marsa Street 57, Dubai Marina, PO Box 32923, Dubai",
          ),
          _divider(),
          _infoRow(Icons.phone, "Mobile Number", "980765432"),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.yellow),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppText.label),
              SizedBox(height: 4),
              Text(value, style: AppText.value),
            ],
          ),
        ),
        Icon(Icons.edit, color: AppColors.white.withOpacity(.7), size: 18),
      ],
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Divider(color: AppColors.white20),
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: AppColors.yellow),
          title: Text(title, style: AppText.menu),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.white),
        ),
        Divider(color: AppColors.white20),
      ],
    );
  }

  Widget _logoutButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.yellow),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.logout, color: AppColors.yellow),
            SizedBox(width: 8),
            Text("Log out", style: AppText.logout),
          ],
        ),
      ),
    );
  }
}