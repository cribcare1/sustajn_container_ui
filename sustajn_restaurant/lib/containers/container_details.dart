import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import '../constants/number_constants.dart';
import '../product_screen/containers_list_screen.dart';
import '../product_screen/models/assigned_container_list.dart';

class ContainersDetailsScreen extends StatelessWidget {
  const ContainersDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(title:'Container Details',
          leading: CustomBackButton()).getAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: ListView(
            children: [
              Center(
                child: _productCard(theme),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_16),
              _statsList(theme),
            ],
          ),

        ),
      ),
    );
  }

  Widget _productCard(ThemeData theme) {
    return Container(
      height: Constant.CONTAINER_SIZE_250,
      width: Constant.CONTAINER_SIZE_210,
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        border: Border.all(color: Constant.gold, width: Constant.SIZE_01),
        gradient: LinearGradient(
          colors: [
            Constant.grey.withOpacity(0.2),
            theme.primaryColor.withOpacity(0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: Constant.CONTAINER_SIZE_100,
            width: Constant.CONTAINER_SIZE_100,
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            ),
            child: Image.asset(
              "assets/images/cups.png",
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(height: Constant.SIZE_10),

          Text(
            "Dip Cup",
            maxLines: Constant.MAX_LINE_1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: Constant.SIZE_04),
          Text(
            "ST-DC-50",
            maxLines: Constant.MAX_LINE_1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
          ),
          SizedBox(height: Constant.SIZE_02),
          Text(
            "50ml",
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsList(ThemeData theme) {
    final stats = [
      {"title": "Assigned Containers", "value": "5,000", "arrow": true},
      {"title": "Total Leased", "value": "3,986", "arrow": true},
      {"title": "Total Received", "value": "254", "arrow": true},
      {"title": "Available", "value": "1268", "arrow": false},
    ];

    return ListView.builder(
      itemCount: stats.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final title = stats[index]["title"] as String;
        return _statCard(
          theme,
          title: stats[index]["title"] as String,
          value: stats[index]["value"] as String,
          showArrow: stats[index]["arrow"] as bool,
          onTap: (){
            if(title == 'Assigned Containers'){
              _navigateAssignedContainer(context);
            }
            else if (title == 'Total Leased'){
              _navigateTotalLeased(context);
            }
            else if (title == 'Total Received'){
              _navigateTotalReceived(context);
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
            AssignedContainerItem(
                dateTime: DateTime(2024, 11, 1, 23, 21),
                quantity: 800),
            AssignedContainerItem(
                dateTime: DateTime(2024, 11, 1, 23, 21),
                quantity: 800),
          ],
        ),
      ),
    );

  }
  void _navigateTotalLeased(BuildContext context){
    Navigator.push(context,
        MaterialPageRoute(builder: (context)=> AssignedContainerListScreen(
          title: "Total Leased",
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
            AssignedContainerItem(
                dateTime: DateTime(2024, 11, 1, 23, 21),
                quantity: 800),
            AssignedContainerItem(
                dateTime: DateTime(2024, 11, 1, 23, 21),
                quantity: 800),
          ],
        ),));
  }
  void _navigateTotalReceived(BuildContext context){
    Navigator.push(context,
        MaterialPageRoute(builder: (context)=> AssignedContainerListScreen(
          title: "Total Received",
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
            AssignedContainerItem(
                dateTime: DateTime(2024, 11, 1, 23, 21),
                quantity: 800),
            AssignedContainerItem(
                dateTime: DateTime(2024, 11, 1, 23, 21),
                quantity: 800),
          ],
        ),));
  }

  Widget _statCard(
      ThemeData theme, {
        required String title,
        required String value,
        required bool showArrow,
        required VoidCallback onTap
      }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: Constant.SIZE_10),
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: Constant.MAX_LINE_2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_06),
                  Text(
                    value,
                    maxLines: Constant.MAX_LINE_1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            if (showArrow) ...[
              SizedBox(width: Constant.SIZE_08),
              Icon(
                Icons.call_made_outlined,
                size: Constant.CONTAINER_SIZE_18,
                color: Colors.white70,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
