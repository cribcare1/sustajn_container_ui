import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import '../common_widgets/filter_Screen.dart';
import '../constants/number_constants.dart';

class TotalBorrowedScreen extends StatelessWidget {
  const TotalBorrowedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: 'Total Borrowed',
          action: [
            IconButton(onPressed: (){
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => ReusableFilterBottomSheet(
                  title: "Filters",
                  leftTabTitle: "Month",
                  options: [
                    "December–2024",
                    "January–2025",
                    "February–2024",
                    "March–2024",
                    "Apiral–2024",
                    "May–2024",
                    "June–2024",
                    "July–2024",
                    "August–2024",
                    "September–2025",
                    "October–2025",
                    "November–2025",
                  ],
                  selectedValue: "January–2025",
                  onApply: (value) {
                    print("Selected Month = $value");
                  },
                ),
              );
            },
                icon: Icon(Icons.filter_list,
                color: Colors.white,))
          ],
          leading: CustomBackButton()).getAppBar(context),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _monthHeader(
            context,
            title: "November–2025",
            total: "1,550",
          ),
          _dateItem(context, "25/11/2025", "35"),
          _dateItem(context, "15/11/2025", "4"),
          _dateItem(context, "01/11/2025", "80"),

          _monthHeader(
            context,
            title: "October–2025",
            total: "750",
          ),
          _dateItem(context, "20/10/2025", "25"),
          _dateItem(context, "10/10/2025",  "3"),
          _dateItem(context, "01/10/2025", "20"),

          _monthHeader(
            context,
            title: "September–2025",
            total: "1,000",
          ),
          _dateItem(context, "22/09/2025",  "65"),
          _dateItem(context, "10/09/2025","10"),
        ],
      ),
    );
  }

  Widget _monthHeader(
      BuildContext context, {
        required String title,
        required String total,
      }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.SIZE_15,
        vertical: Constant.SIZE_10,
      ),
      color: Constant.lightblueS,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.layers_outlined,
                size: Constant.SIZE_18,
                color: theme.iconTheme.color,
              ),
              SizedBox(width: Constant.SIZE_06),
              Text(
                total,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _dateItem(
      BuildContext context,
      String date,
      String value,
      ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Constant.SIZE_15,
            vertical: Constant.CONTAINER_SIZE_16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding:EdgeInsets.only(left: Constant.SIZE_08, right: Constant.SIZE_08),
          child: Divider(
            height: 0,
            color: Colors.grey.shade700,
          ),
        )
      ],
    );
  }
}
