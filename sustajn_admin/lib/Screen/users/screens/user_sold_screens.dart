import 'package:container_tracking/Screen/users/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_provider/network_provider.dart';
import '../../../common_widgets/custom_app_bar.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../constants/imports.util.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/no_data_custom_text.dart';
import '../../../utils/utility.dart';
import '../model/user_sold_container_data.dart';
import '../model/user_sold_details.dart';

class UserSoldScreen extends ConsumerStatefulWidget {

  final int userId;

  const UserSoldScreen({super.key, required this.userId});

  @override
  ConsumerState<UserSoldScreen> createState() => _SoldTabState();
}

class _SoldTabState extends ConsumerState<UserSoldScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSoldNetworkCall();
  }

  final List<SoldDetails> containers = [];

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(userProvider);
    return Scaffold(
        backgroundColor: Constant.PrimaryColor,
        appBar: CustomAppBar(
          title: Strings.SOLD,
          leading: CustomBackButton(),
        ).getAppBar(context),
        body: Column(
              children: [
                Expanded(
                  child: historyState.soldContainerList.isEmpty
          ? Center(
        child: NoDataFoundCustomText(text: Strings.NO_SOLD_CONTAINER),
                  )
          : ListView.separated(
        padding: EdgeInsets.only(top: Constant.CONTAINER_SIZE_10),
        itemCount: historyState.soldContainerList.length,
        itemBuilder: (context, index) {
          final month =
              historyState.soldContainerList[index].monthYear;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _monthHeader(
                month ?? "",
                historyState.soldContainerList.length,
              ),
              ...historyState
                  .soldContainerList[index]
                  .dateWiseSoldContainers!
                  .map((item) => _soldItemCard(item: item)),
            ],
          );
        },
        separatorBuilder: (context, index) =>
            SizedBox(height: Constant.CONTAINER_SIZE_12),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _soldItemCard({required DateWiseSoldContainers item}) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_18),
          gradient: LinearGradient(
            colors: [Constant.green7, Constant.green8],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Constant.white.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Constant.black.withOpacity(0.25),
              blurRadius: Constant.CONTAINER_SIZE_10,
              offset: Offset(Constant.SIZE_00, Constant.SIZE_04),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_14),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _dateItem(
                    title: Strings.BORROWED_ON1,
                    value: item.borrowedOn ?? "",
                  ),
                  _dateItem(title: Strings.DUE_ON, value: item.dueOn ?? ""),
                  _dateItem(title: Strings.SOLD_ON, value: item.soldOn ?? ""),
                ],
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_14),

              Divider(color: Constant.white.withOpacity(0.15), height: Constant.SIZE_01),

              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: Constant.CONTAINER_SIZE_60,
                    width: Constant.CONTAINER_SIZE_60,
                    padding: EdgeInsets.all(Constant.SIZE_06),
                    decoration: BoxDecoration(
                      color: Constant.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
                      child: Image.network(
                        "${NetworkUrls.IMAGE_BASE_URL}${item.productImageUrl}",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            Strings.NO_IMG,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: Constant.CONTAINER_SIZE_12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: Constant.BeigeColor,
                          ),
                        ),
                        SizedBox(height: Constant.SIZE_02),
                        Text(
                          item.productUniqueId ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall!.copyWith(
                            color: Constant.BeigeColor,
                          ),
                        ),

                        SizedBox(height: Constant.SIZE_04),

                        Text(
                          "${item.capacity}ml",
                          style: theme.textTheme.titleSmall!.copyWith(
                            color: Constant.BeigeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            Strings.BOWL_IMG,
                            height: Constant.CONTAINER_SIZE_16,
                            width: Constant.CONTAINER_SIZE_16,
                          ),
                          SizedBox(width: Constant.SIZE_04),
                          Text(
                            item.soldQuantity?.toString() ?? "",
                            style: theme.textTheme.titleSmall!.copyWith(
                              color: Constant.BeigeColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: Constant.SIZE_06),

                      Row(
                        children: [
                          Image.asset(
                            Strings.DIRHAM_IMG,
                            height: Constant.CONTAINER_SIZE_16,
                            color: Constant.orange,
                            colorBlendMode: BlendMode.srcIn,
                          ),
                          SizedBox(width: Constant.SIZE_02),
                          Text(
                            item.soldAmount?.toString() ?? "",
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: Constant.PrimaryAssentColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateItem({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Constant.BeigeColor.withOpacity(0.7), fontSize: Constant.CONTAINER_SIZE_12),
        ),
        SizedBox(height: Constant.SIZE_02),
        Text(
          value,
          style: TextStyle(
            color: Constant.BeigeColor,
            fontSize: Constant.CONTAINER_SIZE_15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _monthHeader(String title, int count) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Constant.white.withOpacity(0.2)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Constant.CONTAINER_SIZE_12,
          horizontal: Constant.CONTAINER_SIZE_16,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Constant.BeigeColor,
            fontSize: Constant.CONTAINER_SIZE_15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  _getSoldNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(userProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);

          final url = '${NetworkUrls.GET_SOLD_CONTAINER}${widget.userId}';
          ref.read(getSoldContainerProvider(url));
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
