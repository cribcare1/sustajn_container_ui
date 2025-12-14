import 'package:flutter/material.dart';
import '../../constants/number_constants.dart';

class EditBankDetailsDialog extends StatefulWidget {
  const EditBankDetailsDialog({Key? key}) : super(key: key);

  @override
  State<EditBankDetailsDialog> createState() =>
      _EditBankDetailsDialogState();
}

class _EditBankDetailsDialogState extends State<EditBankDetailsDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _bankNameController;
  late TextEditingController _accountNumberController;
  late TextEditingController _taxNumberController;



  @override
  void initState() {
    super.initState();

    _bankNameController = TextEditingController(text: 'HDFC Bank');
    _accountNumberController = TextEditingController(text: '123456789012');
    _taxNumberController = TextEditingController(text: 'ABCDE1234F');
  }


  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _taxNumberController.dispose();
    super.dispose();
  }


  String? _validateBankName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter bank name';
    }
    return null;
  }

  String? _validateAccountNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter account number';
    }
    if (value.length < 9) {
      return 'Enter a valid account number';
    }
    return null;
  }

  String? _validateTaxNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter tax number';
    }
    if (value.length < 10) {
      return 'Enter a valid tax number';
    }
    return null;
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
          decoration: BoxDecoration(
            color: theme.dialogBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Constant.CONTAINER_SIZE_16),
              topRight: Radius.circular(Constant.CONTAINER_SIZE_16),
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Edit Bank Information ',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: Constant.LABEL_TEXT_SIZE_18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_20),
                      child: Icon(
                        Icons.close,
                        size: Constant.CONTAINER_SIZE_20,
                        color: theme.iconTheme.color,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_20),



                _buildTextField(
                  context,
                  'Bank Name',
                  TextInputType.text,
                  _bankNameController,
                  _validateBankName,
                ),

                SizedBox(height: Constant.SIZE_10),

                _buildTextField(
                  context,
                  'Account Number',
                  TextInputType.number,
                  _accountNumberController,
                  _validateAccountNumber,
                ),

                SizedBox(height: Constant.SIZE_10),

                _buildTextField(
                  context,
                  'Tax Number',
                  TextInputType.text,
                  _taxNumberController,
                  _validateTaxNumber,
                ),


                SizedBox(height: Constant.CONTAINER_SIZE_24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFC8B531),
                      padding: EdgeInsets.symmetric(
                        vertical: Constant.CONTAINER_SIZE_14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w600,
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

  Widget _buildTextField(
      BuildContext context,
      String label,
      TextInputType keyboard,
      TextEditingController controller,
      String? Function(String?) validator,
      ) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboard,
      textInputAction: TextInputAction.next,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(
          horizontal: Constant.CONTAINER_SIZE_16,
          vertical: Constant.CONTAINER_SIZE_14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
      ),
    );
  }

}