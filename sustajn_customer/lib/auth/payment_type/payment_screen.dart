import 'package:flutter/material.dart';
import 'package:sustajn_customer/common_widgets/custom_app_bar.dart';
import 'package:sustajn_customer/common_widgets/custom_back_button.dart';
import 'package:sustajn_customer/utils/nav_utils.dart';
import '../../../constants/number_constants.dart';
import '../../utils/theme_utils.dart';
import '../screens/subscription_screen.dart';
import 'add_card_dialog.dart';

class PaymentTypeScreen extends StatelessWidget {
  const PaymentTypeScreen({super.key});

  BuildContext? get context => null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Payment Type',
        leading: CustomBackButton(),
      ).getAppBar(context),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
          child: SingleChildScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  Constant.CONTAINER_SIZE_20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(theme, title: 'Card Details'),
                _addCardButton(context, theme),
                _orDivider(theme),
                _sectionTitle(theme, title: 'Online Payment Gateway'),
                _paypalTile(theme),
                _orDivider(theme),
                _sectionTitle(theme, title: 'Bank title'),
                _bankFields(theme),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
          child: _bottomButtons(theme, context),
        ),
      ),
    );


  }


  Widget _sectionTitle(
      ThemeData theme, {
        String? title,
        String? subtitle,
      }) {
    if (title == null && subtitle == null) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: Constant.SIZE_10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subtitle != null && subtitle.isNotEmpty)
              Text(
                subtitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),

            if (title != null && title.isNotEmpty) ...[
              if (subtitle != null && subtitle.isNotEmpty)
                SizedBox(height: Constant.CONTAINER_SIZE_14),
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontSize: Constant.LABEL_TEXT_SIZE_16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }




  Widget _addCardButton(BuildContext context, ThemeData theme) {
    return InkWell(
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) => const AddCardDialog(),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Constant.SIZE_15),
        decoration: BoxDecoration(
          border: Border.all(
            color: Constant.grey.withOpacity(0.3)
          ),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          color: Constant.grey.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.credit_card, color: Constant.gold),
            SizedBox(width: Constant.SIZE_08),
            Text(
              'Add Card',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Constant.gold,
                fontSize: Constant.LABEL_TEXT_SIZE_16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orDivider(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Constant.SIZE_15),
      child: Row(
        children: [
          Expanded(child: Divider(color: Constant.gold)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Constant.SIZE_10),
            child: Text(
              'or',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          Expanded(child: Divider(color: Constant.gold)),
        ],
      ),
    );
  }

  Widget _paypalTile(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Constant.grey.withOpacity(0.3)
        ),
        color:Constant.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
      ),
      child: Row(
        children: [
          Icon(Icons.account_balance_wallet, color: Colors.white),
          SizedBox(width: Constant.CONTAINER_SIZE_12),
          Text(
            'PayPal',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontSize: Constant.LABEL_TEXT_SIZE_16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bankFields(ThemeData theme) {
    return Column(
      children: [
        _inputField(theme, 'Bank Name'),
        SizedBox(height: Constant.SIZE_10),
        _inputField(theme, 'Account Holder Name*'),
        SizedBox(height: Constant.SIZE_10),
        _inputField(theme, 'IBAN and BIC'),
      ],
    );
  }

  Widget _inputField(ThemeData theme, String hint) {
    return TextField(
      style: theme.textTheme.bodyLarge?.copyWith(
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.white,
        ),
        filled: true,
        fillColor: Constant.grey.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
            borderSide: BorderSide(color: Constant.grey.withOpacity(0.3)),
          ),
          enabledBorder: CustomTheme.roundedBorder(Constant.grey.withOpacity(0.3)),
          focusedBorder: CustomTheme.roundedBorder(Constant.grey.withOpacity(0.3)),
      ),
    );
  }

  Widget _bottomButtons(ThemeData theme,BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              NavUtil.navigateToPushScreen(context, SubscriptinonScreen());
            },

            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Constant.gold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
              ),
            ),
            child: Text(
              'Skip',
              style: theme.textTheme.labelLarge?.copyWith(
                color: Constant.gold,
              ),
            ),
          ),
        ),
        SizedBox(width: Constant.SIZE_15),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Constant.gold,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
              ),
            ),
            child: Text(
              'Verify & Continue',

              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
