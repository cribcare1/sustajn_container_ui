import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_customer/auth/payment_type/payment_type_model.dart';
import 'package:sustajn_customer/common_widgets/submit_button.dart';

import '../../../constants/number_constants.dart';
import '../../models/get_profile_model.dart';
import '../../provider/signup_provider.dart';
import '../../utils/theme_utils.dart';

class AddCardDialog extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  final CardDetailsResponse? cardDetails;

  const AddCardDialog({super.key, this.onSuccess, this.cardDetails});

  @override
  ConsumerState<AddCardDialog> createState() => _AddCardDialogState();
}

class _AddCardDialogState extends ConsumerState<AddCardDialog> {
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cardHolder = TextEditingController();
  final TextEditingController _cardNumber = TextEditingController();
  final TextEditingController _cvv = TextEditingController();

  late String initialCardHolderName;
  late String initialCardNumber;
  late String initialCvv;
  late String initialExpirationDate;

  @override
  void initState() {
    super.initState();

    final card = widget.cardDetails;
    if (card != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(signUpNotifier).setContext(context);
        setState(() {
          _cardHolder.text = card.cardHolderName ?? "";
          _cardNumber.text = card.cardNumber ?? "";
          _expiryController.text = card.expiryDate ?? "";
        });

        final signupState = ref.read(signUpNotifier);
        signupState.setCardHolderName(card.cardHolderName ?? "");
        signupState.setCardNumber(card.cardNumber ?? "");
        signupState.setExpiryDate(card.expiryDate ?? "");
      });
    }
  }

  @override
  void dispose() {
    _expiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signupState = ref.watch(signUpNotifier);

    return SafeArea(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Container(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Constant.CONTAINER_SIZE_20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _header(context, theme),
              SizedBox(height: Constant.SIZE_15),
              _cardField(
                controller: _cardHolder,
                theme: theme,
                hint: 'Card Holder Name*',
                error: signupState.cardHolderError,
                onChanged: signupState.setCardHolderName,
                formatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                ],
              ),

              _cardField(
                controller: _cardNumber,
                theme: theme,
                hint: 'Card Number*',
                error: signupState.cardNumberError,
                onChanged: signupState.setCardNumber,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CardNumberInputFormatter(),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: getDatePicker(
                      context,
                      'Expiration Date',
                      _expiryController,
                      (date) {
                        signupState.setExpiryDate(
                          "${date.year}-${date.month}-${date.day}",
                        );
                      },
                      theme,
                    ),
                  ),

                  // SizedBox(width: Constant.SIZE_10),
                  // Expanded(
                  //   child: _cardField(
                  //     controller: _cvv,
                  //     theme: theme,
                  //     hint: 'CVV',
                  //     error: signupState.cvvError,
                  //     onChanged: signupState.setCVV,
                  //     formatters: [
                  //       FilteringTextInputFormatter.digitsOnly,
                  //       LengthLimitingTextInputFormatter(4),
                  //     ],
                  //   ),
                  // ),
                ],
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_20),
              SizedBox(
                width: double.infinity,
                child: SubmitButton(
                  onRightTap: () {
                    final isValid = signupState.validateCardForm();
                    print("++++++++++__________------");
                    if (!isValid) return;
                    print("=======");
                    final cardData = CardDetails(
                      cardHolderName: _cardHolder.text,
                      cardNumber: _cardNumber.text,
                      expiryDate: _expiryController.text,
                    );
                    signupState.setCardDetails(cardData);
                    signupState.updateCardDetails();
                    Navigator.pop(context);
                    widget.onSuccess?.call();
                  },
                  rightText: "Add Card & Continue",
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Card Details',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Text(
                'Credit, Debit, Visa and Mastercard',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _cardField({
    required ThemeData theme,
    required String hint,
    required Function(String) onChanged,
    required TextEditingController controller,
    String? error,
    List<TextInputFormatter>? formatters,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            onChanged: onChanged,
            inputFormatters: formatters,
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
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
      ),
    );
  }

  static Widget getDatePicker(
    BuildContext context,
    String labelText,
    TextEditingController controller,
    Function(DateTime) onDateSelected,
    ThemeData theme,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_15),
      child: GestureDetector(
        onTap: () {
          picker.DatePicker.showPicker(
            context,
            showTitleActions: true,
            pickerModel: CustomMonthPicker(
              currentTime: DateTime.now(),
              minTime: DateTime.now(),
              maxTime: DateTime(DateTime.now().year + 10, 12),
              locale: picker.LocaleType.en,
            ),
            theme: picker.DatePickerTheme(
              headerColor: Constant.gold,
              backgroundColor: theme.primaryColor,
              itemStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Constant.LABEL_TEXT_SIZE_18,
              ),
              cancelStyle: TextStyle(
                color: theme.primaryColor,
                fontSize: Constant.LABEL_TEXT_SIZE_16,
                fontWeight: FontWeight.w600,
              ),
              doneStyle: TextStyle(
                color: theme.primaryColor,
                fontSize: Constant.LABEL_TEXT_SIZE_16,
                fontWeight: FontWeight.w600,
              ),
            ),
            onConfirm: (date) {
              controller.text =
                  "${date.month.toString().padLeft(2, '0')}/${date.year}";

              onDateSelected(date);
            },
          );
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: labelText,
              filled: true,
              fillColor: Constant.grey.withOpacity(.1),
              hintStyle: const TextStyle(color: Colors.white),
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
            validator: (value) => value!.isEmpty ? 'Please select date' : null,
          ),
        ),
      ),
    );
  }
}

class CustomMonthPicker extends picker.DatePickerModel {
  CustomMonthPicker({
    DateTime? currentTime,
    DateTime? minTime,
    DateTime? maxTime,
    picker.LocaleType locale = picker.LocaleType.en,
  }) : super(
         currentTime: currentTime,
         minTime: minTime,
         maxTime: maxTime,
         locale: locale,
       );

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.length > 16) return oldValue;
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
