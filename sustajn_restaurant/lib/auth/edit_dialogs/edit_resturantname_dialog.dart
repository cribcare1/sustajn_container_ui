import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/profile_provider.dart';
import '../../utils/utility.dart';

class EditRestaurantNameDialog extends ConsumerStatefulWidget {
  final String name;

  const EditRestaurantNameDialog({required this.name, Key? key});

  @override
  ConsumerState<EditRestaurantNameDialog> createState() =>
      _EditRestaurantNameDialogState();
}

class _EditRestaurantNameDialogState extends ConsumerState<EditRestaurantNameDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  File? imageFile;

  @override
  void initState() {
    super.initState();
    // Utils.getToken();
    Utils.userId;
    // final String restaurantName = 'Marina Sky Dine';

    _nameController.text = widget.name;

    _nameController.selection = TextSelection.collapsed(
      offset: widget.name.length,
    );
  }


  @override
  void dispose() {
    _nameController.dispose();
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

                /// HEADER
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Edit Restaurant Name',
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
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_20),


                SizedBox(height: Constant.SIZE_08),
                TextFormField(
                  controller: _nameController,
                  validator: _validateName,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70
                  ),
                  cursorColor: Colors.white70,
                  decoration: InputDecoration(
                    labelText: 'Restaurant Name',
                    labelStyle: TextStyle(color: Colors.white70),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Constant.CONTAINER_SIZE_16,
                      vertical: Constant.CONTAINER_SIZE_14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                      borderSide: BorderSide(color: Constant.grey)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                      borderSide: BorderSide(color:Constant.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                      borderSide:
                      BorderSide(color: Constant.grey),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_16),
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
                    onPressed: () async{
                      if (_formKey.currentState!.validate()) {
                        await _editNameNetworkCall(
                        _nameController.text.trim(),
                        );
                        if (mounted) {
                          Navigator.pop(context, _nameController.text.trim());
                        }

                        // Navigator.pop(context, _nameController.text.trim());
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

  Map<String, dynamic> getJsonData(String name) {
    final data = {
      "userId": Utils.userId,
      "fullName": name
    };
    return data;
  }

  _editNameNetworkCall(String name) async {
    Utils.printLog('edit restaurant name Network call');

    final isNetworkAvailable = await ref
        .read(networkProvider.notifier)
        .isNetworkAvailable();

    if (!isNetworkAvailable) {
      Utils.showToast(Strings.NO_INTERNET_CONNECTION);
      return;
    }
    ref.read(
      profileUpdateProvider({
        NetworkUrls.UPDATE_PROFILE: NetworkUrls.UPDATE_PROFILE,
        Strings.USER_DATA: getJsonData(name),
      }),
    );
  }
}
