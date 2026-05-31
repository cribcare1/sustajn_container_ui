import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/auth/screens/map_screen.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/constants/number_constants.dart';
import 'package:sustajn_restaurant/constants/string_utils.dart';
import 'package:sustajn_restaurant/models/get_profile_data.dart';
import 'package:sustajn_restaurant/network_provider/network_provider.dart';
import 'package:sustajn_restaurant/provider/profile_provider.dart';
import 'package:sustajn_restaurant/utils/utility.dart';

class EditAddressDialog extends ConsumerStatefulWidget {
  final AddressResponses? selectedAddress;

  const EditAddressDialog({super.key, required this.selectedAddress});

  @override
  ConsumerState<EditAddressDialog> createState() => _EditAddressDialogState();
}

class _EditAddressDialogState extends ConsumerState<EditAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();

  double lat = 0.0;
  double long = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider).setContext(context);
    });
    if (widget.selectedAddress != null) {
      _addressController.text =
          widget.selectedAddress!.areaStreetCityBlockDetails ?? '';
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your address';
    }
    if (value.trim().length < 5) {
      return 'Address must be at least 5 characters';
    }
    if (value.trim().length > 250) {
      return 'Address is too long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final address = widget.selectedAddress;
    final profileState = ref.watch(profileProvider);
    return SafeArea(
      top: false,
      bottom: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: CircleAvatar(
                  radius: Constant.CONTAINER_SIZE_16,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.clear,
                    color: Colors.black,
                    size: Constant.CONTAINER_SIZE_18,
                  ),
                ),
              ),
            ),
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
                  mainAxisSize: MainAxisSize.min, // Important
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: Constant.SIZE_04,
                        width: Constant.CONTAINER_SIZE_40,
                        margin: EdgeInsets.only(
                          bottom: Constant.CONTAINER_SIZE_16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_10,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      Strings.EDIT_ADDRESS,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: Constant.LABEL_TEXT_SIZE_18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_20),
                    TextFormField(
                      controller: _addressController,
                      validator: _validateAddress,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      cursorColor: Colors.white,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: Strings.ADDRESS,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MapScreen(profile: "profile"),
                              ),
                            ).then((value) {
                              if (value != null) {
                                setState(() {
                                  _addressController.text = value['address'];
                                  lat = value['lat'];
                                  long = value['lng'];
                                });
                              }
                            });
                          },
                          icon: Icon(
                            Icons.map,
                            color: theme.secondaryHeaderColor,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: Constant.CONTAINER_SIZE_16,
                          vertical: Constant.CONTAINER_SIZE_14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_12,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_12,
                          ),
                          borderSide: BorderSide(color: Constant.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_12,
                          ),
                          borderSide: BorderSide(color: Constant.grey),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_12,
                          ),
                          borderSide: BorderSide(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: Constant.CONTAINER_SIZE_24),
                    SizedBox(
                      width: double.infinity,
                      child: profileState.isAddressSaving
                          ? Center(child: CircularProgressIndicator())
                          : SubmitButton(
                              onRightTap: () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                if (address == null) {
                                  Utils.showToast('Address data not available');
                                  return;
                                }
                                if (address.id == null ||
                                    address.addressType == null ||
                                    address.flatDoorHouseDetails == null ||
                                    address.poBoxOrPostalCode == null) {
                                  Utils.showToast('Fill address details');
                                  return;
                                }
                                _editAddressNetworkCall(
                                  address.id.toString(),
                                  address.addressType!,
                                  address.flatDoorHouseDetails!,
                                  _addressController.text.trim(),
                                  address.poBoxOrPostalCode!,
                                );
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
    );
  }

  Map<String, dynamic> getJsonData(
    String addressId,
    String addType,
    String houseDtls,
    String cityDtls,
    String pin,
  ) {
    return {
      "addressId": addressId,
      "addressType": addType,
      "flatDoorHouseDetails": houseDtls,
      "areaStreetCityBlockDetails": cityDtls,
      "poBoxOrPostalCode": pin,
    };
  }

  _editAddressNetworkCall(
    String addressId,
    String addType,
    String houseDtls,
    String cityDtls,
    String pin,
  ) async {
    Utils.printLog('Update Address Network call');
    final profileState = ref.read(profileProvider);
    profileState.setAddressSaving(true);
    await ref.read(networkProvider.notifier).isNetworkAvailable().then((value) {
      if (value) {
        final jsonData = getJsonData(
          addressId,
          addType,
          houseDtls,
          cityDtls,
          pin,
        );
        ref.read(addressUpdateProvider(jsonData).future);
      } else {
        Utils.showToast(Strings.NO_INTERNET_CONNECTION);
      }
    });
  }
}
