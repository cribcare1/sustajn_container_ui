import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/screens/save_home_address.dart';
import '../../constants/imports_util.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/get_profile_model.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/profile_provider.dart';
import '../../utils/nav_utils.dart';
import '../../utils/utils.dart';

class AddressOptionsDialog extends ConsumerStatefulWidget {
  final AddressResponses address;

  const AddressOptionsDialog({super.key, required this.address});

  @override
  ConsumerState<AddressOptionsDialog> createState() =>
      _AddressOptionsDialogState();
}

class _AddressOptionsDialogState extends ConsumerState<AddressOptionsDialog> {
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
          decoration: BoxDecoration(
            color: const Color(0xFF0D402C),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Address Options",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_18),

              _optionItem(
                theme: theme,
                icon: Icons.edit_outlined,
                text: "Edit Address",
                onTap: () {
                  Navigator.pop(context);
                  NavUtil.navigateToPushScreen(
                    context,
                    HomeAddress(
                      flow: AddressFlow.profile,
                      existingAddress: widget.address,
                    ),
                  );
                  // navigate to edit address
                },
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_12),

              _optionItem(
                theme: theme,
                icon: Icons.delete_forever,
                text: "Remove Address",
                onTap: () async {
                  Navigator.pop(context);
                  _deleteAddress(profileState, widget.address.id ?? 0);
                  // Utils.displayDialog(
                  //   context: context,
                  //   icon: Icons.warning,
                  //   title: "Delete Address",
                  //   subTitle: "This address will be permanently removed from your saved list.You can't undo this action",
                  //   cancelButtonText: "No",
                  //   yesButtonText: "Delete",
                  //   onCancel: () {
                  //     Navigator.pop(context);
                  //   },
                  //   onYes: () async {
                  //     Navigator.pop(context);
                  //     _deleteAddress(profileState, widget.address.id ?? 0);
                  //   },
                  // );
                },
              ),
            ],
          ),
        ),

        if (profileState.isLoading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _optionItem({
    required ThemeData theme,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),

      child: Container(
        height: Constant.CONTAINER_SIZE_55,
        padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          border: Border.all(color: Colors.white24),
        ),

        child: Row(
          children: [
            Icon(icon, color: Colors.white),

            SizedBox(width: Constant.CONTAINER_SIZE_12),

            Expanded(
              child: Text(
                text,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }

  _deleteAddress(var registrationState, int addressId) async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) async {
        try {
          if (isNetworkAvailable) {
            registrationState.setIsLoading(true);
            await ref.read(
              deleteAddressProvider({"addressId": addressId}).future,
            );

            ref.read(profileProvider).clearProfileList();
            await ref.read(
              getProfileProvider('${NetworkUrls.GET_PROFILE}${Utils.userId}').future,
            );
          } else {
            registrationState.setIsLoading(false);
            if (!mounted) return;
            showCustomSnackBar(
              context: context,
              message: Strings.NO_INTERNET_CONNECTION,
              color: Colors.red,
            );
          }
        } catch (e) {
          Utils.printLog('Error on button onPressed: $e');
          registrationState.setIsLoading(false);
        }
        if (!mounted) return;
        FocusScope.of(context).unfocus();
      });
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      registrationState.setIsLoading(false);
    }
  }
}
