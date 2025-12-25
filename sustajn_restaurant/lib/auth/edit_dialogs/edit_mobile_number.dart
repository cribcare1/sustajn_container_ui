import 'package:flutter/material.dart';
import '../../constants/number_constants.dart';

class EditMobileNumberDialog extends StatefulWidget {
  const EditMobileNumberDialog({Key? key}) : super(key: key);

  @override
  State<EditMobileNumberDialog> createState() =>
      _EditMobileNumberDialogState();
}

class _EditMobileNumberDialogState extends State<EditMobileNumberDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    super.initState();

    final String mobileNumber = '980765432';

    _controller.text = mobileNumber;

    _controller.selection = TextSelection.collapsed(
      offset: mobileNumber.length,
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validateMobileNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your mobile number';
    }
    if (value.length != 10) {
      return 'Enter a valid 10-digit number';
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
            color: theme.scaffoldBackgroundColor,
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
                        'Edit Mobile Number',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: Constant.LABEL_TEXT_SIZE_18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
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
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_20),


                SizedBox(height: Constant.SIZE_08),

                TextFormField(
                  controller: _controller,
                  validator: _validateMobileNumber,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  cursorColor: Colors.white,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white
                  ),
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Constant.CONTAINER_SIZE_16,
                      vertical: Constant.CONTAINER_SIZE_14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                      borderSide: BorderSide(color: Constant.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                      borderSide:
                      BorderSide(color: Constant.grey),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                      borderSide:
                      BorderSide(color: theme.colorScheme.error),
                    ),
                  ),
                ),


                SizedBox(height: Constant.CONTAINER_SIZE_24),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context, _controller.text.trim());
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
}
