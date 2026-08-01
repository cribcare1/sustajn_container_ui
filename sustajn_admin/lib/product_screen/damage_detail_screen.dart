import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../common_provider/network_provider.dart';
import '../common_widgets/custom_app_bar.dart';
import '../common_widgets/custom_back_button.dart';
import '../constants/network_urls.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../provider/order_provider.dart';
import '../utils/utility.dart';
import 'models/damage_data.dart';

enum DamageTab { user, partner }

final damageTabProvider = StateProvider<DamageTab>((ref) => DamageTab.user);

class DamagedDetailsScreen extends ConsumerStatefulWidget {
  final ProductsList product;

  const DamagedDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<DamagedDetailsScreen> createState() => _DamagedScreenState();
}

class _DamagedScreenState extends ConsumerState<DamagedDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _getDamageListNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(damageTabProvider);
    final orderState = ref.watch(orderProvider);
    final damagedData = orderState.getDamagedContainerData;

    return Scaffold(
      backgroundColor: Constant.PrimaryColor,

      appBar: CustomAppBar(
        title: Strings.DAMAGED,
        leading: CustomBackButton(onTap: () => Navigator.pop(context)),
      ).getAppBar(context),

      body: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
              decoration: BoxDecoration(
                color: Constant.PrimaryColor,
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_18),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  Container(
                    width: Constant.CONTAINER_SIZE_60,
                    height: Constant.CONTAINER_SIZE_60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.05),
                      borderRadius: BorderRadius.circular(Constant.SIZE_08),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(Constant.SIZE_08),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Constant.SIZE_08),
                        child:
                            widget.product.productImageUrl != null &&
                                widget.product.productImageUrl!.isNotEmpty
                            ? Image.network(
                                "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${widget.product.productImageUrl}",
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return Image.asset(Strings.CUP_IMG);
                                },
                              )
                            : Image.asset(Strings.CUP_IMG, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  SizedBox(width: Constant.CONTAINER_SIZE_12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.productName ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Constant.CONTAINER_SIZE_18,
                          ),
                        ),
                        SizedBox(height: Constant.SIZE_04),
                        Text(
                          widget.product.productUniqueId ?? "",
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: Constant.SIZE_02),
                        Text(
                          "${widget.product.capacity ?? 0} ml",
                          style: TextStyle(color: Colors.white38),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "10",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Constant.CONTAINER_SIZE_22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_18),

            Container(
              height: Constant.CONTAINER_SIZE_45,
              decoration: BoxDecoration(
                color: Constant.green4,
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_30),
              ),
              child: Row(
                children: [
                  _segment(
                    title: "User",
                    selected: tab == DamageTab.user,
                    onTap: () {
                      ref.read(damageTabProvider.notifier).state =
                          DamageTab.user;
                    },
                  ),
                  _segment(
                    title: "Partner",
                    selected: tab == DamageTab.partner,
                    onTap: () {
                      ref.read(damageTabProvider.notifier).state =
                          DamageTab.partner;
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_16),

            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: tab == DamageTab.user
                    ? "Search by User ID"
                    : "Search by Partner Name",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                suffixIcon: const Icon(
                  Icons.filter_list,
                  color: Colors.white54,
                ),
                filled: true,
                fillColor: Constant.green4,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    Constant.CONTAINER_SIZE_30,
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_20),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: tab == DamageTab.user
                    ? UserUI(data: damagedData?.data ?? [])
                    : const _PartnerUI(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _segment({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.all(Constant.SIZE_04),
          decoration: BoxDecoration(
            color: selected ? Colors.white24 : Colors.transparent,
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_25),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: selected ? Colors.amber : Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
  _getDamageListNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final url = '${NetworkUrls.DAMAGED_CONTAINER}';
          ref.read(getDamagedOrderProvider(url));
        } else {
          orderState.setIsLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error in visitor button onPressed: $e');
    }
  }
}

class UserUI extends StatelessWidget {
  final List<DamagedList> data;

  const UserUI({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text("No Data Found", style: TextStyle(color: Colors.white)),
      );
    }

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, monthIndex) {
        final month = data[monthIndex];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              month.monthYear ?? "",
              style: TextStyle(
                color: Colors.white70,
                fontSize: Constant.CONTAINER_SIZE_16,
              ),
            ),

            SizedBox(height: Constant.SIZE_10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: month.damageContainers?.length ?? 0,
              itemBuilder: (context, damageIndex) {
                final damage = month.damageContainers![damageIndex];

                final product = damage.products!.first;

                return _userCard(
                  customerId: product.customerId ?? "",
                  dateTime: damage.localDateTime ?? "",
                  qty: damage.dateWiseTotalDamageContainers ?? 0,
                );
              },
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_16),
          ],
        );
      },
    );
  }

  Widget _userCard({
    required String customerId,
    required String dateTime,
    required int qty,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_14),
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: Constant.green4,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerId,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Constant.CONTAINER_SIZE_16,
                  ),
                ),

                SizedBox(height: Constant.SIZE_05),

                Text(dateTime, style: const TextStyle(color: Colors.white54)),
              ],
            ),
          ),

          Text(
            qty.toString(),
            style: TextStyle(
              color: Constant.PrimaryAssentColor,
              fontWeight: FontWeight.bold,
              fontSize: Constant.CONTAINER_SIZE_18,
            ),
          ),

          SizedBox(width: Constant.SIZE_08),

          const Icon(Icons.chevron_right, color: Colors.white),
        ],
      ),
    );
  }
}

class _PartnerUI extends StatelessWidget {
  const _PartnerUI();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          "November-2025",
          style: TextStyle(
            fontSize: Constant.CONTAINER_SIZE_16,
            color: Colors.white70,
          ),
        ),
        SizedBox(height: Constant.SIZE_10),
        _partnerCard("ROKA Business Bay", "01.11.2025 | 10:12", "2"),
        SizedBox(height: Constant.CONTAINER_SIZE_16),
        const Text("October-2025", style: TextStyle(color: Colors.white70)),
        SizedBox(height: Constant.CONTAINER_SIZE_10),
        _partnerCard("Sfumato Gastro Atelier", "10.10.2025 | 14:23", "4"),
        _partnerCard("ROKA Business Bay", "09.10.2025 | 12:23", "3"),
      ],
    );
  }

  Widget _partnerCard(String title, String subtitle, String qty) {
    return Container(
      margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_14),
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: Constant.green4,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Constant.CONTAINER_SIZE_16,
                  ),
                ),
                SizedBox(height: Constant.SIZE_05),
                Text(subtitle, style: const TextStyle(color: Colors.white54)),
              ],
            ),
          ),
          Text(
            qty,
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: Constant.CONTAINER_SIZE_18,
            ),
          ),
          SizedBox(width: Constant.SIZE_08),
          const Icon(Icons.chevron_right, color: Colors.white),
        ],
      ),
    );
  }
}
