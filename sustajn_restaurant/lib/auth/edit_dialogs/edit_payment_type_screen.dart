import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';

class EditPaymentTypeScreen extends ConsumerStatefulWidget {
  const EditPaymentTypeScreen({super.key});

  @override
  ConsumerState<EditPaymentTypeScreen> createState() => _EditPaymentTypeScreenState();
}

class _EditPaymentTypeScreenState extends ConsumerState<EditPaymentTypeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E3B2E),
      appBar: AppBar(
        backgroundColor: Color(0xFF0E3B2E),
        elevation: 3,
        leading: BackButton(color: Colors.white),
        title: Text(
          Strings.EDIT_PAYMENT_TYPE,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(Strings.CONFIRM_ACC_NO),
            _addCardButton(),
            _orDivider(),

            _sectionTitle(Strings.ONLINE_PAYMENT_GATEWAY),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
                border: Border.all(color: Colors.white),
              ),
              child: Column(
                children: [
                  SizedBox(height: Constant.CONTAINER_SIZE_10),
                  _paymentTile(Strings.PAYPAL, Icons.account_balance_wallet),

                  _paymentTile(Strings.APPLE_PAY, Icons.phone_iphone),

                  _paymentTile(Strings.GOOGLE_PAY, Icons.android),
                ],
              ),
            ),

            _orDivider(),

            _bankDetails(),
            SizedBox(height: Constant.CONTAINER_SIZE_24),
            _verifyButton(),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: Constant.SIZE_08),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white70,
          fontSize: Constant.CONTAINER_SIZE_14,
        ),
      ),
    );
  }

  Widget _addCardButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
        border: Border.all(color: Colors.white24),
      ),
      child: Center(
        child: Text(
          "💳  ${Strings.ADD_CARD}",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _orDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_20),
      child: Row(
        children: [
          Expanded(child: Divider(color: Color(0xFFD1AE31))),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Constant.SIZE_08),
            child: Text(Strings.OR, style: TextStyle(color: Colors.white)),
          ),
          Expanded(child: Divider(color: Color(0xFFD1AE31))),
        ],
      ),
    );
  }

  Widget _paymentTile(String title, IconData icon) {
    return Container(
      margin: EdgeInsets.only(
        left: Constant.SIZE_08,
        right: Constant.SIZE_08,
        bottom: Constant.CONTAINER_SIZE_12,
      ),
      padding: EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_10, horizontal: Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constant.SIZE_08),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: Constant.CONTAINER_SIZE_12),
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _bankDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Strings.BANK_DETAILS,
                style: TextStyle(color: Colors.white70)),
            Text("Clear Details",
                style: TextStyle(color: Colors.amber)),
          ],
        ),
        SizedBox(height: Constant.CONTAINER_SIZE_12),
        _inputField(context, hint: Strings.BANK_NAME, label:Strings.BANK_NAME),
        SizedBox(height: Constant.CONTAINER_SIZE_10),
        _inputField(context, hint: Strings.ACCOUNT_HOLDER_NAME, label: Strings.ACCOUNT_HOLDER_NAME),
        SizedBox(height: Constant.CONTAINER_SIZE_10),
        _inputField(context, hint: Strings.IBAN, label: Strings.IBAN),
        SizedBox(height: Constant.CONTAINER_SIZE_10),
        _inputField(context, hint: "BC", label: "BC"),

      ],
    );
  }

  Widget _inputField(
      BuildContext context, {
        required String hint,
        required String label,
        TextInputType keyboardType = TextInputType.text,
        TextEditingController? controller,
        String? Function(String?)? validator,
        List<TextInputFormatter>? inputFormatters,
      }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      inputFormatters: inputFormatters,
      style: TextStyle(
        color: Colors.white,
        fontSize: Constant.LABEL_TEXT_SIZE_14,
      ),
      cursorColor: Colors.white70,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white70,
          fontSize: Constant.CONTAINER_SIZE_13,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(
          horizontal: Constant.CONTAINER_SIZE_16,
          vertical: Constant.CONTAINER_SIZE_10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.SIZE_08),
          borderSide: BorderSide(color: Constant.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.SIZE_08),
          borderSide: BorderSide(color: Constant.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.SIZE_08),
          borderSide: BorderSide(color: Color(0xFFD1AE31)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.SIZE_08),
          borderSide: BorderSide(color: Constant.grey),
        ),
      ),
    );
  }

  Widget _verifyButton() {
    return SizedBox(
      width: double.infinity,
      height: Constant.CONTAINER_SIZE_52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFF2C94C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          ),
        ),
        onPressed: () {},
        child: Text(
          Strings.VERIFY,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
