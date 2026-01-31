
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/profile_provider.dart';
import '../../utils/utils.dart';

class EditUserNameDialog extends ConsumerStatefulWidget {
  final String userName;
  final String dob;
  final int userId;
  const EditUserNameDialog({Key? key, required this.userName, required this.dob,required this.userId}) : super(key: key);

  @override
  ConsumerState<EditUserNameDialog> createState() =>
      _EditUserNameDialogState();
}

class _EditUserNameDialogState extends ConsumerState<EditUserNameDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _dobCtrl = TextEditingController();
  DateTime? selectedDob;

  File? imageFile;


  @override
  void initState() {
    super.initState();
    Utils.userId;

    _controller.text = widget.userName;
    _dobCtrl.text = widget.dob;

    _controller.selection = TextSelection.collapsed(
      offset: widget.userName.length,
    );
  }



  @override
  void dispose() {
    _controller.dispose();
    _dobCtrl.dispose();

    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'User name cannot be empty';
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
    final profileState = ref.watch(profileProvider);

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
                      'Edit Name',
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
                controller: _controller,
                validator: _validateName,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70
                ),
                cursorColor: Colors.white70,
                decoration: InputDecoration(
                  labelText: Strings.USER_FULL_NAME,
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

              SizedBox(height: Constant.CONTAINER_SIZE_14),

              TextFormField(
                controller: _dobCtrl,
                readOnly: true,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                cursorColor: Colors.white70,
                decoration: InputDecoration(
                  labelText: Strings.DOB,
                  labelStyle: const TextStyle(color: Colors.white70),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Constant.CONTAINER_SIZE_16,
                    vertical: Constant.CONTAINER_SIZE_14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                    borderSide: BorderSide(color: Constant.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                    borderSide: BorderSide(color: Constant.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                    borderSide: BorderSide(color: Constant.grey),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_month, color: Colors.white70),
                    onPressed: () async {
                      final picked = await Utils.pickDob(context, initialDate: selectedDob);

                      if (picked != null) {
                        setState(() {
                          selectedDob = picked;
                          _dobCtrl.text = Utils.formatDob(picked);
                        });
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_24),

              profileState.isLoading
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Constant.gold,
                ),
              )
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    Navigator.pop(context);

                    await Future.delayed(const Duration(milliseconds: 200));

                    Utils.displayDialog(
                      context: context,
                      icon: Icons.warning,
                      title: "Confirm Update",
                      subTitle: "Are you sure you want to update your userName?",
                      cancelButtonText: "No",
                      yesButtonText: "Yes",
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onYes: () async {
                        Navigator.pop(context);
                        await _editNameNetwork(_controller.text, profileState);
                      },
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC8B531),
                    padding: EdgeInsets.symmetric(
                      vertical: Constant.CONTAINER_SIZE_14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                    ),
                  ),
                  child: Text(
                    Strings.SAVE_CHANGES,
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
      "fullName": name,
      "dateOfBirth": selectedDob != null
          ? Utils.formatDob(selectedDob!)
          : widget.dob,
    };
    return data;
  }

  Future<bool> _editNameNetwork(String name, var profileState) async {
    try {
      final isNetworkAvailable =
      await ref.read(networkProvider.notifier).isNetworkAvailable();

      if (!isNetworkAvailable) {
        Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        return false;
      }
      profileState.setIsLoading(true);

      if (profileState.profileList.isNotEmpty) {
        profileState.profileList.first.fullName = name;
      }

      final params = Utils.multipartParams(
        NetworkUrls.UPDATE_PROFILE,
        getJsonData(name),
        Strings.USER_DATA,
      );
      await ref.read(profileUpdateProvider(params).future);
      ref.read(profileProvider).clearProfileList();
      await ref.read(
        getProfileProvider('${NetworkUrls.GET_PROFILE}${widget.userId}').future,
      );
      return true;
    } catch (e) {
      Utils.printLog('Error in edit name: $e');
      return false;
    } finally {
      profileState.setIsLoading(false);
    }
  }
}
