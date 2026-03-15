import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';

import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/profile_provider.dart';
import '../../utils/utility.dart';

class EditRestaurantNameDialog extends ConsumerStatefulWidget {
  final String name;

  const EditRestaurantNameDialog({super.key, required this.name});

  @override
  ConsumerState<EditRestaurantNameDialog> createState() =>
      _EditRestaurantNameDialogState();
}

class _EditRestaurantNameDialogState
    extends ConsumerState<EditRestaurantNameDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  File? imageFile;
  @override
  void initState() {
    super.initState();
    Utils.userId;
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
      return Strings.RESTAURANT_NAME_NOT_EMPTY;
    }

    final RegExp regex = RegExp(r'^[a-zA-Z0-9 ]+$');

    if (!regex.hasMatch(value.trim())) {
      return Strings.ONLY_LETTERS_NUMBERS;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileState = ref.watch(profileProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Constant.CONTAINER_SIZE_16,
            Constant.CONTAINER_SIZE_16,
            Constant.CONTAINER_SIZE_16,
            0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Utils.buildFloatingHeader(context),
                SizedBox(height: Constant.SIZE_08),
                Container(
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
                                Strings.EDIT_RESTAURANT_NAME,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontSize: Constant.LABEL_TEXT_SIZE_18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
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
                            color: Colors.white70,
                          ),
                          cursorColor: Colors.white70,
                          decoration: InputDecoration(
                            labelText: Strings.RESTAURANT_NAME1,
                            labelStyle: TextStyle(color: Colors.white70),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: Constant.CONTAINER_SIZE_16,
                              vertical: Constant.CONTAINER_SIZE_14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Constant.CONTAINER_SIZE_16,
                              ),
                              borderSide: BorderSide(color: Constant.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Constant.CONTAINER_SIZE_16,
                              ),
                              borderSide: BorderSide(color: Constant.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Constant.CONTAINER_SIZE_16,
                              ),
                              borderSide: BorderSide(color: Constant.grey),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Constant.CONTAINER_SIZE_16,
                              ),
                              borderSide: BorderSide(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Constant.CONTAINER_SIZE_24),

                        profileState.isSaving
                            ? const Center(child: CircularProgressIndicator())
                            : SizedBox(
                                width: double.infinity,
                                child: SubmitButton(
                                  onRightTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await _editNameNetworkCall(
                                        _nameController.text.trim(),
                                      );
                                    }
                                  },
                                  rightText: Strings.SAVE_CHANGES,
                                ),
                              ),
                      ],
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
    final data = {"userId": Utils.userId, "fullName": name};
    return data;
  }

  _editNameNetworkCall(String name) async {
    ref.read(profileProvider).setIsSaving(true);
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
