import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/auth/model/payment_type_model.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/notifier/login_notifier.dart';

import '../../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';

class AddCardDialog extends ConsumerStatefulWidget {
  final AuthState state;

  const AddCardDialog({super.key, required this.state});

  @override
  ConsumerState<AddCardDialog> createState() => _AddCardDialogState();
}

class _AddCardDialogState extends ConsumerState<AddCardDialog> {
  @override
  void initState() {
    _getData();
    super.initState();
  }

  final _cardHolderNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  _getData() {
    if (widget.state.cardDetails != null) {
      _cardHolderNameController.text =
          widget.state.cardDetails!.cardHolderName!;
      _cardNumberController.text = widget.state.cardDetails!.cardNumber!;
      _expiryDateController.text = widget.state.cardDetails!.expiryDate!;
      _cvvController.text = widget.state.cardDetails!.cvv!;
    }
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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
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
                      _cardField(
                        theme,
                        Strings.CARD_HOLDER_NAME,
                        _cardHolderNameController,
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]')),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return Strings.CARD_HOLDER_REQUIRED;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: Constant.SIZE_10),
                      _cardField(
                        theme,
                        Strings.CARD_NUMBER,
                        _cardNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CardNumberInputFormatter(),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return Strings.CARD_NO_REQ;
                          }
                          final digitsOnly = value.replaceAll(' ', '');
                          if (digitsOnly.length != 12) {
                            return Strings.CARD_NUMBER_12;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: Constant.SIZE_10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _cardField(
                              theme,
                              Strings.EXPIRATION_DATE,
                              _expiryDateController,
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(DateTime.now().year + 20),
                                );
                                if (date != null) {
                                  _expiryDateController.text =
                                      "${date.month.toString().padLeft(2, '0')}/${date.year}";
                                }
                              },
                            ),
                          ),
                          SizedBox(width: Constant.SIZE_10),
                          Expanded(
                            child: _cardField(
                              theme,
                              Strings.CVV,
                              _cvvController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return Strings.CVV_REQUIRED;
                                }
                                if (value.length != 3) {
                                  return Strings.THREE_DIGIT;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: Constant.CONTAINER_SIZE_20),
                      SizedBox(
                        width: double.infinity,
                        child: SubmitButton(
                          onRightTap: () {
                            if (_key.currentState!.validate()) {
                              final cardData = CardDetails(
                                cardHolderName: _cardHolderNameController.text,
                                cardNumber: _cardNumberController.text,
                                cvv: _cvvController.text,
                                expiryDate: _expiryDateController.text,
                              );
                              widget.state.setCardDetails(cardData);
                              Navigator.pop(context);
                            }
                          },
                          rightText: Strings.ADD_CARD_CONTINUE,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Utils.buildFloatingHeader(context),
          ],
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
                Strings.ADD_CARD_DETAILS,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Text(
                Strings.WE_ACCEPT,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cardField(
    ThemeData theme,
    String hint,
    TextEditingController controller, {
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    bool isReadOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      onTap: onTap,
      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
      cursorColor: Colors.white,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      inputFormatters: inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
        errorStyle: const TextStyle(color: Colors.redAccent),
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
          picker.DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            minTime: DateTime.now(),
            maxTime: DateTime(3000),
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
            validator: (value) => value!.isEmpty ? 'Please select date' : null,
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
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
