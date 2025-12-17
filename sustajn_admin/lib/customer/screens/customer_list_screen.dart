import 'package:container_tracking/common_widgets/custom_app_bar.dart';
import 'package:container_tracking/constants/number_constants.dart';
import 'package:container_tracking/customer/customer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common_provider/network_provider.dart';
import '../../common_widgets/submit_clear_button.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import '../customer_provider.dart';
import 'customer_details_screen.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  bool isTabChange = true;
  List<String> statusList = ["Active Customer", "In Active Customer"];
  String? selectedStatus;
  List<String> subscriptionType = [
    "Monthly-Popular",
    "Monthly-Pay-Per-Use",
    "Yearly-Popular",
    "Yearly-Pay-Per-Use",
  ];
  String? selectedSubscriptionType;
@override
  void initState() {
  WidgetsBinding.instance.addPostFrameCallback((_){
    ref.read(customerNotifierProvider).setContext(context);
    _getNetworkData(ref.read(customerNotifierProvider));
  });
    super.initState();
  }


  Future<void> _refreshIndicator() async {
    _getNetworkData(ref.read(customerNotifierProvider));
  }
  @override
  Widget build(BuildContext context) {
    // double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    final customerState = ref.watch(customerNotifierProvider);
    final themeData = CustomTheme.getTheme(true);
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Customers",
          leading: const SizedBox.shrink(),
          action: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            IconButton(
              onPressed: () {
                isTabChange = true;
                _filterBottomSheet(context);
              },
              icon: Icon(Icons.filter_alt_outlined),
            ),
          ],
        ).getAppBar(context),
        body:customerState.isLoading
            ? Center(child: CircularProgressIndicator())
        //     :
        // customerState.error != ""
        //     ? Center(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text(
        //         customerState.error,
        //         style: themeData!.textTheme.titleMedium,
        //       ),
        //       ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: Colors.green
        //         ),
        //         onPressed: () {
        //           _refreshIndicator();
        //         },
        //         child: Padding(
        //           padding: EdgeInsets.all(Constant.SIZE_08),
        //           child: Text(
        //             "Retry",
        //             style: themeData.textTheme.titleMedium!.copyWith(
        //               color: Colors.white,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // )
            :(customerState.customerList.isEmpty)?Center(child: Text("No data"),): ListView.separated(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          itemCount: customerState.customerList.length,
          separatorBuilder: (_, __) =>
              SizedBox(height: Constant.CONTAINER_SIZE_10),

          itemBuilder: (context, index) {
            final user = customerState.customerList[index];

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CustomerDetailsScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: Constant.CONTAINER_SIZE_12,
                  horizontal: Constant.SIZE_008,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),

                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: Constant.SIZE_08),
                  child: Row(
                    children: [
                      user.profileImage == ""?
                           const CircleAvatar(
                              radius: 22,
                              backgroundColor: Color(0xffE6F7EC),
                              child: Icon(
                                Icons.person_outline,
                                color: Colors.green,
                              ),
                            )
                          : CircleAvatar(
                              radius: 22,
                        backgroundColor: Color(0xffE6F7EC),
                              child: Image.network(user.profileImage,
                                errorBuilder: (context,obj,s){
                                return Icon(
                                  Icons.person_outline,
                                  color: Colors.green,
                                );
                                },

                              ),
                            ),
                      SizedBox(width: Constant.SIZE_08),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            SizedBox(height: h * 0.005),

                            Wrap(
                              spacing: Constant.CONTAINER_SIZE_10,
                              runSpacing: Constant.SIZE_06,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                _buildStatusItem(
                                  Colors.orange,
                                  "Borrowed - ${user.borrowedCount}",
                                ),
                                _buildStatusItem(
                                  Colors.green,
                                  "Returned - ${user.returnedCount}",
                                ),
                                _buildStatusItem(
                                  Colors.red,
                                  "Pending - ${user.pendingCount}",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _statusDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildStatusItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _statusDot(color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
        ),
      ],
    );
  }

  void _filterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(Icons.close, size: 22),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                       Padding(
                        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Filters",
                            style: Theme.of(context).textTheme.titleLarge
                          ),
                        ),
                      ),

                      Expanded(
                        child: Row(
                          children: [
                            // Left Tabs
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _selectorTab(
                                    label: "Status",
                                    isSelected: isTabChange,
                                    onTap: () {
                                      setSheetState(() {
                                        isTabChange = true;
                                      });
                                    },
                                  ),
                                   SizedBox(height: Constant.SIZE_HEIGHT_20),
                                  _selectorTab(
                                    label: "Subscription Type",
                                    isSelected: !isTabChange,
                                    onTap: () {
                                      setSheetState(() {
                                        isTabChange = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const VerticalDivider(width: 20, thickness: 1),

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: isTabChange
                                    ? _buildStatusView(setSheetState)
                                    : _buildSubscriptionView(setSheetState),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child:SubmitClearButton(
                            onLeftTap: () {
                              selectedStatus = null;
                              selectedSubscriptionType = null;
                              Navigator.pop(context); },
                            onRightTap: () {  },),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
  Widget _buildStatusView(Function(void Function()) setSheetState) {
    return ListView.builder(
      itemCount: statusList.length,
      itemBuilder: (context, index) {
        final item = statusList[index];

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 1,
              child: Text(
                item,
                style: Theme.of(context).textTheme.titleMedium!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Checkbox(
              checkColor: Colors.white,
              activeColor: Theme.of(context).primaryColor,
              value: selectedStatus == item,
              onChanged: (value) {
                setSheetState(() {
                  selectedStatus = value == true ? item : null;
                });
              },
            ),
          ],
        );
      },
    );
  }
  Widget _buildSubscriptionView(Function(void Function()) setSheetState) {
    return ListView.builder(
      itemCount: subscriptionType.length,
      itemBuilder: (context, index) {
        final item = subscriptionType[index];

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                item,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Checkbox(
              checkColor: Colors.white,
              activeColor: Theme.of(context).primaryColor,
              value: selectedSubscriptionType == item,
              visualDensity: VisualDensity(vertical: 0, horizontal: 0),
              onChanged: (value) {
                setSheetState(() {
                  selectedSubscriptionType = value == true ? item : null;
                });
              },
            ),
          ],
        );
      },
    );
  }
  Widget _selectorTab({
    required String label,
    required bool isSelected,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected) Container(width: 80, height: 2, color: Colors.green),
        ],
      ),
    );
  }
  _getNetworkData(CustomerState customerState) async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) async {
        try {
          if (isNetworkAvailable) {
           ref.read( fetchCustomerProvider(true));
          } else {
            if (!mounted) return;
            showCustomSnackBar(
              context: context,
              message: Strings.NO_INTERNET_CONNECTION,
              color: Colors.red,
            );
          }
        } catch (e) {
          Utils.printLog('Error on button onPressed: $e');
        }
      });
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
    }
  }
}
