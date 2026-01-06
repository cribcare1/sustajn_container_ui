import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_customer/common_widgets/custom_app_bar.dart';
import 'package:sustajn_customer/common_widgets/custom_back_button.dart';
import 'package:sustajn_customer/models/register_data.dart';
import 'package:sustajn_customer/utils/nav_utils.dart';
import '../../../constants/number_constants.dart';
import '../../constants/network_urls.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/login_provider.dart';
import '../../provider/signup_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utils.dart';
import '../screens/subscription_screen.dart';
import 'add_card_dialog.dart';

class PaymentTypeScreen extends ConsumerStatefulWidget {
  final RegistrationData? registrationData;
  const PaymentTypeScreen({super.key, this.registrationData});

  @override
  ConsumerState<PaymentTypeScreen> createState() => _PaymentTypeScreenState();
}

class _PaymentTypeScreenState extends ConsumerState<PaymentTypeScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountHolderController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _bicController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signupState = ref.watch(signUpNotifier);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                  SizedBox(height: Constant.SIZE_10),
                  _applePay(theme),
                  SizedBox(height: Constant.SIZE_10),
                  _googlePay(theme),
                  SizedBox(height: Constant.SIZE_10),
                  _orDivider(theme),
                  _sectionTitle(theme, title: 'Bank Details'),
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
          Image.asset('assets/icons/paypal.png'),
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

  Widget _applePay(ThemeData theme) {
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
          Image.asset('assets/icons/apple_pay.png'),
          SizedBox(width: Constant.CONTAINER_SIZE_12),
          Text(
            'Apple Pay',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontSize: Constant.LABEL_TEXT_SIZE_16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _googlePay(ThemeData theme) {
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
          Image.asset('assets/icons/google_pay.png'),
          SizedBox(width: Constant.CONTAINER_SIZE_12),
          Text(
            'Google Pay',
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _validatedField(
            theme: theme,
            controller: _bankNameController,
            hint: 'Bank Name',
            validator: _validateBankName,
          ),
          SizedBox(height: Constant.SIZE_10),

          _validatedField(
            theme: theme,
            controller: _accountHolderController,
            hint: 'Account Holder Name*',
            validator: _validateAccountHolder,
          ),
          SizedBox(height: Constant.SIZE_10),

          _validatedField(
            theme: theme,
            controller: _ibanController,
            hint: 'IBAN',
            validator: _validateIBAN,
          ),
          SizedBox(height: Constant.SIZE_10),

          _validatedField(
            theme: theme,
            controller: _bicController,
            hint: 'BIC',
            validator: _validateBIC,
          ),
        ],
      ),
    );
  }


  String? _validateBankName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bank name is required';
    }
    if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
      return 'Special characters are not allowed';
    }
    return null;
  }

  String? _validateAccountHolder(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account holder name is required';
    }
    if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
      return 'Special characters are not allowed';
    }
    return null;
  }

  String? _validateIBAN(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'IBAN is required';
    }
    if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(value)) {
      return 'Only letters and numbers allowed';
    }
    if (value.length < 15 || value.length > 34) {
      return 'IBAN must be 15–34 characters';
    }
    return null;
  }

  String? _validateBIC(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'BIC is required';
    }
    if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(value)) {
      return 'Only letters and numbers allowed';
    }
    if (value.length != 8 && value.length != 11) {
      return 'BIC must be 8 or 11 characters';
    }
    return null;
  }


  Widget _validatedField({
    required ThemeData theme,
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
      cursorColor: Colors.white,
      validator: validator,
      onChanged: (_) {
        if (_formKey.currentState != null) {
          _formKey.currentState!.validate();
        }
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
        filled: true,
        fillColor: Constant.grey.withOpacity(0.1),
        errorStyle: TextStyle(color: Colors.redAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          borderSide: BorderSide(color: Constant.grey.withOpacity(0.3)),
        ),
        enabledBorder:
        CustomTheme.roundedBorder(Constant.grey.withOpacity(0.3)),
        focusedBorder:
        CustomTheme.roundedBorder(Constant.grey.withOpacity(0.3)),
      ),
    );
  }


  Widget _bottomButtons(
      ThemeData theme,
      BuildContext context,
      ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              NavUtil.navigateWithReplacement( SubscriptionScreen());
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
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                NavUtil.navigateWithReplacement(SubscriptionScreen());
              }
            },

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
