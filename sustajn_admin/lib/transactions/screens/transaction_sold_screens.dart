import 'package:container_tracking/transactions/provider_service/transaction_provider.dart';
import 'package:container_tracking/transactions/screens/transaction_sold_popup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
      backgroundColor: Constant.PrimaryColor,

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
                            final item = transactionState
                                .getTransactionSoldDataList[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _monthHeader(
                                  item.monthYear ?? "",
                                  item.monthTotalAmount ?? 0,
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
              List<String> transactionNames = [];
              for (var soldDataList in transactionState.getTransactionSoldData!.data! ?? []) {
                  for (var transaction in soldDataList.transactions ?? []) {
                    if (transaction.name != null) {
                      transactionNames.add(transaction.name!);
                    }
                  }
                }

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


  void applyFilter(
      List<SoldDataList> sourceList, SoldFilterResult filter,) {
    filteredList = sourceList.map((monthData) {
      final filteredTransactions = monthData.transactions?.where((transaction) {
        print('---------------------------------------');
        print('Month  : ${monthData.monthYear}');
        print('Transaction : ${transaction.id}');
        print('Name        : ${transaction.name}');
        print('Date        : ${transaction.formattedDate}');

        print('filter age        : ${filter.ageRange!.start} - ${filter.ageRange!.end}');
        print('filter soldby : ${filter.soldBy.toString()}');
        print('filter months : ${filter.months.toString()}');
        print('filter containers : ${filter.containers!.toString()}');
       // print('filter container        : ${filter.containers!.elementAt(0).containerTypeId}');


        bool matches = true;

        final transactionDate =
        DateFormat('dd.MM.yyyy')
            .parse(transaction.formattedDate!);


        if (filter.ageRange != null && filter.ageRange!.start>20) {
          final ageInDays =
              DateTime.now()
                  .difference(transactionDate)
                  .inDays;

          matches &= ageInDays >= filter.ageRange!.start &&
              ageInDays <= filter.ageRange!.end;
        }


        if (filter.months != null &&
            filter.months!.isNotEmpty) {
          matches &= filter.months!.any(
                (month) =>
            DateMonthUtils.getMonthIndex(month) ==
                transactionDate.month,
          );
        }


        if (filter.soldBy != null &&
            filter.soldBy!.isNotEmpty) {
          matches &= filter.soldBy![0].contains(transaction.name!);
        }


        if (filter.containers != null &&
            filter.containers!.isNotEmpty) {
          matches &= transaction.containers?.any(
                (container) =>
                filter.containers!.any(
                      (selected) =>
                  selected.containerTypeId ==
                      container.containerTypeId,
                ),
          ) ??
              false;
        }

        return matches;
      }).toList();

      if (filteredTransactions == null ||
          filteredTransactions.isEmpty) {
        return null;
      }

    })
        .whereType<SoldDataList>()
        .toList();
  }

  Widget _soldItemCard({
    required Transactions transaction,
    required Containers container,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      child: InkWell(
        onTap:(){
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => TransactionSoldPopup(
              transactions: transaction,
              // onApply: (result) {
              //   setState(() {
              //     applyFilter(
              //       transactionState.getTransactionSoldDataList,
              //       result,
              //     );
              //   });
              // },
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_18),
            gradient: const LinearGradient(
              colors: [Constant.green7, Constant.green8],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: Constant.CONTAINER_SIZE_10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_14),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween),

                SizedBox(height: Constant.CONTAINER_SIZE_14),

                Divider(color: Colors.white.withValues(alpha: 0.15), height: Constant.SIZE_01),

                SizedBox(height: Constant.CONTAINER_SIZE_12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: Constant.CONTAINER_SIZE_60,
                      width: Constant.CONTAINER_SIZE_60,
                      padding: EdgeInsets.all(Constant.SIZE_06),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
                        child: Image.network(
                          "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${container.imageUrl ?? ""}",
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
                    SizedBox(width: Constant.CONTAINER_SIZE_12),
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
                          SizedBox(height: Constant.SIZE_02),
                          Text(
                            container.productCode ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall!.copyWith(
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(height: Constant.SIZE_04),

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
                              Strings.BOWL_IMG,
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

                        SizedBox(height: Constant.SIZE_06),

                        Row(
                          children: [
                            Image.asset(
                              Strings.DIRHAM_IMG,
                              height: Constant.CONTAINER_SIZE_16,
                              color: Constant.PrimaryAssentColor,
                              colorBlendMode: BlendMode.srcIn,
                            ),
                            SizedBox(width: Constant.SIZE_02),
                            Text(
                              container.price?.toString() ?? "0",
                              style: theme.textTheme.titleMedium!.copyWith(
                                color: Constant.PrimaryAssentColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: Constant.CONTAINER_SIZE_16,
                    ),
                  ],
                ),
              ],
            ),
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
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: Constant.CONTAINER_SIZE_12),
        ),
        SizedBox(height: Constant.SIZE_04),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
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
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Constant.CONTAINER_SIZE_12,
          horizontal: Constant.CONTAINER_SIZE_16,
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: Constant.CONTAINER_SIZE_15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            Image.asset(
              Strings.DIRHAM_IMG,
              height: Constant.CONTAINER_SIZE_16,
              color: Constant.PrimaryAssentColor,
              colorBlendMode: BlendMode.srcIn,
            ),
            SizedBox(width: Constant.SIZE_02),
            Text(
              count.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: Constant.CONTAINER_SIZE_15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
