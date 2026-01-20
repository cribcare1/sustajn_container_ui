import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_customer/common_widgets/custom_app_bar.dart';
import 'package:sustajn_customer/common_widgets/custom_back_button.dart';

import '../../../constants/number_constants.dart';
import '../../auth/payment_type/add_card_dialog.dart';
import '../../constants/string_utils.dart';
import '../../models/get_profile_model.dart';
import '../../provider/signup_provider.dart';
import '../../utils/theme_utils.dart';

class EditPaymentScreen extends ConsumerStatefulWidget {
  final BankDetailsResponse? bankDetails;

  const EditPaymentScreen({super.key, this.bankDetails});

  @override
  ConsumerState<EditPaymentScreen> createState() => _PaymentTypeScreenState();
}

class _PaymentTypeScreenState extends ConsumerState<EditPaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _taxNumberController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final bank = widget.bankDetails;

    if (bank != null) {
      _bankNameController.text = bank.bankName ?? '';
      _accountNumberController.text = bank.accountNumber ?? '';
      _taxNumberController.text = bank.taxNumber ?? '';
      _ibanController.text = bank.iBanNumber ?? '';
    }
  }

  String? _validateBankName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bank name is required';
    }
    if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
      return 'Only letters and numbers allowed';
    }
    return null;
  }

  String? _validateAccountNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account number is required';
    }
    if (!RegExp(r'^[0-9]{9,18}$').hasMatch(value)) {
      return 'Account number must be 9–18 digits';
    }
    return null;
  }

  String? _validateTaxNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'GSTIN is required';
    }
    if (!RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
    ).hasMatch(value)) {
      return 'Invalid GSTIN format';
    }
    return null;
  }

  String? _validateIBAN(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'IBAN is required';
    }
    if (!RegExp(r'^[A-Z0-9]{15,34}$').hasMatch(value)) {
      return 'IBAN must be 15–34 characters';
    }
    return null;
  }

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.only(
                left: Constant.CONTAINER_SIZE_20,
                right: Constant.CONTAINER_SIZE_20,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom +
                    Constant.CONTAINER_SIZE_20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                    _bankHeader(theme, signupState),

                    _bankFields(theme),

                    SizedBox(height: Constant.CONTAINER_SIZE_40),

                    _verifyButton(theme, context, signupState),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _bankHeader(ThemeData theme, var signupState) {
    return Padding(
      padding: EdgeInsets.only(bottom: Constant.SIZE_10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Bank Details',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontSize: Constant.LABEL_TEXT_SIZE_16,
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: () async {
              final shouldClear = await displayDialog(
                context,
                Icons.warning_amber_rounded,
                Strings.REMOVE_DETAILS,
                Strings.DELETE_MESSAGE,
                Strings.REMOVE,
              );

              if (shouldClear) {}
            },
            child: Text(
              "Clear fields",

              style: theme.textTheme.bodyMedium?.copyWith(
                color: Constant.gold,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                decorationColor: Constant.gold,
              ),
            ),
          ),
        ],
      ),
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

  Widget _bankFields(ThemeData theme) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _field(
            theme: theme,
            controller: _bankNameController,
            hint: 'Bank Name',
            validator: _validateBankName,
          ),
          SizedBox(height: Constant.SIZE_10),

          _field(
            theme: theme,
            controller: _accountNumberController,
            hint: 'Account Number',
            validator: _validateAccountNumber,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(18),
            ],
          ),
          SizedBox(height: Constant.SIZE_10),

          _field(
            theme: theme,
            controller: _taxNumberController,
            hint: 'Tax Number',
            validator: _validateTaxNumber,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
              LengthLimitingTextInputFormatter(15),
            ],
          ),
          SizedBox(height: Constant.SIZE_10),

          _field(
            theme: theme,
            controller: _ibanController,
            hint: 'IBAN',
            validator: _validateIBAN,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
              LengthLimitingTextInputFormatter(34),
            ],
          ),
        ],
      ),
    );
  }

  Widget _field({
    required ThemeData theme,
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      inputFormatters: inputFormatters,
      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
        filled: true,
        fillColor: Constant.grey.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        ),
        enabledBorder: CustomTheme.roundedBorder(
          Constant.grey.withOpacity(0.3),
        ),
        focusedBorder: CustomTheme.roundedBorder(
          Constant.grey.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _verifyButton(ThemeData theme, BuildContext context, var signupState) {
    return Padding(
      padding: EdgeInsets.only(top: Constant.CONTAINER_SIZE_20),
      child: SizedBox(
        width: double.infinity,
        height: Constant.CONTAINER_SIZE_50,
        child: ElevatedButton(
          onPressed: () {
            final isValid = signupState.validateBankForm();

            if (isValid) {
              signupState.updateBankDetails();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Constant.gold,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
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
    );
  }

  Future<bool> displayDialog(
    BuildContext context,
    IconData icon,
    String title,
    String subTitle,
    String stayButtonText,
  ) async {
    final theme = Theme.of(context);

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => Dialog(
            backgroundColor: theme.scaffoldBackgroundColor,
            insetPadding: EdgeInsets.symmetric(
              horizontal: Constant.PADDING_HEIGHT_10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
            ),
            child: Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_12,
                      ),
                      border: Border.all(color: Constant.grey.withOpacity(0.1)),
                      color: Constant.white.withOpacity(0.1),
                      shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      icon,
                      size: Constant.CONTAINER_SIZE_40,
                      color: Constant.gold,
                    ),
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_12),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_05),
                  Text(
                    subTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_12),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFC8B531)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Constant.CONTAINER_SIZE_12,
                              ),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Constant.gold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: Constant.CONTAINER_SIZE_12),

                      // STAY
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constant.gold,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Constant.CONTAINER_SIZE_12,
                              ),
                            ),
                          ),
                          child: Text(
                            stayButtonText,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false;
  }
}
