import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
enum PaymentFlow {
  signup,
  profile,
}

class PaymentTypeScreen extends ConsumerStatefulWidget {
  final RegistrationData? registrationData;
  final PaymentFlow flow;

  const PaymentTypeScreen({super.key, this.registrationData,
  required this.flow});

  @override
  ConsumerState<PaymentTypeScreen> createState() => _PaymentTypeScreenState();
}

class _PaymentTypeScreenState extends ConsumerState<PaymentTypeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _taxNumberController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _bicController = TextEditingController();
  final TextEditingController _accountHolderController = TextEditingController();


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(signUpNotifier).resetBankValidation();
      _clearBankControllers();
    });

    Utils.getToken();
  }


  void _clearBankControllers() {
    _bankNameController.clear();
    _taxNumberController.clear();
    _bicController.clear();
    _ibanController.clear();
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _taxNumberController.dispose();
    _bicController.dispose();
    _ibanController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }


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
          title: Strings.PAYMENT_TITLE,
          leading: CustomBackButton(),
        ).getAppBar(context),

        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(
                  left: Constant.CONTAINER_SIZE_20,
                  right: Constant.CONTAINER_SIZE_20,
                  bottom:
                  MediaQuery.of(context).viewInsets.bottom +
                      Constant.CONTAINER_SIZE_20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(theme, title: Strings.CARD_DETAILS),
                    _addCardButton(context, theme),
                    _orDivider(theme),
                    _sectionTitle(theme, title: Strings.ONLINE_PAYMENT_GATEWAY),
                    _paypalTile(theme),
                    SizedBox(height: Constant.SIZE_10),
                    _applePay(theme),
                    SizedBox(height: Constant.SIZE_10),
                    _googlePay(theme),
                    SizedBox(height: Constant.SIZE_10),
                    _orDivider(theme),
                    _sectionTitle(theme, title: 'Bank Details'),
                    _bankFields(theme, signupState),

                    SizedBox(height: Constant.CONTAINER_SIZE_40),

                    _bottomButtons(theme, context, signupState),
                  ],
                ),
              ),
            ),
            if (signupState.isLoading) Utils.showProgressBar(),
          ],
        ),
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

  Widget _bankFields(ThemeData theme, var signupState) {
    return Column(
      children: [
        _field(
          theme: theme,
          controller: _bankNameController,
          hint: Strings.BANK_NAME,
          error: signupState.bankNameError,
          onChanged: signupState.setBankName,
          inputFormatters: [
            FilteringTextInputFormatter.allow(Strings.text_validation),
            LengthLimitingTextInputFormatter(Constant.MAX_LINE_20),
          ],
        ),

        SizedBox(height: Constant.SIZE_10),

        _field(
          theme: theme,
          controller: _accountHolderController,
          hint:Strings.ACCOUNT_HOLDER_NAME,
          error: signupState.accountHolderError,
          onChanged: signupState.setAccountHolderName,
          inputFormatters: [
            FilteringTextInputFormatter.allow(Strings.text_validation),
            LengthLimitingTextInputFormatter(Constant.MAX_LINE_20),
          ],
        ),

        SizedBox(height: Constant.SIZE_10),

        _field(
          theme: theme,
          controller: _bicController,
          hint: Strings.BIC,
          error: signupState.bicError,
          onChanged: signupState.setBic,
          inputFormatters: [
            FilteringTextInputFormatter.allow(Strings.number_validation),
            LengthLimitingTextInputFormatter(Constant.MAX_LINE_11),
          ],
        ),

        SizedBox(height: Constant.SIZE_10),

        _field(
          theme: theme,
          controller: _ibanController,
          hint: Strings.IBAN,
          error: signupState.ibanError,
          onChanged: signupState.setIban,
          inputFormatters: [
            FilteringTextInputFormatter.allow(Strings.number_validation),
            LengthLimitingTextInputFormatter(Constant.MAX_LINE_34),
          ],
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
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
          cursorColor: Colors.white,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
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

  Widget _bottomButtons(
      ThemeData theme,
      BuildContext context,
      var signupState,
      ) {
    return Row(
      children: [
        if (widget.flow == PaymentFlow.signup)
          Expanded(
            child: OutlinedButton(
              onPressed:
                  () {
                    Utils.skipDialog(
                          context: context,
                      icon: Icons.warning_amber,
                      subTitle: Strings.SKIP_PAYMENT,
                      cancelButtonText: Strings.CANCEL,
                      yesButtonText: Strings.SKIP_CONTINUE,
                      onCancel: (){
                            Navigator.pop(context);
                      },
                      onYes: () {
                        Navigator.pop(context);

                        ref.read(signUpNotifier).resetBankValidation();
                        _clearBankControllers();

                        NavUtil.navigateWithReplacement(SubscriptionScreen());
                      },

                    );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Constant.gold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                ),
              ),
              child: Text(Strings.SKIP,
              style: TextStyle(
                color: Constant.gold
              ),),
            ),
          ),

        SizedBox(width: Constant.SIZE_15),
        Expanded(
          child: ElevatedButton(
            onPressed: signupState.isLoading
                ? null
                : () async {
              final isValid = signupState.validateBankForm();
              if (!isValid) return;

              if (widget.flow == PaymentFlow.signup) {
                signupState.updateBankDetails();
                NavUtil.navigateToPushScreen(context, SubscriptionScreen());
              } else {
                await _getNetworkDataVerify(signupState);
              }
              },
            style: ElevatedButton.styleFrom(
              backgroundColor: Constant.gold,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
              ),
            ),
            child: Text(
             Strings.VERIFY_CONTINUE,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> getJsonData() {
    final data = {
      "bankDetailsRequest": {
        "userId": Utils.userId,
        "bankName": _bankNameController.text,
        "bicNumber": _bicController.text,
        "accountHolderName": _accountHolderController.text,
        "iBanNumber": _ibanController.text,
      },
      "cardDetailsRequest": {
        "userId": Utils.userId,
        "cardHolderName": "",
        "cardNumber": "",
        "expiryDate": "",
        "cvv": "",
        "paymentGatewayId": "",
        "paymentGatewayName": "",
      },
      "paymentGetWayRequest": {
        "userId": Utils.userId,
        "paymentGatewayId": "",
        "paymentGatewayName": "",
      },
    };
    return data;
  }

  _getNetworkDataVerify(var registrationState) async {
    try {
      if (registrationState.isValid) {
        await ref.read(networkProvider.notifier).isNetworkAvailable().then((
            isNetworkAvailable,
            ) async {
          try {
            if (isNetworkAvailable) {
              registrationState.setIsLoading(true);
              registrationState.setContext(context);
              ref.read(createBankProvider(getJsonData()));
            } else {
              registrationState.setIsLoading(false);
              if (!mounted) return;
              showCustomSnackBar(
                context: context,
                message: Strings.NO_INTERNET_CONNECTION,
                color: Colors.red,
              );
            }
          } catch (e) {
            Utils.printLog('Error on button onPressed: $e');
            registrationState.setIsLoading(false);
          }
          if (!mounted) return;
          FocusScope.of(context).unfocus();
        });
      }
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      registrationState.setIsLoading(false);
    }
  }
}


