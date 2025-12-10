import 'package:flutter/material.dart';
import 'package:sustajn_customer/common_widgets/custom_app_bar.dart';
import 'package:sustajn_customer/common_widgets/custom_back_button.dart';
import '../constants/number_constants.dart';

class BorrowedDetailsScreen extends StatelessWidget {
  const BorrowedDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: 'Borrowed Details',
          leading: CustomBackButton()).getAppBar(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _headerCard(context, theme),
                  SizedBox(height: Constant.CONTAINER_SIZE_12),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: Constant.CONTAINER_SIZE_10,
                            horizontal: Constant.CONTAINER_SIZE_20,
                          ),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(Constant.CONATAINER_SIZE_255),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/images/cups.png',
                                height: 35, width: 35,
                              color: theme.primaryColor,),
                              SizedBox(width: Constant.CONTAINER_SIZE_10),
                              Text(
                                '3',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontSize: Constant.LABEL_TEXT_SIZE_30,
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Constant.CONTAINER_SIZE_10),
                        Text(
                          '01/11/2025  |  10:00am',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: Constant.LABEL_TEXT_SIZE_16,
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_16),
                  _sectionTitle(theme),
                  SizedBox(height: Constant.CONTAINER_SIZE_12),
                  _borrowedList(context, theme),
                  SizedBox(height: Constant.CONTAINER_SIZE_12),
                ],
              ),
            );
          },
        ),
      ),
    );
  }


  Widget _headerCard(BuildContext context, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Constant.PADDING_HEIGHT_10),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(Constant.SIZE_005),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Golden Falcon Restaurant',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: Constant.LABEL_TEXT_SIZE_16,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: Constant.MAX_LINE_1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Constant.SIZE_04),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: Constant.CONTAINER_SIZE_16,
                    color: theme.hintColor,
                  ),

                  SizedBox(width: Constant.SIZE_08),
                  Expanded(
                    child: Text(
                      'Al Marsa Street 57, Dubai Marina, PO Box 32923, Dubai',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: Constant.LABEL_TEXT_SIZE_14,
                        color: theme.hintColor,
                      ),
                      maxLines: Constant.MAX_LINE_2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Constant.PADDING_HEIGHT_10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Borrowed Container',
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: Constant.LABEL_TEXT_SIZE_18,
          ),
        ),
      ),
    );
  }

  Widget _borrowedList(BuildContext context, ThemeData theme) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Constant.PADDING_HEIGHT_10),
        child: Column(
          children: [
            _borrowedItem(
              theme: theme,
              title: 'Dip Cups',
              subtitle: 'ST-DC-50\n50ml',
              quantity: 2,
            ),
            Divider(color: Colors.grey),
            _borrowedItem(
              theme: theme,
              title: 'Round Bowl',
              subtitle: 'ST-RB-450\n450ml',
              quantity: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _borrowedItem({
    required ThemeData theme,
    required String title,
    required String subtitle,
    required int quantity,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Constant.CONTAINER_SIZE_12,
        horizontal: Constant.SIZE_08,
      ),
      child: Row(
        children: [
          Container(
            width: Constant.CONTAINER_SIZE_50,
            height: Constant.CONTAINER_SIZE_50,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(Constant.SIZE_08),
            ),
            child:
            Image.asset('assets/images/cups.png',
            ),
          ),
          SizedBox(width: Constant.CONTAINER_SIZE_12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: Constant.LABEL_TEXT_SIZE_16,
                  ),
                  maxLines: Constant.MAX_LINE_1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Constant.SIZE_02),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: Constant.LABEL_TEXT_SIZE_14,
                    color: theme.hintColor,
                  ),
                  maxLines: Constant.MAX_LINE_2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: Constant.CONTAINER_SIZE_12),
          Text(
            quantity.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: Constant.LABEL_TEXT_SIZE_16,
            ),
          ),
        ],
      ),
    );
  }
}
