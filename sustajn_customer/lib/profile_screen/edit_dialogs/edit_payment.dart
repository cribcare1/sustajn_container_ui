import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_customer/common_widgets/custom_app_bar.dart';
import 'package:sustajn_customer/common_widgets/custom_back_button.dart';

import '../../../constants/number_constants.dart';
import '../../auth/payment_type/add_card_dialog.dart';
import '../../auth/payment_type/link_payment_sheet.dart';
import '../../constants/network_urls.dart';
import '../../constants/string_utils.dart';
import '../../models/get_profile_model.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/profile_provider.dart';
import '../../provider/signup_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utils.dart';
enum ProfilePaymentType {
  bank,
  card,
  gateway,
}

class EditPaymentScreen extends ConsumerStatefulWidget {
  final BankDetailsResponse? bankDetails;
  final CardDetailsResponse? cardDetails;
  final PaymentGetWayResponse? paymentGateway;

  const EditPaymentScreen({super.key, this.bankDetails, this.cardDetails, this.paymentGateway});

  @override
  ConsumerState<EditPaymentScreen> createState() => _PaymentTypeScreenState();
}

class _PaymentTypeScreenState extends ConsumerState<EditPaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountHolderController = TextEditingController();
  final TextEditingController _bicController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  ProfilePaymentType? _selectedType;

  late String _initialBankName;
  late String _initialAccountHolder;
  late String _initialBic;
  late String _initialIban;


  @override
  void initState() {
    super.initState();

    final bank = widget.bankDetails;

    _initialBankName = bank?.bankName ?? '';
    _initialAccountHolder = bank?.accountHolderName ?? '';
    _initialBic = bank?.bicNumber ?? '';
    _initialIban = bank?.iBanNumber ?? '';

    _bankNameController.text = _initialBankName;
    _accountHolderController.text = _initialAccountHolder;
    _bicController.text = _initialBic;
    _ibanController.text = _initialIban;
  }
  bool _isDataChanged() {
    return _bankNameController.text.trim() != _initialBankName ||
        _accountHolderController.text.trim() != _initialAccountHolder ||
        _bicController.text.trim() != _initialBic ||
        _ibanController.text.trim() != _initialIban;
  }



  void _clearBankFields() {
    _bankNameController.clear();
    _accountHolderController.clear();
    _bicController.clear();
    _ibanController.clear();

    ref.read(signUpNotifier).resetBankValidation();
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
                    _addCardButton(context, theme, widget.cardDetails),
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

                    _bankFields(theme, signupState),

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

              if (shouldClear) {
                _clearBankFields();
              }
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

  Widget _addCardButton(BuildContext context, ThemeData theme, CardDetailsResponse? cardDetails) {
    return InkWell(
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) {
            if (cardDetails != null) {
              final signupState = ref.read(signUpNotifier);
              signupState.setCardHolderName(cardDetails.cardHolderName ?? "");
              signupState.setCardNumber(cardDetails.cardNumber ?? "");
              signupState.setExpiryDate(cardDetails.expiryDate ?? "");
            }

            return AddCardDialog(cardDetails: cardDetails);
          },

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
    return InkWell(
      onTap: () {
        _showLinkBottomSheet(
            title: "Link Pay Pal Account",
            hint: "Enter your PayPal ID",
            gatewayName: "PAYPAL"
        );
      },
      child: _gatewayTile(theme, 'assets/icons/paypal.png', 'PayPal'),
    );
  }


  Widget _applePay(ThemeData theme) {
    return InkWell(
      onTap: () {
        _showLinkBottomSheet(
            title: "Link Apple Pay Account",
            hint: "Enter your Apple Pay ID",
            gatewayName: "GOOGLE_PAY"
        );
      },
      child: _gatewayTile(theme, 'assets/icons/apple_pay.png', 'Apple Pay'),
    );
  }


  Widget _googlePay(ThemeData theme) {
    return InkWell(
      onTap: () {
        _showLinkBottomSheet(
            title: "Link Google Pay Account",
            hint: "Enter your Google Pay ID",
            gatewayName: 'APPLE_PAY'
        );
      },
      child: _gatewayTile(theme, 'assets/icons/google_pay.png', 'Google Pay'),
    );
  }


  Widget _gatewayTile(ThemeData theme, String icon, String title) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        border: Border.all(color: Constant.grey.withOpacity(0.3)),
        color: Constant.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
      ),
      child: Row(
        children: [
          Image.asset(icon),
          SizedBox(width: Constant.CONTAINER_SIZE_12),
          Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontSize: Constant.LABEL_TEXT_SIZE_16,
            ),
          ),
        ],
      ),
    );
  }

  void _showLinkBottomSheet({
    required String title,
    required String hint,
    required String gatewayName,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LinkPaymentBottomSheet(
        title: title,
        hint: hint,
        onSubmit: () {
        },
        gatewayName: gatewayName,
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
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
            LengthLimitingTextInputFormatter(20),
          ],
        ),

        SizedBox(height: Constant.SIZE_10),

        _field(
          theme: theme,
          controller: _accountHolderController,
          hint: 'Account Holder Name',
          error: signupState.accountHolderError,
          onChanged: signupState.setAccountHolderName,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            LengthLimitingTextInputFormatter(30),
          ],
        ),

        SizedBox(height: Constant.SIZE_10),

        _field(
          theme: theme,
          controller: _bicController,
          hint: 'BIC',
          error: signupState.bicError,
          onChanged: signupState.setBic,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
            LengthLimitingTextInputFormatter(11),
          ],
        ),

        SizedBox(height: Constant.SIZE_10),

        _field(
          theme: theme,
          controller: _ibanController,
          hint: 'IBAN',
          error: signupState.ibanError,
          onChanged: signupState.setIban,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
            LengthLimitingTextInputFormatter(23), // UAE
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
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          textCapitalization: TextCapitalization.characters,
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


  Widget _verifyButton(ThemeData theme, BuildContext context, var signupState) {
    return Padding(
      padding: EdgeInsets.only(top: Constant.CONTAINER_SIZE_20),
      child: SizedBox(
        width: double.infinity,
        height: Constant.CONTAINER_SIZE_50,
        child: ElevatedButton(
          onPressed: signupState.isLoading
              ? null
              : () async {

            if (!_isDataChanged()) {
              return;
            }

            final isValid = signupState.validateBankForm();
            if (!isValid) return;

            await _updateBankNetwork(signupState);

          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Constant.gold,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
            ),
          ),
          child: signupState.isLoading
              ? Utils.showProgressBar()
              : Text(
            'Verify',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.primaryColor,
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

  Map<String, dynamic> getJsonData() {
    final data = {
      "bankDetailsRequest": {
        "id": widget.bankDetails?.id,
        "bankName": _bankNameController.text,
        "bicNumber": _bicController.text,
        "accountHolderName": _accountHolderController.text,
        "iBanNumber": _ibanController.text,
      },
      "cardDetailsRequest": {
        "id": widget.cardDetails?.id,
        "cardHolderName": "",
        "cardNumber": "",
        "expiryDate": "",
        "cvv": "",
        "paymentGatewayId": "",
        "paymentGatewayName": "",
      },
      "paymentGetWayRequest": {
        "id": widget.paymentGateway?.id,
        "paymentGatewayId": "",
        "paymentGatewayName": "",
      },
    };
    return data;
  }

  _updateBankNetwork(var registrationState) async {
    try {
      if (registrationState.isValid) {
        await ref.read(networkProvider.notifier).isNetworkAvailable().then((
            isNetworkAvailable,
            ) async {
          try {
            if (isNetworkAvailable) {
              registrationState.setIsLoading(true);
              registrationState.setContext(context);
              await ref.read(updateBankProvider(getJsonData()).future);
              ref.read(profileProvider).clearProfileList();
              await ref.read(
                getProfileProvider('${NetworkUrls.GET_PROFILE}${Utils.userId}').future,
              );
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
