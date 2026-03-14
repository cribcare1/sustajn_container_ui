import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widgets/submit_button.dart';
import '../../../constants/imports_util.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/string_utils.dart';
import '../../../network_provider/network_provider.dart';
import '../../../provider/profile_provider.dart';
import '../../../utils/nav_utils.dart';
import '../../../utils/utility.dart';
import 'edit_mobile_number.dart';

class SecondaryMobileNumberDialog extends ConsumerStatefulWidget {
  final String primaryMobileNumber;
  final String secondaryMobileNumber;

  const SecondaryMobileNumberDialog({
    super.key,
    required this.secondaryMobileNumber,
    required this.primaryMobileNumber,
  });

  @override
  ConsumerState<SecondaryMobileNumberDialog> createState() =>
      _SecondaryMobileNumberDialogState();
}

class _SecondaryMobileNumberDialogState
    extends ConsumerState<SecondaryMobileNumberDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _secondaryController = TextEditingController();

  bool showSecondaryField = false;

  @override
  void initState() {
    Utils.userId;
    super.initState();
  }

  @override
  void dispose() {
    _secondaryController.dispose();
    super.dispose();
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) return 'Enter mobile number';
    if (value.length != 10) return 'Enter valid 10-digit number';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,bottom: true,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Utils.buildFloatingHeader(context),
              SizedBox(height: Constant.SIZE_08),
              Container(
                padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Constant.CONTAINER_SIZE_16),
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
                              Strings.MOBILE_NUMBER,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: Constant.CONTAINER_SIZE_24),

                      Text(
                        Strings.PRIMARY_NO,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: Constant.SIZE_05),
                      Row(
                        children: [
                          Icon(
                            Icons.call,
                            color: Colors.white,
                            size: Constant.CONTAINER_SIZE_18,
                          ),
                          SizedBox(width: Constant.SIZE_08),
                          Expanded(
                            child: Text(
                              "+91 ${widget.primaryMobileNumber}",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              NavUtil.popScreen(context, 1);

                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => EditMobileNumberDialog(
                                  primaryMobileNumber: widget.primaryMobileNumber,
                                  secondaryMobileNumber:
                                      widget.secondaryMobileNumber,
                                  editType: MobileEditType.primary,
                                ),
                              );
                            },
                            child: Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                              size: Constant.CONTAINER_SIZE_18,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: Constant.CONTAINER_SIZE_25),
                      if (widget.secondaryMobileNumber.isNotEmpty) ...[
                        Text(
                          Strings.SECONDARY_NO,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: Constant.SIZE_05),
                        Row(
                          children: [
                            Icon(
                              Icons.call,
                              color: Colors.white,
                              size: Constant.CONTAINER_SIZE_18,
                            ),
                            SizedBox(width: Constant.SIZE_08),
                            Expanded(
                              child: Text(
                                "+91 ${widget.secondaryMobileNumber}",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                NavUtil.popScreen(context, 1);

                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => EditMobileNumberDialog(
                                    primaryMobileNumber:
                                        widget.primaryMobileNumber,
                                    secondaryMobileNumber:
                                        widget.secondaryMobileNumber,
                                    editType: MobileEditType.secondary,
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                                size: Constant.CONTAINER_SIZE_18,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        if (!showSecondaryField)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() => showSecondaryField = true);
                                },
                                child: Text(
                                  Strings.ADD_SECONDARY_NO,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Constant.gold,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        Visibility(
                          visible: showSecondaryField,
                          child: Column(
                            children: [
                              SizedBox(height: Constant.CONTAINER_SIZE_16),
                              TextFormField(
                                controller: _secondaryController,
                                keyboardType: TextInputType.number,
                                validator: _validateMobile,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: Strings.SECONDARY_NO,
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: Constant.CONTAINER_SIZE_28),

                      SizedBox(
                        width: double.infinity,
                        child: SubmitButton(
                          onRightTap: () {
                            if (showSecondaryField &&
                                !_formKey.currentState!.validate())
                              return;
                            _addSecondaryNoNetworkCall();
                            Utils.showToast(
                              '${Strings.SECONDARY_NO} ${Strings.SUCC_MSG}',
                            );
                            Navigator.pop(
                              context,
                              _secondaryController.text.trim(),
                            );

                            NavUtil.popScreen(context, 1);
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
    );
  }

  Map<String, dynamic> getJsonData() {
    final data = {
      "userId": Utils.userId,
      "secondaryNumber": _secondaryController.text,
    };
    return data;
  }

  _addSecondaryNoNetworkCall() async {
    Utils.printLog('edit mobile number Network call');

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
        Strings.USER_DATA: getJsonData(),
      }),
    );
  }
}
