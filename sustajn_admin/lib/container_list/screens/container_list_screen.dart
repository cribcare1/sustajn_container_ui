import 'dart:io';

import 'package:container_tracking/container_list/container_provider.dart';
import 'package:container_tracking/container_list/screens/container_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common_provider/network_provider.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/filter_screen.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import '../container_state.dart';
import '../model/container_list_model.dart';
import 'add_new_container.dart';

class ContainersScreen extends ConsumerStatefulWidget {
  const ContainersScreen({super.key});

  @override
  ConsumerState<ContainersScreen> createState() => _ContainersScreenState();
}

class _ContainersScreenState extends ConsumerState<ContainersScreen> {
@override
  void initState() {
    _getNetworkData(ref.read(containerNotifierProvider));
    super.initState();
  }
  Future<void> _refreshIndicator()async{
    _getNetworkData(ref.read(containerNotifierProvider));
  }
  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(true);
    final state = ref.watch(containerNotifierProvider);
    return Scaffold(
      backgroundColor: themeData?.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: Strings.CONTAINERS_TITLE,
        leading: SizedBox.shrink(),
        action: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(
            onPressed: () async {
              final result = await showContainerFilterBottomSheet(
                context,
                state.containerList,
              );

              if (result != null) {
                print("Selected: $result");
              }
            },
            icon: Icon(Icons.filter_list),
          ),
        ],
      ).getAppBar(context),
      body:  state.isSaving?Center(child: CircularProgressIndicator(),):
      state.errorContainer != null?
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.errorContainer!,style: themeData!.textTheme.titleMedium,),
                ElevatedButton(
                    onPressed: (){
                      _refreshIndicator();
                    },
                    child: Padding(
                      padding:  EdgeInsets.all(Constant.SIZE_08),
                      child: Text("Retry",style: themeData.textTheme.titleMedium!.copyWith(color: Colors.white),),
                    ))
              ],
            ),
          )
          :
      SafeArea(
        child: state.containerList.isEmpty
            ? _buildEmptyScreen()
            : _buildContainerList(themeData!,state),
      ),
      floatingActionButton: state.containerList.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF2D8F6E),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddContainerScreen()),
                ).then((value){
                  if(value = true){
                    _refreshIndicator();
                  }
                });
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: Constant.CONTAINER_SIZE_28,
              ),
            )
          : null,

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildEmptyScreen() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/bowls.png',
            width: Constant.CONTAINER_SIZE_80,
            height: Constant.CONTAINER_SIZE_80,
            color: Colors.grey,
            fit: BoxFit.contain,
          ),
          SizedBox(height: Constant.CONTAINER_SIZE_20),
          Text(
            Strings.NO_CONTAINERS,
            style: TextStyle(
              fontSize: Constant.LABEL_TEXT_SIZE_16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          SizedBox(height: Constant.SIZE_08),
          Text(
            Strings.START_ADD_CONTAINERS,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Constant.CONTAINER_SIZE_14,
              color: Colors.grey,
            ),
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_24),

          ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddContainerScreen()),
              );
              if (result != null) {
              _refreshIndicator();
              }
            },
            icon: Icon(Icons.add, color: Colors.white),
            label: Text(
              Strings.ADD_CONTAINER,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD9A21B),
              padding: EdgeInsets.symmetric(
                vertical: Constant.CONTAINER_SIZE_14,
                horizontal: Constant.CONTAINER_SIZE_24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContainerList(ThemeData themeData, ContainerState state) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _refreshIndicator(),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: Constant.CONTAINER_SIZE_16,
                vertical: Constant.CONTAINER_SIZE_16,

              ),
              itemCount: state.containerList.length,
              separatorBuilder: (context, index) => Divider(
                height: Constant.CONTAINER_SIZE_12,
                thickness: 1,
                color: Colors.grey[300],
              ),
              itemBuilder: (context, index) {
                final item = state.containerList[index];
                return _buildContainerTile(item, themeData);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContainerTile(InventoryData item, ThemeData themeData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContainerDetailsScreen(containerData: item),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_12),
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
              child: item.imageUrl != ""
                  ? Image.network(
                      item.imageUrl,
                      width: Constant.CONTAINER_SIZE_55,
                      height: Constant.CONTAINER_SIZE_55,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage();
                      },
                    )
                  : _buildPlaceholderImage(),
            ),
            SizedBox(width: Constant.CONTAINER_SIZE_14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.containerName,
                      overflow: TextOverflow.ellipsis,
                    style: themeData.textTheme.titleMedium
                  ),
                  SizedBox(height: Constant.SIZE_04),
                  Text(
                    item.containerTypeId.toString(),
                    style: TextStyle(
                      fontSize: Constant.LABEL_TEXT_SIZE_14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "${item.capacityMl}ml",
                    style: TextStyle(
                      fontSize: Constant.LABEL_TEXT_SIZE_14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              item.totalContainers.toString(),
              style: TextStyle(
                fontSize: Constant.LABEL_TEXT_SIZE_18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: Constant.SIZE_10),
            Icon(
              Icons.arrow_forward_ios,
              size: Constant.CONTAINER_SIZE_16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: Constant.CONTAINER_SIZE_55,
      height: Constant.CONTAINER_SIZE_55,
      color: Colors.grey[200],
      child: Icon(Icons.image, color: Colors.grey[400]),
    );
  }
  _getNetworkData(var containerState) async {
    try {
      await ref
          .read(networkProvider.notifier)
          .isNetworkAvailable()
          .then((isNetworkAvailable) async {
        try {
          if (isNetworkAvailable) {
          ref.read(fetchContainerProvider(""));
          } else {
            if(!mounted) return;showCustomSnackBar(context: context, message: Strings.NO_INTERNET_CONNECTION, color: Colors.red);
          }
        } catch (e) {
          Utils.printLog('Error on button onPressed: $e');
        }
        if(!mounted) return;
        FocusScope.of(context).unfocus();
      });
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
    }
  }
}
