import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/imports_util.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/profile_provider.dart';
import '../../utils/utils.dart';

class AddressOptionsDialog extends ConsumerStatefulWidget {
  final int userId;
  const AddressOptionsDialog({super.key,required this.userId});


  @override
  ConsumerState<AddressOptionsDialog> createState() => _AddressOptionsDialogState();
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
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
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
                },
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_12),

              _optionItem(
                theme: theme,
                icon: Icons.delete_forever,
                text: "Remove Address",
                onTap: () {
                  _getNetworkDataVerify(profileState);
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
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
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

  _getNetworkDataVerify(var registrationState) async {
    try {
        await ref.read(networkProvider.notifier).isNetworkAvailable().then((
            isNetworkAvailable,
            ) async {
          try {
            if (isNetworkAvailable) {
              registrationState.setIsLoading(true);
              ref.read(
                deleteAddressProvider({  "addressId": widget.userId
                }),
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