import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/containers/total_borrowed.dart';
import 'package:sustajn_restaurant/containers/total_returned.dart';
import '../constants/number_constants.dart';
import 'containers_list_screen.dart';
import 'models/assigned_container_list.dart';

class ContainersDetailsScreen extends StatelessWidget {
  const ContainersDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar:CustomAppBar(title: "Container Details",
          leading:CustomBackButton() ).getAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            children: [
              _productCard(theme),
              SizedBox(height: Constant.CONTAINER_SIZE_16),
              Expanded(
                child: _statsGrid(theme),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _productCard(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_14),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_15),
      ),
      child: Row(
        children: [
          Container(
            height: Constant.CONTAINER_SIZE_64,
            width: Constant.CONTAINER_SIZE_64,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            ),
            child: Padding(
              padding: EdgeInsets.all(Constant.SIZE_08),
              child: Image.asset(
                "assets/images/cups.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: Constant.CONTAINER_SIZE_14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dip Cups",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                  maxLines: Constant.MAX_LINE_1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  "ST-DC-50",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                  maxLines: Constant.MAX_LINE_1,
                ),
                SizedBox(height: Constant.SIZE_02),
                Text(
                  "50ml",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _statsGrid(ThemeData theme) {
    final stats = [
      {"title": "Available", "value": "1,268"},
      {"title": "Assigned Containers", "value": "5,000"},
      {"title": "Total Borrowed", "value": "3,986"},
      {"title": "Total Returned", "value": "254"},
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (context, index) {
        final title = stats[index]["title"] as String;
        return _statCard(
            theme,
            title: title,
            value: stats[index]["value"] as String,
            showArrow:title != 'Available',
            onTap: (){
              if(title == 'Assigned Containers'){
                _navigateAssignedContainer(context);
              }
              else if (title == 'Total Borrowed'){
                _navigateTotalBorrowed(context);
              }
              else if (title == 'Total Returned'){
                _navigateTotalReturned(context);
              }
            }
        );
      },
    );
  }

  void _navigateAssignedContainer(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AssignedContainerListScreen(
          title: "Assigned Containers",
          items: [
            AssignedContainerItem(
                dateTime: DateTime(2025, 11, 25, 10, 0),
                quantity: 350),
            AssignedContainerItem(
                dateTime: DateTime(2025, 11, 15, 11, 23),
                quantity: 400),
            AssignedContainerItem(
                dateTime: DateTime(2025, 11, 1, 23, 21),
                quantity: 800),
          ],
        ),
      ),
    );

  }
  void _navigateTotalBorrowed(BuildContext context){
    Navigator.push(context,
        MaterialPageRoute(builder: (context)=> TotalBorrowedScreen()));
  }
  void _navigateTotalReturned(BuildContext context){
    Navigator.push(context,
        MaterialPageRoute(builder: (context)=> TotalReturnedScreen()));
  }




  Widget _statCard(
      ThemeData theme, {
        required String title,
        required String value,
        bool showArrow = false,
        required VoidCallback onTap
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showArrow)
                  Icon(
                    Icons.call_made_outlined,
                    size: Constant.CONTAINER_SIZE_16,
                    color: theme.iconTheme.color,
                  ),
              ],
            ),
            SizedBox(height: Constant.SIZE_08),
            Expanded(
              child: Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
