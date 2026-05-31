import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/auth/widgets/no_data_custom_text.dart';
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
import 'demage_container_bottom_sheet.dart';

class DamageContainerListScreen extends ConsumerStatefulWidget {
  final String? damage;
  final String customerId;

  const DamageContainerListScreen({
    super.key,
    this.damage,
    required this.customerId,
  });

  @override
  ConsumerState<DamageContainerListScreen> createState() =>
      _DamageContainerListScreenState();
}

class _DamageContainerListScreenState
    extends ConsumerState<DamageContainerListScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider).setContext(context);
      _getContainerList(
        ref.read(profileProvider),
        customerId: widget.customerId,
      );
    });

    super.initState();
  }

  _getContainerList(
    ProfileState leasState, {
    required String customerId,
  }) async {
    try {
      leasState.setLoading(true);
      Future.delayed(Duration(seconds: 2));
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) async {
        try {
          if (isNetworkAvailable) {
            ref.read(damageContainerList(customerId));
          } else {
            leasState.setLoading(false);
            if (!mounted) return;
            showCustomSnackBar(
              context: context,
              message: Strings.NO_INTERNET_CONNECTION,
              color: Colors.red,
            );
          }
        } catch (e) {
          Utils.printLog('Error on button onPressed: $e');
          leasState.setLoading(false);
        }
        if (!mounted) return;
        FocusScope.of(context).unfocus();
      });
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      leasState.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leaseNotifier = ref.watch(profileProvider);
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Container List",
          leading: CustomBackButton(),
        ).getAppBar(context),
        body: leaseNotifier.isDamageLoading
            ? const Center(child: CircularProgressIndicator())
            : leaseNotifier.damageContainerList.length==0
            ? Center(
                child: NoDataFoundCustomText(text: "There are no containers available for this user.")
              )
            : ListView.separated(
              padding: EdgeInsets.all(
                 Constant.CONTAINER_SIZE_16,
              ),
              itemCount: leaseNotifier.damageContainerList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    _showReferPartnerDialogue(context, leaseNotifier.damageContainerList[index]);
                  },
                  child: _containerCard(
                    item: leaseNotifier.damageContainerList[index],
                  ),
                );
              },
              separatorBuilder: (context, index) =>
                  SizedBox(height: Constant.CONTAINER_SIZE_10),
            ),
      ),
    );
  }

  Widget _containerCard({required ProductOrderListResponseList item}) {
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
              "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${item.productImageUrl}",
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
                        item.productName,
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
                  item.productUniqueId,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                Text(
                  "${item.containerQuantity}ml",
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
                item.quantity.toString(),
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

  void _showReferPartnerDialogue(BuildContext context, ProductOrderListResponseList item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DamageContainerBottomSheet(item: item, customerId: widget.customerId,),
    );
  }

}
