import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/get_container_data.dart';
import '../../models/login_model.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/order_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import '../models/add_container_model.dart';
import 'add_container_dialog.dart';

class AddContainerScreen extends ConsumerStatefulWidget{
  const AddContainerScreen({super.key});

  @override
  ConsumerState<AddContainerScreen> createState() => _AddContainerScreenState();
}

class _AddContainerScreenState extends ConsumerState<AddContainerScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<ContainerItem> containers = [
    ContainerItem(
      name: "Dip Cup",
      code: "ST-DC-50",
      volume: "50ml",
      availableQty: 165,
      image: "assets/images/cups.png",
    ),
    ContainerItem(
      name: "Dip Cup",
      code: "ST-DC-70",
      volume: "70ml",
      availableQty: 165,
      image: "assets/images/cups.png",
    ),
    ContainerItem(
      name: "Round Container",
      code: "ST-RDC-500",
      volume: "500ml",
      availableQty: 165,
      image: "assets/images/cups.png",
    ),
    ContainerItem(
      name: "Rectangular Container",
      code: "ST-RC-800",
      volume: "800ml",
      availableQty: 165,
      image: "assets/images/cups.png",
    ),
  ];
  final searchController = TextEditingController();

  List<GetContainerData> containerData = [];
  LoginData? loginResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _getOrderNetworkCall();
  }

  Future<void> _loadProfile() async {
    await Utils.getProfile();
    setState(() {
      loginResponse = Utils.loginData?.data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderState = ref.watch(orderProvider);

    return SafeArea(
      bottom: true, top: false,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            children: [
              CustomTheme.searchField(
                  searchController, "Search Container by Name"),
              SizedBox(height: Constant.CONTAINER_SIZE_10),

              Expanded(
                child: orderState.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : orderState.getContainerData!.containersDetails!.isEmpty
                    ? Center(
                  child: Text("No containers found",
                    style: TextStyle(color: Colors.white),),
                )
                    : ListView.separated(
                  itemCount: orderState.getContainerData!.containersDetails!
                      .length,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: Constant.CONTAINER_SIZE_12),
                  itemBuilder: (context, index) {
                    final item =
                    orderState.getContainerData!.containersDetails![index];
                    return _containerCard(
                        context, item, theme);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _containerCard(BuildContext context, ContainersDetails item,
      ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        color: Constant.grey.withOpacity(0.2),
        borderRadius:
        BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        border: Border.all(
          color: Constant.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: Constant.CONTAINER_SIZE_50,
            height: Constant.CONTAINER_SIZE_50,
            decoration: BoxDecoration(
              color: Constant.white.withOpacity(0.2),
              borderRadius:
              BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            ),
            child: Image.asset("assets/images/cups.png", fit: BoxFit.contain),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.containerName!,
                    style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white
                    )),
                SizedBox(height: Constant.SIZE_04),
                Text(item.containerUniqueId.toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white
                    )),
                SizedBox(height: Constant.SIZE_04),
                Text("${item.capacity.toString()} ml",
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70
                    )),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Available Qty",
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white
                  )),
              Text(item.quantityAvailable.toString(),
                  style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white
                  )),

              SizedBox(height: Constant.SIZE_06),

              GestureDetector(
                onTap: () => _openAddDialog(context, item),
                child:
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Constant.CONTAINER_SIZE_20,
                    vertical: Constant.SIZE_04,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_20),
                    border: Border.all(
                        color: Constant.gold),
                  ),
                  child: Text(
                    "Add",
                    style: theme.textTheme.bodySmall?.copyWith(
                        color:
                        Constant.gold),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _openAddDialog(BuildContext context, ContainersDetails item) async {
    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) =>
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom),
            child: AddContainerDialog(item: item),
          ),
    );
  }

  _getOrderNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then(
              (isNetworkAvailable) {
            Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
            final orderState = ref.read(orderProvider);
            if (isNetworkAvailable) {
              orderState.setIsLoading(true);
              final userId = Utils.userId;
              final url = '${NetworkUrls.GET_CONTAINER}$userId';
              ref.read(getOrderProvider(url));
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
