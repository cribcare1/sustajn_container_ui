import 'package:flutter/material.dart';
import '../../../constants/number_constants.dart';
import '../../utils/theme_utils.dart';

class AddCardDialog extends StatelessWidget {
  const AddCardDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
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
            _cardField(theme, 'Card Holder Name*'),
            SizedBox(height: Constant.SIZE_10),
            _cardField(theme, 'Card Number*'),
            SizedBox(height: Constant.SIZE_10),
            Row(
              children: [
                Expanded(child: _cardField(theme, 'Expiration Date')),
                SizedBox(width: Constant.SIZE_10),
                Expanded(child: _cardField(theme, 'CVV')),
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

  Widget _cardField(ThemeData theme, String hint) {
    return TextField(
      style: theme.textTheme.bodyLarge?.copyWith(
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
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
