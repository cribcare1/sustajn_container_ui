import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/auth/edit_dialogs/report_screen/restaurant_damage_contaner_sheet.dart';
import 'package:sustajn_restaurant/common_widgets/card_widget.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/constants/network_urls.dart';
import 'package:sustajn_restaurant/constants/number_constants.dart';
import 'package:sustajn_restaurant/lease_receive/model/container_return_list_model.dart';
import 'package:sustajn_restaurant/network_provider/network_provider.dart';
import 'package:sustajn_restaurant/notifier/profile_notifier.dart';
import 'package:sustajn_restaurant/provider/profile_provider.dart';
import 'package:sustajn_restaurant/utils/utility.dart';

import '../../../constants/string_utils.dart';
import '../../../lease_receive/lease_receive_notifier.dart';
import '../../../lease_receive/lease_receive_provider.dart';
import '../../../lease_receive/model/container_list_model.dart';
import '../../widgets/no_data_custom_text.dart';
import 'demage_container_bottom_sheet.dart';

class GetAllContainerListScreen extends ConsumerStatefulWidget {
  const GetAllContainerListScreen({
    super.key,
  });

  @override
  ConsumerState<GetAllContainerListScreen> createState() =>
      _GetAllContainerListScreenState();
}

class _GetAllContainerListScreenState
    extends ConsumerState<GetAllContainerListScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leaseReceiveNotifier).setContext(context);
      _getContainerList();
    });

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leaseState = ref.watch(leaseReceiveNotifier);
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Container List",
          leading: CustomBackButton(),
        ).getAppBar(context),
        body:leaseState.isLoading?Center(child: CircularProgressIndicator()): leaseState.containersDetailsList.length>0
            ? ListView.separated(
          padding: EdgeInsets.all(
            Constant.CONTAINER_SIZE_16,
          ),
          itemCount: leaseState.containersDetailsList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                _showReferPartnerDialogue(context, leaseState.containersDetailsList[index]);
              },
              child: _containerCard(
                item: leaseState.containersDetailsList[index],
              ),
            );
          },
          separatorBuilder: (context, index) =>
              SizedBox(height: Constant.CONTAINER_SIZE_10),
        ):Center(
            child: NoDataFoundCustomText(
              text: Strings.NO_CONTAINERS_AVAILABLE,
            )
        ),
      ),
    );
  }

  Widget _containerCard({required ContainerDetails item}) {
    return GlassSummaryCard(
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(6),
            child: Image.network(
              "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${item.containerImageUrl}",
              errorBuilder: (context, obj, stack) {
                return Image.asset("assets/images/no_image_container.png");
              },
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.containerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.containerUniqueId,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                Text(
                  "${item.capacity}ml",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.quantityAvailable.toString(),
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReferPartnerDialogue(BuildContext context, ContainerDetails item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RestaurantDamageContainerBottomSheet(item: item,),
    );
  }

  _getContainerList() async {
    final leaseState = ref.read(leaseReceiveNotifier);
    try {
      Utils.printLog("getcontainer list called");
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) async {
        try {
          if (isNetworkAvailable) {
            leaseState.setContext(context);
            leaseState.setLoading(true);
            ref.read(containerListProvider(Utils.userId!));
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
