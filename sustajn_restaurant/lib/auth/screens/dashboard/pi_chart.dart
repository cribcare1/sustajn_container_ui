import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../lease_receive/lease_receive_notifier.dart';
import '../../../lease_receive/lease_receive_provider.dart';
import '../../../lease_receive/screens/lease_scan_screen.dart';
import '../../../network_provider/network_provider.dart';
import '../../../utils/nav_utils.dart';
import '../../../utils/utility.dart';
import 'option_file.dart';

class FilterPopupWidget extends ConsumerStatefulWidget {
  const FilterPopupWidget({super.key});

  @override
  ConsumerState<FilterPopupWidget> createState() => _FilterPopupWidgetState();
}

class _FilterPopupWidgetState extends ConsumerState<FilterPopupWidget> {
  String? selectedType;
  String? selectedValue;
  List<String> valueList = ["Customer Return", "Restaurant Damage"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: CircleAvatar(
                  radius: Constant.CONTAINER_SIZE_16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.clear, color: Colors.black, size: Constant.CONTAINER_SIZE_18),
                ),
              ),
            ),
            SizedBox(height: Constant.SIZE_08),
            Container(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xff0C794E), Color(0xff0F3727)],
                ),
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
              ),
              child: Column(
                children: [
                  Text(
                    'Scan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Constant.CONTAINER_SIZE_18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_12),
                  Row(
                    children: [
                      Expanded(
                        child: OptionTile(
                          title: 'Lease',
                          icon: Icons.north_east,
                          isSelected: selectedType == 'LEASE',
                          onTap: () {
                            setState(() {
                              selectedType = 'LEASE';
                              getContainerList();
                              Navigator.pop(context);
                              NavUtil.navigateToPushScreen(
                                context,
                                LeaseScanScreen(
                                  type: selectedType ?? "",
                                  damage: selectedValue,
                                ),
                              );
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OptionTile(
                          title: 'Receive',
                          icon: Icons.south_west,
                          isSelected: selectedType == 'RECEIVE',
                          onTap: () {
                            setState(() {
                              selectedType = 'RECEIVE';
                              Navigator.pop(context);
                              NavUtil.navigateToPushScreen(
                                context,
                                LeaseScanScreen(
                                  type: selectedType ?? "",
                                  damage: selectedValue,
                                ),
                              );
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_12),

                 /* SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedType == null
                          ? null
                          : () {
                          Navigator.pop(context);
                          NavUtil.navigateToPushScreen(
                            context,
                            LeaseScanScreen(
                              type: selectedType ?? "",
                              damage: selectedValue,
                            ),
                          );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedType == null
                            ? Colors.grey.shade300
                            : Theme.of(context).secondaryHeaderColor,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                          side: BorderSide(color: Colors.white),
                        ),
                      ),
                      child: Text(
                        'Confirm',
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                          color: selectedType == null
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  getContainerList() async {
    final leaseState = ref.read(leaseReceiveNotifier);
    try {

      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) async {
        try {
          if (isNetworkAvailable) {
            leaseState.setContext(context);
            leaseState.setLoading(true);
            ref.read(
              containerListProvider(Utils.userId.toString()),
            );
          } else {
            leaseState.setLoading(false);
            if (!mounted) return;
            showCustomSnackBar(
              context: context,
              message: Strings.NO_INTERNET_CONNECTION,
              color: Colors.white,
            );
          }
        } catch (e) {
          Utils.printLog('Error on button onPressed: $e');
          leaseState.setLoading(false);
        }
        if (!mounted) return;
        FocusScope.of(context).unfocus();
      });

    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      leaseState.setLoading(false);
    }
  }

}
