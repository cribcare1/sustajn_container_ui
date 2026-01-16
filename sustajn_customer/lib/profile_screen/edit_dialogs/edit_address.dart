import 'package:sustajn_customer/auth/screens/save_home_address.dart';

import '../../constants/imports_util.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/profile_model.dart';
import '../../utils/nav_utils.dart';
import '../../utils/utils.dart';

class AddressOptionsDialog extends StatelessWidget {
  final AddressResponses address;
  const AddressOptionsDialog({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
              NavUtil.navigateToPushScreen(context, HomeAddress(flow: AddressFlow.profile,
              existingAddress: address,));
              // navigate to edit address
            },
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_12),

          _optionItem(
            theme: theme,
            icon: Icons.delete_forever,
            text: "Remove Address",
            onTap: () {

            },
          ),
        ],
      ),
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
}