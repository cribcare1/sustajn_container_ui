import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/number_constants.dart';
import '../../utils/theme_utils.dart';

class AddCardDialog extends StatelessWidget {
  const AddCardDialog({super.key});

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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(context, theme),
            SizedBox(height: Constant.SIZE_15),
            _cardField(
                theme, 
                'Card Holder Name*',
              KeyboardType: TextInputType.name,
              maxLength: 26,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
            ),
            SizedBox(height: Constant.SIZE_10),
            _cardField(
                theme,
                'Card Number*',
              KeyboardType: TextInputType.number,
              maxLength: 16,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            SizedBox(height: Constant.SIZE_10),
            Row(
              children: [
                Expanded(child: _cardField(theme,
                    'Expiration Date',
                  KeyboardType: TextInputType.number,
                  maxLength: 5,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                    ExpiryDateFormatter(),
                  ]
                )),
                SizedBox(width: Constant.SIZE_10),
                Expanded(child: _cardField(
                    theme,
                    'CVV',
                  KeyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                )),
              ],
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.gold,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Add Card & Continue',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ),
          ],
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
              SizedBox(height: Constant.CONTAINER_SIZE_12,),
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
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _cardField(
      ThemeData theme, 
      String hint, {
  TextInputType KeyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
  int? maxLength,
  }) {
    return TextField(
      keyboardType: KeyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        counterText: '',
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.white
        ),
        filled: true,
        fillColor: Constant.grey.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          borderSide: BorderSide(color: Constant.grey.withOpacity(0.3)),
        ),
        enabledBorder: CustomTheme.roundedBorder(Constant.grey.withOpacity(0.3)),
        focusedBorder: CustomTheme.roundedBorder(Constant.grey.withOpacity(0.3)),
      ),
    );
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    var text = newValue.text.replaceAll('/', '');

    if (text.length >= 3) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

