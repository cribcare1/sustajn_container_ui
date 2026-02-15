import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/auth/model/payment_type_model.dart';
import 'package:sustajn_restaurant/common_widgets/card_widget.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/notifier/login_notifier.dart';
import 'package:sustajn_restaurant/provider/login_provider.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';
import 'package:sustajn_restaurant/utils/utility.dart';

import '../../../constants/number_constants.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../constants/string_utils.dart';
import '../../notifier/profile_notifier.dart';
import '../../provider/profile_provider.dart';
import '../../utils/global_utils.dart';
import '../../utils/theme_utils.dart';
import '../screens/subscription_screen.dart';
import '../widgets/add_card_buttom_sheet.dart';

class PaymentTypeScreen extends ConsumerStatefulWidget {
  final String? profile;

  const PaymentTypeScreen({super.key, this.profile = ""});

  @override
  ConsumerState<PaymentTypeScreen> createState() => _PaymentTypeScreenState();
}

class _PaymentTypeScreenState extends ConsumerState<PaymentTypeScreen> {
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountHolderNameController =
      TextEditingController();
  final TextEditingController bicController = TextEditingController();
  final TextEditingController ibanController = TextEditingController();

  final Map<String, String?> _bankFieldErrors = {
    'bankName': null,
    'accountHolder': null,
    'iban': null,
    'bic': null,
  };

  final Map<String, bool> _bankFieldTouched = {
    'bankName': false,
    'accountHolder': false,
    'iban': false,
    'bic': false,
  };

  bool _showBankErrors = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authNotifierProvider).clearBankErrors();
    });
    _getData();

    bankNameController.addListener(() {
      _validateBankField(
        'bankName',
        bankNameController.text,
        _validateBankName,
      );
    });
    accountHolderNameController.addListener(() {
      _validateBankField(
        'accountHolder',
        accountHolderNameController.text,
        _validateAccountHolder,
      );
    });
    ibanController.addListener(() {
      _validateBankField('iban', ibanController.text, _validateIban);
    });
    bicController.addListener(() {
      _validateBankField('bic', bicController.text, _validateBic);
    });
  }

  _getData() {
    final profileState = ref.read(profileProvider);
    print("Full Data: ${profileState.getProfileData?.data}");

    final bankResponse = profileState.getProfileData?.data?.bankDetailsResponse;

    if (bankResponse != null) {
      bankNameController.text = bankResponse.bankName ?? "";
      accountHolderNameController.text = bankResponse.accountHolderName ?? "";
      ibanController.text = bankResponse.iBanNumber ?? "";
      bicController.text = bankResponse.bicNumber ?? "";
    }
  }


  String? _validateBankName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bank name is required';
    }

    if (value.trim().length < 3) {
      return 'Bank name should be at least 3 characters';
    }

    if (value.trim().length > 50) {
      return 'Bank name should not exceed 50 characters';
    }

    final RegExp bankNameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!bankNameRegex.hasMatch(value.trim())) {
      return 'Bank name should contain only letters and spaces';
    }

    return null;
  }

  String? _validateAccountHolder(String? value) {
    if (value == null || value.isEmpty) {
      return 'Account holder name is required';
    }

    if (value.trim().length < 3) {
      return 'Account holder name should be at least 3 characters';
    }

    if (value.trim().length > 50) {
      return 'Account holder name should not exceed 50 characters';
    }

    final RegExp holderNameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!holderNameRegex.hasMatch(value.trim())) {
      return 'Account holder name should contain only letters and spaces';
    }

    return null;
  }

  String? _validateIban(String? value) {
    if (value == null || value.isEmpty) {
      return 'IBAN is required';
    }

    final cleanedValue = value.replaceAll(RegExp(r'\s'), '');

    if (cleanedValue.length != 23) {
      return 'IBAN must be exactly 23 characters';
    }

    if (!RegExp(r'^[A-Z]{2}').hasMatch(cleanedValue)) {
      return 'IBAN should start with 2 letters (country code)';
    }

    final restDigits = cleanedValue.substring(2);
    if (!RegExp(r'^\d+$').hasMatch(restDigits)) {
      return 'IBAN should contain only digits after country code';
    }

    return null;
  }

  String? _validateBic(String? value) {
    if (value == null || value.isEmpty) {
      return 'BIC is required';
    }

    final cleanedValue = value.replaceAll(RegExp(r'\s'), '').toUpperCase();

    if (cleanedValue.length != 11) {
      return 'BIC must be exactly 11 characters';
    }

    final firstEight = cleanedValue.substring(0, 8);
    if (!RegExp(r'^[A-Z]{8}$').hasMatch(firstEight)) {
      return 'First 8 characters of BIC should be letters';
    }

    final lastThree = cleanedValue.substring(8);
    if (!RegExp(r'^[0-9]{3}$').hasMatch(lastThree)) {
      return 'Last 3 characters of BIC should be digits';
    }

    return null;
  }

  void _validateBankField(
    String fieldName,
    String value,
    String? Function(String?) validator,
  ) {
    if (!_bankFieldTouched[fieldName]! && !_showBankErrors) {
      return;
    }

    final error = validator(value);

    if (_bankFieldErrors[fieldName] != error) {
      setState(() {
        _bankFieldTouched[fieldName] = true;
        _bankFieldErrors[fieldName] = error;
      });
    }
  }

  bool _isBankDetailsValid() {
    return _bankFieldErrors.values.every((error) => error == null) &&
        bankNameController.text.isNotEmpty &&
        accountHolderNameController.text.isNotEmpty &&
        ibanController.text.isNotEmpty &&
        bicController.text.isNotEmpty;
  }

  @override
  void dispose() {
    bankNameController.dispose();
    accountHolderNameController.dispose();
    bicController.dispose();
    ibanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.profile == 'profile' ? Strings.EDIT_PAYMENT_TYPE : '',
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_arrow_left, color: Colors.white),
          ),
        ).getAppBar(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.profile == "") ...[
                SizedBox(height: Constant.CONTAINER_SIZE_16),
                Row(
                  children: List.generate(4, (index) {
                    bool active = index <= 2;
                    return Expanded(
                      child: Container(
                        height: Constant.SIZE_05,
                        margin: EdgeInsets.only(
                          right: index == 3 ? 0 : Constant.SIZE_10,
                        ),
                        decoration: BoxDecoration(
                          color: active ? Constant.gold : Colors.white,
                          borderRadius: BorderRadius.circular(Constant.SIZE_10),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: Constant.CONTAINER_SIZE_16),
                Text(
                  Strings.PAYMENT_TYPE,
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Constant.CONTAINER_SIZE_16),
              ],

              _sectionTitle(theme, title: Strings.CARD_DETAILS),
              (authState.cardDetails == null)
                  ? _addCardButton(context, theme, authState)
                  : GlassSummaryCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Account Holder: ",
                                        style: theme.textTheme.titleSmall!
                                            .copyWith(color: Colors.white),
                                      ),
                                      TextSpan(
                                        text: authState
                                            .cardDetails!
                                            .cardHolderName,
                                        style: theme.textTheme.titleSmall!
                                            .copyWith(
                                              color: theme.secondaryHeaderColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        builder: (_) =>
                                            AddCardDialog(state: authState),
                                      );
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: theme.secondaryHeaderColor,
                                    ),
                                  ),
                                  SizedBox(width: Constant.CONTAINER_SIZE_10),
                                  GestureDetector(
                                    onTap: authState.removeCard,
                                    child: Icon(
                                      Icons.delete,
                                      color: theme.secondaryHeaderColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: Constant.SIZE_06),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Card Number: ",
                                  style: theme.textTheme.titleSmall!.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: maskCardNumber(
                                    authState.cardDetails!.cardNumber,
                                  ),
                                  style: theme.textTheme.titleSmall!.copyWith(
                                    color: theme.secondaryHeaderColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Constant.SIZE_06),
                          Row(
                            children: [
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Expiry: ",
                                        style: theme.textTheme.titleSmall!
                                            .copyWith(color: Colors.white),
                                      ),
                                      TextSpan(
                                        text: authState.cardDetails!.expiryDate,
                                        style: theme.textTheme.titleSmall!
                                            .copyWith(
                                              color: theme.secondaryHeaderColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "CVV: ",
                                        style: theme.textTheme.titleSmall!
                                            .copyWith(color: Colors.white),
                                      ),
                                      TextSpan(
                                        text: "***",
                                        style: theme.textTheme.titleSmall!
                                            .copyWith(
                                              color: theme.secondaryHeaderColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

              _orDivider(theme),
              _sectionTitle(theme, title: Strings.ONLINE_PAYMENT_GATEWAY),
              paymentGatewayTile(
                context: context,
                theme: theme,
                notifier: authState,
                title: Strings.PAYPAL,
                asset: 'assets/images/paypal.webp',
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              paymentGatewayTile(
                context: context,
                theme: theme,
                notifier: authState,
                title: Strings.APPLE_PAY,
                asset: 'assets/images/apple_pay.png',
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              paymentGatewayTile(
                context: context,
                theme: theme,
                notifier: authState,
                title: Strings.GOOGLE_PAY,
                asset: 'assets/images/google_pay.png',
              ),
              _orDivider(theme),
              _sectionTitle(theme, title: 'Bank Details'),
              _bankFields(theme, authState),
              SizedBox(height: Constant.CONTAINER_SIZE_16),
              SizedBox(
                width: double.infinity,
                child: SubmitButton(
                  onRightTap: () async {
                    bool hasCardDetails = authState.cardDetails != null;
                    bool hasGateway = authState.gateway != null;
                    bool hasBankDetails =
                        bankNameController.text.isNotEmpty &&
                        accountHolderNameController.text.isNotEmpty &&
                        ibanController.text.isNotEmpty &&
                        bicController.text.isNotEmpty;

                    if (!hasCardDetails && !hasGateway && !hasBankDetails) {
                      showCustomSnackBar(
                        context: context,
                        message: 'Please select at least one payment method',
                        color: Colors.grey,
                      );
                      return;
                    }

                    if (hasBankDetails) {
                      setState(() {
                        _showBankErrors = true;
                        _bankFieldErrors['bankName'] = _validateBankName(
                          bankNameController.text,
                        );
                        _bankFieldErrors['accountHolder'] =
                            _validateAccountHolder(
                              accountHolderNameController.text,
                            );
                        _bankFieldErrors['iban'] = _validateIban(
                          ibanController.text,
                        );
                        _bankFieldErrors['bic'] = _validateBic(
                          bicController.text,
                        );
                      });

                      if (!_isBankDetailsValid()) {
                        showCustomSnackBar(
                          context: context,
                          message: 'Please fix bank details errors',
                          color: Colors.red,
                        );
                        return;
                      }

                      final bankData = BankDetailsModel(
                        bankName: bankNameController.text.trim(),
                        accountHolderName: accountHolderNameController.text
                            .trim(),
                        ibanNumber: ibanController.text.replaceAll(
                          RegExp(r'\s'),
                          '',
                        ),
                        bicNumber: bicController.text.replaceAll(
                          RegExp(r'\s'),
                          '',
                        ),
                      );

                      authState.setBankDetails(bankData);
                    }

                    NavUtil.navigateToPushScreen(context, SubscriptionScreen());
                  },
                  rightText: widget.profile == 'profile'
                      ? Strings.VERIFY
                      : Strings.VERIFY_CONT,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(ThemeData theme, {String? title}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: Constant.SIZE_10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null && title.isNotEmpty) ...[
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _addCardButton(
    BuildContext context,
    ThemeData theme,
    AuthState state,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => AddCardDialog(state: state),
        );
      },
      child: GlassSummaryCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.credit_card, color: Constant.gold),
            SizedBox(width: Constant.SIZE_08),
            Text(
              'Add Card',
              style: theme.textTheme.titleSmall?.copyWith(
                color: Constant.gold,
                fontWeight: FontWeight.w600,
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

  Widget paymentGatewayTile({
    required BuildContext context,
    required ThemeData theme,
    required AuthState notifier,
    required String title,
    required String asset,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) =>
              AddGatewayDialog(title: title, asset: asset, notifier: notifier),
        );
      },
      child: Container(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_10),
        decoration: BoxDecoration(
          color: const Color(0xFF1E4636),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Image.asset(asset, height: Constant.CONTAINER_SIZE_30),
            SizedBox(width: Constant.CONTAINER_SIZE_12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (notifier.gateway != null &&
                      notifier.gateway!.name == title)
                    Padding(
                      padding: EdgeInsets.only(top: Constant.SIZE_04),
                      child: Text(
                        notifier.gateway!.id!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bankFields(ThemeData theme, var auth) {
    return Column(
      children: [
        _buildBankTextField(
          theme,
          hint: 'Bank Name',
          controller: bankNameController,
          fieldName: 'bankName',
          validator: _validateBankName,
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
          ],
        ),
        SizedBox(height: Constant.SIZE_10),
        _buildBankTextField(
          theme,
          hint: 'Account Holder Name',
          controller: accountHolderNameController,
          fieldName: 'accountHolder',
          validator: _validateAccountHolder,
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
          ],
        ),
        SizedBox(height: Constant.SIZE_10),
        _buildBankTextField(
          theme,
          hint: 'IBAN',
          controller: ibanController,
          fieldName: 'iban',
          validator: _validateIban,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9 ]')),
            LengthLimitingTextInputFormatter(23),
          ],
        ),
        SizedBox(height: Constant.SIZE_10),
        _buildBankTextField(
          theme,
          hint: 'BIC',
          controller: bicController,
          fieldName: 'bic',
          validator: _validateBic,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9 ]')),
            LengthLimitingTextInputFormatter(11),
          ],
        ),
      ],
    );
  }

  Widget _buildBankTextField(
    ThemeData theme, {
    required String hint,
    required TextEditingController controller,
    required String fieldName,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final error = _bankFieldErrors[fieldName];

    return Padding(
      padding: EdgeInsets.only(bottom: Constant.SIZE_08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white70,
              fontSize: Constant.CONTAINER_SIZE_14,
            ),
            cursorColor: Colors.white,
            textCapitalization: fieldName == 'iban' || fieldName == 'bic'
                ? TextCapitalization.characters
                : TextCapitalization.words,
            onChanged: (value) {
              if (!_bankFieldTouched[fieldName]!) {
                setState(() {
                  _bankFieldTouched[fieldName] = true;
                });
              }
              _validateBankField(fieldName, value, validator);
            },
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
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                borderSide: BorderSide(
                  color: error != null
                      ? Colors.red
                      : Constant.grey.withOpacity(0.3),
                  width: error != null ? 1.5 : 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                borderSide: BorderSide(
                  color: error != null
                      ? Colors.red
                      : Constant.grey.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
            ),
          ),
          // Show error below field
          if (error != null)
            Padding(
              padding: EdgeInsets.only(
                top: Constant.SIZE_06,
                left: Constant.CONTAINER_SIZE_12,
              ),
              child: Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

class AddGatewayDialog extends StatefulWidget {
  final String title;
  final String asset;
  final AuthState notifier;

  const AddGatewayDialog({
    super.key,
    required this.title,
    required this.asset,
    required this.notifier,
  });

  @override
  State<AddGatewayDialog> createState() => _AddGatewayDialogState();
}

class _AddGatewayDialogState extends State<AddGatewayDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _error;
  bool _touched = false;


  String? _validatePayPalId(String? value) {
    if (value == null || value.isEmpty) {
      return 'PayPal ID is required';
    }

    if (value.contains('@')) {
      final RegExp emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      if (!emailRegex.hasMatch(value.trim())) {
        return 'Please enter a valid PayPal email';
      }
    } else {
      final RegExp idRegex = RegExp(r'^[a-zA-Z0-9\-_]{6,}$');
      if (!idRegex.hasMatch(value.trim())) {
        return 'Invalid PayPal ID format';
      }
    }

    return null;
  }

  String? _validateGooglePayId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Google Pay ID is required';
    }

    final email = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    final phone = RegExp(r'^\+?[0-9]{10,15}$');

    if (!email.hasMatch(value.trim()) && !phone.hasMatch(value.trim())) {
      return 'Please enter a valid email or phone number';
    }

    return null;
  }

  String? _validateApplePayId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Apple Pay ID is required';
    }

    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid Apple ID email';
    }

    return null;
  }

  String? _validateGatewayId(String? value) {
    if (widget.title == 'PayPal') {
      return _validatePayPalId(value);
    } else if (widget.title == 'Google Pay') {
      return _validateGooglePayId(value);
    } else if (widget.title == 'Apple Pay') {
      return _validateApplePayId(value);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),

        child: Container(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
          decoration: BoxDecoration(
            color: Color(0xFF123D2C),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Constant.CONTAINER_SIZE_20),
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Link ${widget.title} Account",
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          if (!_touched) {
                            setState(() {
                              _touched = true;
                            });
                          }
                          final error = _validateGatewayId(value);
                          if (_error != error) {
                            setState(() {
                              _error = error;
                            });
                          }
                        },
                        validator: (_) => null,
                        decoration: InputDecoration(
                          hintText: 'enter your ${widget.title} ID',
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Constant.CONTAINER_SIZE_14,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Constant.CONTAINER_SIZE_14,
                            ),
                            borderSide: BorderSide(
                              color: _error != null ? Colors.red : Colors.white24,
                              width: _error != null ? 1.5 : 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Constant.CONTAINER_SIZE_14,
                            ),
                            borderSide: BorderSide(
                              color: _error != null ? Colors.red : Colors.white24,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      if (_error != null)
                        Padding(
                          padding: EdgeInsets.only(
                            top: Constant.SIZE_08,
                            left: Constant.CONTAINER_SIZE_12,
                          ),
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _error == null && _controller.text.isNotEmpty
                            ? Colors.amber
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_14,
                          ),
                        ),
                      ),
                      onPressed: _error == null && _controller.text.isNotEmpty
                          ? () {
                              widget.notifier.setGateway(
                                PaymentGatewayModel(
                                  name: widget.title,
                                  id: _controller.text.trim(),
                                  asset: widget.asset,
                                ),
                              );
                              Navigator.pop(context);
                            }
                          : null,
                      child: Text(
                        Strings.ADD_CONT,
                        style: TextStyle(
                          color: _error == null && _controller.text.isNotEmpty
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
