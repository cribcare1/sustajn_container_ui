import 'package:container_tracking/transactions/provider_service/transaction_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_provider/network_provider.dart';
import '../../../constants/imports.util.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/no_data_custom_text.dart';
import '../../../utils/utility.dart';
import '../../common_widgets/sold_filter_bottom_sheet.dart';
import '../../utils/date_month_utils.dart';
import '../models/transaction_sold_data.dart';

class TransactionSoldScreen extends ConsumerStatefulWidget {
  TransactionSoldScreen({super.key});

  @override
  ConsumerState<TransactionSoldScreen> createState() => _TransactionSoldState();
}

class _TransactionSoldState extends ConsumerState<TransactionSoldScreen> {
  String _searchQuery = '';
  String? selectedMonthYear;
  late List<SoldDataList> filteredList = [];
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSoldNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionProvider);
    if (filteredList.isEmpty &&
        transactionState.getTransactionSoldDataList.isNotEmpty) {
      applySearchAndFilter(transactionState.getTransactionSoldDataList);
    }
    return Scaffold(
      backgroundColor: Color(0xFF0E3B2E),

      body: transactionState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : (transactionState.getTransactionSoldDataList.isEmpty)
          ? const Center(
              child: Text(
                Strings.NO_CONTAINER_AVAILABLE,
                style: TextStyle(color: Colors.white),
              ),
            )
          : Column(
              children: [
                _searchBar(),
                Expanded(
                  child: transactionState.getTransactionSoldDataList.isEmpty
                      ? Center(
                          child: NoDataFoundCustomText(
                            text: Strings.NO_SOLD_CONTAINER,
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.only(
                            top: Constant.CONTAINER_SIZE_10,
                          ),
                          itemCount: transactionState
                              .getTransactionSoldDataList
                              .length,
                          itemBuilder: (context, index) {
                            final month = transactionState
                                .getTransactionSoldDataList[index]
                                .monthYear;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _monthHeader(
                                  month ?? "",
                                  transactionState
                                      .getTransactionSoldDataList
                                      .length,
                                ),
                                ...transactionState
                                    .getTransactionSoldDataList[index]
                                    .transactions!
                                    .expand(
                                      (transaction) =>
                                          transaction.containers!.map(
                                            (container) => _soldItemCard(
                                              transaction: transaction,
                                              container: container,
                                            ),
                                          ),
                                    ),
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

  Widget _searchBar() {
    return Padding(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            applySearchAndFilter(
              ref.read(transactionProvider).getTransactionSoldDataList,
            );
          });
        },
        cursorColor: Colors.white,
        style: const TextStyle(),
        decoration: InputDecoration(
          hintText: Strings.SEARCH_BY_SOLD,
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            borderSide: BorderSide(color: Constant.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            borderSide: BorderSide(color: Constant.grey),
          ),
          fillColor: Constant.grey.withOpacity(0.1),
          filled: true,
          suffixIcon: IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              final months = DateMonthUtils.getCurrentYearMonths();

              final transactionState = ref.read(transactionProvider);

              List<Containers> allContainers = [];

              for (final soldData in transactionState.getTransactionSoldDataList) {
                for (final transaction in soldData.transactions ?? []) {
                  allContainers.addAll(transaction.containers ?? []);
                }
              }
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => SoldFilterBottomSheet(
                  containerList: allContainers,
                  onApply: (result) {
                    setState(() {
                      applySearchAndFilter(
                        transactionState.getTransactionSoldDataList,
                      );
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void applySearchAndFilter(List<SoldDataList> sourceList) {
    filteredList = List.from(sourceList);

    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList.where((item) {
        return item.transactions?.any((transaction) {
              return transaction.containers?.any((container) {
                    return (container.containerName ?? "")
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ||
                        (container.productCode ?? "").toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        );
                  }) ??
                  false;
            }) ??
            false;
      }).toList();
    }

    if (selectedMonthYear != null) {
      final selectedMonthName = selectedMonthYear!.split('–')[0];
      final selectedMonthIndex = DateMonthUtils.getMonthIndex(
        selectedMonthName,
      );

      filteredList = filteredList.where((item) {
        final itemMonth = DateTime.parse(item.monthYear!).month;
        return itemMonth == selectedMonthIndex;
      }).toList();
    }
  }

  Widget _soldItemCard({
    required Transactions transaction,
    required Containers container,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF184D3B), Color(0xFF0E3A2D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween),

              const SizedBox(height: 14),

              Divider(color: Colors.white.withValues(alpha: 0.15), height: 1),

              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        "${NetworkUrls.IMAGE_BASE_URL}${container.imageUrl ?? ""}",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/no_image_container.png",
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          container.containerName ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          container.productCode ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "${container.capacity ?? ""} ",
                          style: theme.textTheme.titleSmall!.copyWith(
                            color: Colors.white,
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
                            'assets/images/bowl_img.png',
                            height: Constant.CONTAINER_SIZE_16,
                            width: Constant.CONTAINER_SIZE_16,
                          ),
                          SizedBox(width: Constant.SIZE_04),
                          Text(
                            container.quantity?.toString() ?? "0",
                            style: theme.textTheme.titleSmall!.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Image.asset(
                            'assets/images/diarhm.png',
                            height: Constant.CONTAINER_SIZE_16,
                            color: Constant.orange,
                            colorBlendMode: BlendMode.srcIn,
                          ),
                          SizedBox(width: Constant.SIZE_02),
                          Text(
                            container.price?.toString() ?? "0",
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: Color(0xFFE5C84B),
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
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _monthHeader(String title, int count) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Constant.CONTAINER_SIZE_12,
          horizontal: Constant.CONTAINER_SIZE_16,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
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
        final transactionState = ref.read(transactionProvider);
        if (isNetworkAvailable) {
          transactionState.setIsLoading(true);

          final url = '${NetworkUrls.SOLD_DASHBOARD}';
          ref.read(getTransactionSoldDataList(url));
        } else {
          transactionState.setIsLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error in visitor button onPressed: $e');
    }
  }
}
