import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common_widgets/custom_app_bar.dart';
import '../common_widgets/custom_back_button.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../utils/theme_utils.dart';
import 'add_new_container.dart';
import 'container_details.dart';

class ContainersScreen extends StatefulWidget {
  const ContainersScreen({super.key});

  @override
  State<ContainersScreen> createState() => _ContainersScreenState();
}

class _ContainersScreenState extends State<ContainersScreen> {
  List<Map<String, dynamic>> containerList = [];


  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(true);
    return Scaffold(
      backgroundColor: themeData?.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: Strings.CONTAINERS_TITLE,
        leading: CustomBackButton(),
      ).getAppBar(context),
      body: SafeArea(
        child: containerList.isEmpty
            ? _buildEmptyScreen()
            : _buildContainerList(themeData!),
      ),
      floatingActionButton :  containerList.isNotEmpty ?
      FloatingActionButton(
        backgroundColor: const Color(0xFF2D8F6E),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddContainerScreen()),
          );
          if (result != null) {
            setState(() {
              containerList.add(result);
            });
          }
        },
        child: Icon(Icons.add, color: Colors.white, size: Constant.CONTAINER_SIZE_28),
      ) : null,

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
                      setState(() {
                        containerList.add(result);
                      });
                    }
            },
            icon: Icon(Icons.add, color: Colors.white),
            label: Text(
              Strings.ADD_CONTAINER,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD9A21B),
              padding: EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_14, horizontal: Constant.CONTAINER_SIZE_24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildContainerList(ThemeData themeData) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: TextField(
            decoration: InputDecoration(
              hintText: Strings.SEARCH_CONTAINER_NAME,
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: const Icon(Icons.filter_list),
            ),
          ),
        ),

        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16),
            itemCount: containerList.length,
            separatorBuilder: (context, index) => Divider(
              height: Constant.CONTAINER_SIZE_12,
              thickness: 1,
              color: Colors.grey[300],
            ),
            itemBuilder: (context, index) {
              final item = containerList[index];
              return _buildContainerTile(item, themeData!);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContainerTile(Map<String, dynamic> item, ThemeData themeData) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=> ContainerDetailsScreen(containerData: item)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_12),
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
        decoration: BoxDecoration(
          color: themeData.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
              child: item["image"] != null
                  ? Image.file(
                item["image"] as File,
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
                    item["name"]?.toString() ?? 'Unnamed',
                    style: TextStyle(
                      fontSize: Constant.LABEL_TEXT_SIZE_16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_04),
                  Text(
                    item["id"]?.toString() ?? 'No ID',
                    style: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_14, color: Colors.grey),
                  ),
                  Text(
                    "${item["volume"]?.toString() ?? '0'}ml",
                    style: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Text(
              item["quantity"]?.toString() ?? '0',
              style: TextStyle(
                fontSize: Constant.LABEL_TEXT_SIZE_18,
                fontWeight: FontWeight.bold,
              ),
            ),
             SizedBox(width: Constant.SIZE_10),
             Icon(Icons.arrow_forward_ios, size: Constant.CONTAINER_SIZE_16, color: Colors.grey),
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
}
