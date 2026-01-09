import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_customer/common_widgets/custom_app_bar.dart';
import 'package:sustajn_customer/common_widgets/custom_back_button.dart';
import 'package:sustajn_customer/models/register_data.dart';

import '../../../constants/number_constants.dart';
import '../../auth/payment_type/add_card_dialog.dart';
import '../../constants/string_utils.dart';
import '../../provider/signup_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utils.dart';

class EditPaymentScreen extends ConsumerStatefulWidget {
  final RegistrationData? registrationData;

  const EditPaymentScreen({super.key, this.registrationData});

  @override
  ConsumerState<EditPaymentScreen> createState() => _PaymentTypeScreenState();
}

class _PaymentTypeScreenState extends ConsumerState<EditPaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountHolderController =
  TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _bicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signupState = ref.watch(signUpNotifier);

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
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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

                // ⭐ Bank Details + Clear Details (only text added)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Bank Details",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontSize: Constant.LABEL_TEXT_SIZE_16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),


                    InkWell(
                      onTap: () {
                        Utils.logOutDialog(
                          context,
                          Icons.warning_amber,
                          Strings.REMOVE_DETAILS,
                          Strings.DELETE_MESSAGE,
                          Strings.REMOVE,
                          Strings.CANCEL,
                        );
                      },


                   child: Text(
                      "Clear Details",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Constant.gold,
                        fontSize: Constant.LABEL_TEXT_SIZE_14,
                        fontWeight: FontWeight.w500,
                      ),
                   ),
                    ),
                  ],
                ),

                _bankFields(theme, signupState),
              ],

            ),
          ),
        ),
      ),

      bottomNavigationBar: _verifyButton(theme, context, signupState),
    );
  }

  Widget _sectionTitle(ThemeData theme, {String? title, String? subtitle}) {
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
          border: Border.all(color: Constant.grey.withOpacity(0.3)),
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
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
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
        border: Border.all(color: Constant.grey.withOpacity(0.3)),
        color: Constant.grey.withOpacity(0.1),
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
        border: Border.all(color: Constant.grey.withOpacity(0.3)),
        color: Constant.grey.withOpacity(0.1),
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
        border: Border.all(color: Constant.grey.withOpacity(0.3)),
        color: Constant.grey.withOpacity(0.1),
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

  Widget _bankFields(ThemeData theme, var signupState) {
    return Column(
      children: [
        _field(
          theme: theme,
          controller: _bankNameController,
          hint: 'Bank Name',
          error: signupState.bankNameError,
          onChanged: signupState.setBankName,
        ),
        SizedBox(height: Constant.SIZE_10),

        _field(
          theme: theme,
          controller: _accountHolderController,
          hint: 'Account Holder Name',
          error: signupState.accountHolderError,
          onChanged: signupState.setAccountHolderName,
        ),
        SizedBox(height: Constant.SIZE_10),

        _field(
          theme: theme,
          controller: _ibanController,
          hint: 'IBAN',
          error: signupState.ibanError,
          onChanged: signupState.setIban,
        ),
        SizedBox(height: Constant.SIZE_10),

        _field(
          theme: theme,
          controller: _bicController,
          hint: 'BIC',
          error: signupState.bicError,
          onChanged: signupState.setBic,
        ),
      ],
    );
  }

  Widget _field({
    required ThemeData theme,
    required TextEditingController controller,
    required String hint,
    required String? error,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
          cursorColor: Colors.white,
          onChanged: onChanged,
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
            enabledBorder: CustomTheme.roundedBorder(
              Constant.grey.withOpacity(0.3),
            ),
            focusedBorder: CustomTheme.roundedBorder(
              Constant.grey.withOpacity(0.3),
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              error,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _verifyButton(
      ThemeData theme,
      BuildContext context,
      var signupState,
      ) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
        child: SizedBox(
          width: double.infinity,
          height: Constant.CONTAINER_SIZE_50,
          child: ElevatedButton(
            onPressed: () {
              final isValid = signupState.validateBankForm();

              if (isValid) {
                signupState.updateBankDetails();
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Constant.gold,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(Constant.CONTAINER_SIZE_16),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Verify',
                maxLines: 1,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}