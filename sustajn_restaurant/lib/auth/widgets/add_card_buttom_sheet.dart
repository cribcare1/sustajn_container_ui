import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/auth/model/payment_type_model.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/notifier/login_notifier.dart';

import '../../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';

class AddCardDialog extends ConsumerStatefulWidget {
  final AuthState state;

  const AddCardDialog({super.key, required this.state});

  @override
  ConsumerState<AddCardDialog> createState() => _AddCardDialogState();
}

class _AddCardDialogState extends ConsumerState<AddCardDialog> {
  late TextEditingController _cardHolderNameController;
  late TextEditingController _cardNumberController;
  late TextEditingController _expiryDateController;
  late TextEditingController _cvvController;

  final Map<String, String?> _fieldErrors = {
    'cardHolderName': null,
    'cardNumber': null,
    'cvv': null,
  };

  final Map<String, bool> _fieldTouched = {
    'cardHolderName': false,
    'cardNumber': false,
    'cvv': false,
  };

  bool _formSubmitted = false;

  @override
  void initState() {
    _cardHolderNameController = TextEditingController();
    _cardNumberController = TextEditingController();
    _expiryDateController = TextEditingController();
    _cvvController = TextEditingController();

    _getData();

    _cardHolderNameController.addListener(() {
      _validateFieldRealTime(
        'cardHolderName',
        _cardHolderNameController.text,
        _validateCardHolderName,
      );
    });

    _cardNumberController.addListener(() {
      _validateFieldRealTime(
        'cardNumber',
        _cardNumberController.text,
        _validateCardNumber,
      );
    });


    _cvvController.addListener(() {
      _validateFieldRealTime(
        'cvv',
        _cvvController.text,
        _validateCVV,
      );
    });

    super.initState();
  }

  void _getData() {
    if (widget.state.cardDetails != null) {
      _cardHolderNameController.text =
      widget.state.cardDetails!.cardHolderName!;
      _cardNumberController.text = widget.state.cardDetails!.cardNumber!;
      _expiryDateController.text = widget.state.cardDetails!.expiryDate!;
      _cvvController.text = widget.state.cardDetails!.cvv!;
    }
  }


  String? _validateCardHolderName(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.CARD_HOLDER_REQUIRED;
    }

    final RegExp nameRegex = RegExp(Strings.NAME_REGX);
    if (!nameRegex.hasMatch(value.trim())) {
      return Strings.CARD_HOLER_VALID;
    }

    if (value.trim().length < 3) {
      return Strings.CARD_HOLDER_3;
    }

    if (value.length > 50) {
      return Strings.CARD_HOLDER_NOT_EXCEED;
    }

    return null;
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.CARD_NUMBER_REQUIRED;
    }

    final cleanedNumber = value.replaceAll(' ', '');

    if (!RegExp(r'^\d+$').hasMatch(cleanedNumber)) {
      return Strings.CARD_NUMBER_CONTAIN;
    }

    if (cleanedNumber.length != 12) {
      return Strings.CARD_NUMBER_12;
    }

    if (!_luhnCheck(cleanedNumber)) {
      return Strings.INVALID_CARD_NUMBER;
    }

    return null;
  }


  String? _validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.CVV_REQUIRED;
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return Strings.CVV_CONTAIN;
    }

    if (value.length != 3) {
      return Strings.CVV_3;
    }

    return null;
  }

  bool _luhnCheck(String cardNumber) {
    int sum = 0;
    int isEven = 0;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (isEven == 1) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      isEven ^= 1;
    }

    return sum % 10 == 0;
  }

  void _validateFieldRealTime(
      String fieldName,
      String value,
      String? Function(String?) validator,
      ) {
    if (!_fieldTouched[fieldName]! && !_formSubmitted) {
      return;
    }

    final error = validator(value);

    if (_fieldErrors[fieldName] != error) {
      setState(() {
        _fieldTouched[fieldName] = true;
        _fieldErrors[fieldName] = error;
      });
    }
  }

  bool _isFormValid() {
    return _fieldErrors.values.every((error) => error == null) &&
        _cardHolderNameController.text.isNotEmpty &&
        _cardNumberController.text.isNotEmpty &&
        _expiryDateController.text.isNotEmpty &&
        _cvvController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _cardHolderNameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  final _key = GlobalKey<FormState>();

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
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Constant.CONTAINER_SIZE_20),
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _header(context, theme),
                  SizedBox(height: Constant.SIZE_15),

                  _buildCardFieldWithRealTimeValidation(
                    theme,
                    hint: Strings.CARD_HOLDER_NAME,
                    controller: _cardHolderNameController,
                    fieldName: 'cardHolderName',
                    validator: _validateCardHolderName,
                    keyboardType: TextInputType.name,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                    ],
                  ),
                  SizedBox(height: Constant.SIZE_10),

                  _buildCardFieldWithRealTimeValidation(
                    theme,
                    hint: Strings.CARD_NUMBER,
                    controller: _cardNumberController,
                    fieldName: 'cardNumber',
                    validator: _validateCardNumber,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CardNumberInputFormatter(),
                    ],
                  ),
                  SizedBox(height: Constant.SIZE_10),

                  Row(
                    children: [
                      Expanded(
                        child: getDatePicker(
                          context,
                          Strings.EXPIRATION_DATE,
                          _expiryDateController,
                              (date) {
                            _expiryDateController.text =
                            "${date.month.toString().padLeft(2, '0')}/${date.year}";
                          },
                          theme,
                        ),
                      ),
                      SizedBox(width: Constant.SIZE_10),
                      Expanded(
                        child: _buildCardFieldWithRealTimeValidation(
                          theme,
                          hint: Strings.CVV,
                          controller: _cvvController,
                          fieldName: 'cvv',
                          validator: _validateCVV,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_20),

                  SizedBox(
                    width: double.infinity,
                    child: SubmitButton(
                      onRightTap: () {
                        setState(() {
                          _formSubmitted = true;
                          _fieldErrors['cardHolderName'] =
                              _validateCardHolderName(
                                _cardHolderNameController.text,
                              );
                          _fieldErrors['cardNumber'] = _validateCardNumber(
                            _cardNumberController.text,
                          );
                          _fieldErrors['cvv'] = _validateCVV(
                            _cvvController.text,
                          );
                        });

                        if (!_isFormValid()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Please fix all errors before continuing',
                              ),
                              backgroundColor: Colors.grey,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                          return;
                        }

                        final cardData = CardDetails(
                          cardHolderName:
                          _cardHolderNameController.text.trim(),
                          cardNumber: _cardNumberController.text
                              .replaceAll(' ', ''),
                          cvv: _cvvController.text,
                          expiryDate: _expiryDateController.text,
                        );
                        widget.state.setCardDetails(cardData);
                        Navigator.pop(context);
                      },
                      rightText: Strings.ADD_CARD_CONTINUE,
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
                'We accept Credit, Debit, Visa and Mastercard',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildCardFieldWithRealTimeValidation(
      ThemeData theme, {
        required String hint,
        required TextEditingController controller,
        required String fieldName,
        required String? Function(String?) validator,
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,
      }) {
    final error = _fieldErrors[fieldName];

    return Padding(
      padding: EdgeInsets.only(bottom: Constant.SIZE_08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
            ),
            cursorColor: Colors.white,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: (_) => null,
            onChanged: (value) {
              if (!_fieldTouched[fieldName]!) {
                setState(() {
                  _fieldTouched[fieldName] = true;
                });
              }
              _validateFieldRealTime(fieldName, value, validator);
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
                borderSide: BorderSide(
                  color: Constant.grey.withOpacity(0.3),
                ),
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
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
          ),
          if (error != null)
            Padding(
              padding: EdgeInsets.only(
                top: Constant.SIZE_06,
                left: Constant.CONTAINER_SIZE_12,
              ),
              child: Text(
                error,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
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
      padding:  EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_15),
      child: GestureDetector(
        onTap: () {
          picker.DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            minTime: DateTime.now(),
            maxTime: DateTime(DateTime.now().year + 20),
            theme: picker.DatePickerTheme(
              headerColor: Constant.gold,
              backgroundColor: theme.primaryColor,
              itemStyle:  TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Constant.LABEL_TEXT_SIZE_18,
              ),
              cancelStyle:  TextStyle(
                color: theme.primaryColor,
                fontSize: Constant.LABEL_TEXT_SIZE_16,
                fontWeight: FontWeight.w600,
              ),

              doneStyle:  TextStyle(
                color: theme.primaryColor,
                fontSize: Constant.LABEL_TEXT_SIZE_16,
                fontWeight: FontWeight.w600,
              ),
            ),
            onConfirm: (date) {
              final value = "${date.year}-${date.month}-${date.day}";
              controller.text = value;
              onDateSelected(date);
            },
            currentTime: DateTime.now(),
            locale: picker.LocaleType.en,
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
            validator: (value) =>
            value!.isEmpty ? 'Please select date' : null,
          ),
        ),
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text.replaceAll(' ', '');

    if (text.length > 12) return oldValue;

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
        offset: buffer.length,
      ),
    );
  }
}