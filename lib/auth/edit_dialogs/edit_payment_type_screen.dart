import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/utility.dart';

class EditPaymentTypeScreen extends ConsumerStatefulWidget {
  const EditPaymentTypeScreen({super.key});

  @override
  ConsumerState<EditPaymentTypeScreen> createState() => _EditPaymentTypeScreenState();
}

class _EditPaymentTypeScreenState extends ConsumerState<EditPaymentTypeScreen> {

  final _key = GlobalKey<FormState>();
  final bankNameController = TextEditingController();
  final acHolderNameController = TextEditingController();
  final ibanController = TextEditingController();
  final bicController = TextEditingController();


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
                  _paymentTile(Strings.PAYPAL,
                    Image.asset('assets/images/paypal.webp'),
                  ),

                  _paymentTile(Strings.APPLE_PAY,
                      Image.asset('assets/images/apple_pay.png')
                  ),

                  _paymentTile(Strings.GOOGLE_PAY,
                      Image.asset('assets/images/google_pay.png')
                  )
                ],
              ),
            ),

            _orDivider(),

            Form(key: _key,
                child: _bankDetails()
            ),
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

  Widget _paymentTile(String title, Image image) {
    return Container(
      margin: EdgeInsets.only(
        left: Constant.SIZE_08,
        right: Constant.SIZE_08,
        bottom: Constant.CONTAINER_SIZE_12,
      ),
      padding: EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_10, horizontal: Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          SizedBox(
            width: Constant.CONTAINER_SIZE_24,
            height: Constant.CONTAINER_SIZE_24,
            child: image,
          ),
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
            Text(Strings.CLEAR_DTLS,
                style: TextStyle(color: Colors.amber)),
          ],
        ),
        SizedBox(height: Constant.CONTAINER_SIZE_12),
        Utils.buildTextField(
          context,
          controller: bankNameController,
          label: Strings.BANK_NAME,
          hint: Strings.BANK_NAME,
          keyboard: TextInputType.emailAddress,
          validator: Utils.validateEmailId,
        ),
        SizedBox(height: Constant.CONTAINER_SIZE_10),
        Utils.buildTextField(
          context,
          controller: bankNameController,
          label: Strings.BANK_NAME,
          hint: Strings.BANK_NAME,
          keyboard: TextInputType.emailAddress,
          validator: Utils.validateEmailId,
        ),
        SizedBox(height: Constant.CONTAINER_SIZE_10),
        Utils.buildTextField(
          context,
          controller: bankNameController,
          label: Strings.IBAN,
          hint: Strings.IBAN,
          keyboard: TextInputType.emailAddress,
          validator: Utils.validateEmailId,
        ),
        SizedBox(height: Constant.CONTAINER_SIZE_10),

        Utils.buildTextField(
          context,
          controller: bankNameController,
          label: Strings.BIC,
          hint: Strings.BIC,
          keyboard: TextInputType.emailAddress,
          validator: Utils.validateEmailId,
        ),
      ],
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
        onPressed: () {
          if (!_key.currentState!.validate()) {
            return;
          }
          Utils.showToast("Information uploaded successful");
        },
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
