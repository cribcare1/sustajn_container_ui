import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/utils/utility.dart';

import '../../constants/imports_util.dart';
import '../../constants/string_utils.dart';
import '../../provider/profile_provider.dart';

class ContactUsDialog extends ConsumerStatefulWidget{
  const ContactUsDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<ContactUsDialog> createState() =>
      _ContactUsDialogState();
}

class _ContactUsDialogState extends ConsumerState<ContactUsDialog> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileState = ref.watch(profileProvider);
    final profile = profileState.getProfileData?.data;
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  Expanded(
                    child: Text(
                      Strings.CONTACT_US,
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

              SizedBox(height: Constant.CONTAINER_SIZE_16),

              InkWell(
                onTap: () => Utils.sendEmail(profile!.emailId!),
                child: Row(
                  children: [
                    Icon(Icons.email,
                    size: Constant.CONTAINER_SIZE_18,
                    color: Colors.white,
                    ),
                    SizedBox(width: Constant.SIZE_10),
                    Expanded(
                      child: Text(
                        profile!.emailId!,
                        style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: Constant.CONTAINER_SIZE_14,
                      color: Colors.white70,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}