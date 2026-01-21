import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/profile_provider.dart';
import '../../utils/utils.dart';
enum ContactView {
  display,
  edit,
  add,
}
class EditMobileNumberDialog extends ConsumerStatefulWidget {
  final String mobileNumber;
  final int userId;

  const EditMobileNumberDialog({
    super.key,
    required this.mobileNumber,
    required this.userId,
  });

  @override
  ConsumerState<EditMobileNumberDialog> createState() =>
      _EditMobileNumberDialogState();
}

class _EditMobileNumberDialogState
    extends ConsumerState<EditMobileNumberDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  ContactView view = ContactView.display;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.mobileNumber;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validate(String? v) {
    if (v == null || v.isEmpty) return "Enter mobile number";
    if (v.length != 10) return "Enter valid 10 digit number";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileState = ref.watch(profileProvider);

    String title = switch (view) {
      ContactView.display => "Contact Number",
      ContactView.edit => "Edit Contact Number",
      ContactView.add => "Add Contact Number",
    };

    return SafeArea(
      top: false,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Constant.CONTAINER_SIZE_16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  Expanded(
                    child: Text(title,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: Colors.white)),
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

              if (view == ContactView.display) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Primary Number",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: Constant.SIZE_04),

                          Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                color: Colors.white70,
                                size: Constant.CONTAINER_SIZE_18,
                              ),
                              SizedBox(width: Constant.SIZE_08),
                              Text(
                                "+91 ${widget.mobileNumber}",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: Constant.CONTAINER_SIZE_18,
                      ),
                      onPressed: () {
                        setState(() => view = ContactView.edit);
                      },
                    ),
                  ],
                ),



                SizedBox(height: Constant.CONTAINER_SIZE_20),

                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    setState(() => view = ContactView.add);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, color: Constant.gold),
                      SizedBox(width: Constant.SIZE_08),
                      Text(
                        "Add Secondary Number",
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Constant.gold),
                      )
                    ],
                  ),
                ),
              ],

              if (view != ContactView.display) ...[
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _controller,
                    validator: _validate,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: view == ContactView.edit
                          ? "Primary Number"
                          : "Secondary Number",
                      labelStyle: const TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Constant.grey),
                        borderRadius:
                        BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Constant.gold),
                        borderRadius:
                        BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_24),

                profileState.isLoading
                    ? Utils.showProgressBar()
                    : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.gold,
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      await _editMobileNetwork(
                          _controller.text, profileState);
                    },
                    child: Text(
                      view == ContactView.edit
                          ? "Save Changes"
                          : "Add",
                      style: theme.textTheme.labelLarge
                          ?.copyWith(color: Colors.black),
                    ),
                  ),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }


  Map<String, dynamic> getJsonData(String mobileNo) {
    return {"userId": Utils.userId, "phoneNumber": mobileNo};
  }

  Future<bool> _editMobileNetwork(String mobile, var profileState) async {
    try {
      final isNetworkAvailable =
      await ref.read(networkProvider.notifier).isNetworkAvailable();

      if (!isNetworkAvailable) {
        Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        return false;
      }

      profileState.setContext(context);
      profileState.setIsLoading(true);

      final params = Utils.multipartParams(
        NetworkUrls.UPDATE_PROFILE,
        getJsonData(mobile),
        Strings.USER_DATA,
      );

      await ref.read(profileUpdateProvider(params).future);

      Navigator.pop(context);
      ref.read(profileProvider).clearProfileList();
      ref.read(getProfileProvider('${NetworkUrls.GET_PROFILE}${widget.userId}'));

      return true;
    } finally {
      profileState.setIsLoading(false);
    }
  }
}
