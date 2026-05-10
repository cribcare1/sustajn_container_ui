import 'package:sustajn_restaurant/auth/edit_dialogs/report_screen/get_all_container_list.dart';
import 'package:sustajn_restaurant/auth/edit_dialogs/report_screen/reports_screen.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';

import '../../../constants/imports_util.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/utility.dart';
import 'damaged_container_scan.dart';

class DamagedContainerReportDialog extends StatefulWidget {
  const DamagedContainerReportDialog({super.key});

  @override
  State<DamagedContainerReportDialog> createState() =>
      _DamagedContainerReportDialogState();
}

class _DamagedContainerReportDialogState
    extends State<DamagedContainerReportDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,bottom: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Utils.buildFloatingHeader(context),
            SizedBox(height: Constant.SIZE_08),
            _buildBottomSheet(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: constraints.maxHeight * 0.85),
          child: Container(
            margin: EdgeInsets.only(top: Constant.CONTAINER_SIZE_15),
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Constant.CONTAINER_SIZE_16),
                topRight: Radius.circular(Constant.CONTAINER_SIZE_16),
              ),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          Strings.REPORT_DAMAGED_CONTAINER,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: Constant.LABEL_TEXT_SIZE_18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: Constant.CONTAINER_SIZE_20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          readOnly: true,
                          onTap: () {
                            NavUtil.navigateToPushScreen(
                              context,
                              GetAllContainerListScreen(),
                            );
                          },
                          decoration: _inputDecoration(
                            hint: Strings.RESTAURANT,
                            prefixIcon: Icons.home_work_outlined,
                          ),
                        ),
                        SizedBox(height: Constant.CONTAINER_SIZE_16),
                        TextFormField(
                          readOnly: true,
                          onTap: () {
                            NavUtil.navigateToPushScreen(
                              context,
                              DamagedContainerScannerWidget(customer: "customer"),
                            );
                          },
                          decoration: _inputDecoration(
                            hint: Strings.CUSTOMER,
                            prefixIcon: Icons.perm_identity,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: Constant.CONTAINER_SIZE_12,
        horizontal: Constant.CONTAINER_SIZE_14,
      ),
      prefixIcon: Icon(prefixIcon, color: Constant.white),

      suffixIcon: Icon(Icons.keyboard_arrow_right_sharp, color: Constant.white),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
        borderSide: BorderSide(color: Constant.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
        borderSide: BorderSide(color: Constant.white, width: 1.5),
      ),
    );
  }
}
