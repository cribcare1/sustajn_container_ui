import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/auth/model/payment_type_model.dart';
import 'package:sustajn_restaurant/common_widgets/card_widget.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/notifier/login_notifier.dart';
import 'package:sustajn_restaurant/provider/login_provider.dart';
import 'package:sustajn_restaurant/utils/utility.dart';

import '../../../constants/number_constants.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../constants/string_utils.dart';
import '../../utils/global_utils.dart';
import '../../utils/theme_utils.dart';
import '../screens/subscription_screen.dart';
import '../widgets/add_card_buttom_sheet.dart';

class PaymentTypeScreen extends ConsumerStatefulWidget {
  const PaymentTypeScreen({super.key});

  @override
  ConsumerState<PaymentTypeScreen> createState() => _PaymentTypeScreenState();
}

class _PaymentTypeScreenState extends ConsumerState<PaymentTypeScreen> {
  final TextEditingController bankNameController = TextEditingController();

  final TextEditingController accountNumberController = TextEditingController();

  final TextEditingController taxController = TextEditingController();

  final TextEditingController ibanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: CustomAppBar(
          title: '',
          leading: CustomBackButton(),
        ).getAppBar(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              _sectionTitle(theme,title: "Card Details"),
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
              _sectionTitle(theme, title: 'Online Payment Gateway'),
              // _paypalTile(theme),
              paymentGatewayTile(context: context, theme: theme,
                notifier: authState,
                title: 'PayPal', asset: 'assets/images/paypal.webp',),
              _orDivider(theme),
              _sectionTitle(theme, title: 'Bank Details'),
              _bankFields(theme),
              SizedBox(height: Constant.CONTAINER_SIZE_16),
              SizedBox(
                width: double.infinity,
                child: SubmitButton(
                  onRightTap: () {
                    final bankData = BankDetailsModel(
                      bankName: bankNameController.text,
                      accountNo: accountNumberController.text,
                      taxNumber: taxController.text,
                      ibanNumber: ibanController.text,
                    );
                    authState.setBankDetails(bankData);
                    Utils.navigateToPushScreen(context, SubscriptionScreen());
                  },
                  rightText: "Verify and Continue",
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
  Widget paymentGatewayTile({
    required BuildContext context,
    required ThemeData theme,
    required AuthState notifier,
    required String title,
    required String asset,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) => AddGatewayDialog(
            title: title,
            asset: asset,
            notifier: notifier,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E4636),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Image.asset(asset, height: 30),
            const SizedBox(width: 12),
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
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        notifier.gateway!.id,
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

  Widget _bankFields(ThemeData theme) {
    return Column(
      children: [
        _inputField(
          theme,
          hint: 'Bank Name',
          controller: bankNameController,
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: Constant.SIZE_10),
        _inputField(
          theme,
          hint: 'Account Number',
          controller: accountNumberController,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: Constant.SIZE_10),
        _inputField(
          theme,
          hint: 'TAX',
          controller: taxController,
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: Constant.SIZE_10),
        _inputField(
          theme,
          hint: 'IBAN',
          controller: ibanController,
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }

  Widget _inputField(
    ThemeData theme, {
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
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
    );
  }

  Widget _bottomButtons(ThemeData theme, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Utils.navigateToPushScreen(context, SubscriptionScreen());
            },

            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Constant.gold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
              ),
            ),
            child: Text(
              'Skip',
              style: theme.textTheme.labelLarge?.copyWith(color: Constant.gold),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF123D2C),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Link ${widget.title} Account",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                validator: (v) =>
                v == null || v.isEmpty ? 'Required' : null,
                decoration: InputDecoration(
                  hintText: 'Enter your ${widget.title} ID',
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.notifier.setGateway(
                        PaymentGatewayModel(
                          name: widget.title,
                          id: _controller.text,
                          asset: widget.asset,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Add & Continue',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
