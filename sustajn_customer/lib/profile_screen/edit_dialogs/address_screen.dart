import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_customer/auth/screens/save_home_address.dart';
import 'package:sustajn_customer/common_widgets/custom_app_bar.dart';
import 'package:sustajn_customer/common_widgets/custom_back_button.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/get_profile_model.dart';
import '../../provider/profile_provider.dart';
import '../../utils/nav_utils.dart';
import '../../utils/utils.dart';
import 'edit_address.dart';

class AddressScreen extends ConsumerStatefulWidget {
  AddressScreen({super.key});

  @override
  ConsumerState<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileState = ref.watch(profileProvider);

    final addressList = profileState.profileList.isNotEmpty
        ? profileState.profileList.first.addressResponses ?? []
        : [];

    return SafeArea(
      bottom: true,top: false,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,

        appBar: CustomAppBar(
          title: Strings.ADDRESS,
          leading: CustomBackButton(),
        ).getAppBar(context),

        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: addressList.length,
                      itemBuilder: (context, index) {
                        return _addressCard(context, theme, addressList[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),

            if (profileState.isLoading)
             Utils.showProgressBar()
          ],
        ),


        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
            child: SizedBox(
              width: double.infinity,
              height: Constant.CONTAINER_SIZE_50,
              child: ElevatedButton(
                onPressed: () {
                  NavUtil.navigateToPushScreen(
                    context,
                    HomeAddress(flow: AddressFlow.profile),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.gold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Constant.CONTAINER_SIZE_30,
                    ),
                  ),
                ),
                child: Text(
                  Strings.ADD_NEW_ADDRESS,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _addressCard(
    BuildContext context,
    ThemeData theme,
    AddressResponses data,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_16),
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: Constant.grey.withOpacity(0.12),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
        border: Border.all(color: Colors.white24, width: 0.4),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.home,
            color: Colors.white,
            size: Constant.CONTAINER_SIZE_22,
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.addressType ?? "",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: Constant.SIZE_06),

                Text(
                  "${data.flatDoorHouseDetails ?? ""} "
                  "${data.areaStreetCityBlockDetails ?? ""}\n"
                  " ${data.poBoxOrPostalCode ?? ""}",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_10),

          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => AddressOptionsDialog(address: data),
              );
            },
            child: Icon(Icons.more_vert_outlined, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
