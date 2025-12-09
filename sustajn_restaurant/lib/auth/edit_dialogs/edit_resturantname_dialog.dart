import 'package:flutter/material.dart';
import '../../constants/number_constants.dart';

class EditRestaurantNameDialog extends StatefulWidget {
  const EditRestaurantNameDialog({Key? key}) : super(key: key);

  @override
  State<EditRestaurantNameDialog> createState() =>
      _EditRestaurantNameDialogState();
}

class _EditRestaurantNameDialogState extends State<EditRestaurantNameDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    super.initState();

    final String restaurantName = 'Marina Sky Dine';

    _controller.text = restaurantName;

    _controller.selection = TextSelection.collapsed(
      offset: restaurantName.length,
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Restaurant name cannot be empty';
    }

    final RegExp regex = RegExp(r'^[a-zA-Z0-9 ]+$');

    if (!regex.hasMatch(value.trim())) {
      return 'Only letters, numbers and spaces allowed';
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

                /// HEADER
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Edit Restaurant Name',
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


                SizedBox(height: Constant.SIZE_08),
                TextFormField(
                  controller: _controller,
                  validator: _validateName,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    labelText: 'Restaurant Name',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
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
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                      borderSide:
                      BorderSide(color: theme.colorScheme.primary),
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
