import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import '../../../constants/number_constants.dart';

class ReportDetailsScreen extends StatelessWidget {
  final String status;
  final Color statusColor;
  const ReportDetailsScreen({super.key,
  required this.status,
  required this.statusColor});


  String? _getRemarksTitle() {
    switch (status.toLowerCase()) {
      case 'in progress':
        return 'Acknowledgement Remarks';
      case 'resolved':
        return 'Resolved Remarks';
      case 'rejected':
        return 'Rejected Remarks';
      default:
        return null;
    }
  }

  String? _getSecondaryDateLabel() {
    switch (status.toLowerCase()) {
      case 'in progress':
      case 'resolved':
        return 'Acknowledgement Date';
      case 'rejected':
        return 'Rejected Date';
      default:
        return null;
    }
  }

  bool _shouldShowStatusBadge() {
    return status.toLowerCase() != 'new';
  }

  List<Widget> _buildMenuButton(){
    if(status == 'New'){
      return [
        IconButton(onPressed: (){},
            icon: Icon(Icons.more_vert, color: Colors.white,))
      ];
    }
    return [];

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: 'Report Details',
          action:
            _buildMenuButton(),
          leading: CustomBackButton()).getAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cardContainer(
                  theme,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Basic Info',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                              ),
                            ),
                          ),

                          if (_shouldShowStatusBadge())
                            _statusBadge(theme),
                        ],
                      ),
                      SizedBox(height: Constant.CONTAINER_SIZE_12),

                      Text(
                        'Subject',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white
                        ),
                      ),
                      SizedBox(height: Constant.SIZE_04),
                      Text(
                        'Broken Container',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white
                        ),
                      ),

                      SizedBox(height: Constant.CONTAINER_SIZE_12),

                      Divider(color: Colors.grey),

                      SizedBox(height: Constant.CONTAINER_SIZE_12),

                      Text(
                        'Reported Date',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white
                        ),
                      ),
                      SizedBox(height: Constant.SIZE_04),
                      Text(
                        '28/11/2025',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white
                        ),
                      ),

                      if (_getSecondaryDateLabel() != null) ...[
                        SizedBox(height: Constant.CONTAINER_SIZE_12),

                        Divider(color:Colors.grey),
                        SizedBox(height: Constant.CONTAINER_SIZE_12),
                        Text(
                          _getSecondaryDateLabel()!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white
                          ),
                        ),
                        SizedBox(height: Constant.SIZE_04),
                        Text(
                          '28/11/2025',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_16),

                _cardContainer(
                  theme,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(theme, 'Description'),

                      SizedBox(height: Constant.CONTAINER_SIZE_12),

                      Text(
                        'Embark on a culinary voyage across India. '
                            'Saffron Sky offers a vibrant tapestry of regional dishes, '
                            'from the rich butter chicken of the North to the coconut-infused '
                            'curries of the South. Our aromatic biryanis are cooked in '
                            'sealed pots, and our tandoori specialties are marinated '
                            'for 24 hours. The colorful, inviting decor and attentive '
                            'service make every meal a celebration',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_16),

                _cardContainer(
                  theme,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(theme, 'Images'),

                      SizedBox(height: Constant.CONTAINER_SIZE_12),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: Constant.MAX_LINE_4,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: Constant.CONTAINER_SIZE_10),
                        itemBuilder: (context, index) {
                          return _imageItem(theme);
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_16,),
                if (_getRemarksTitle() != null) ...[
                  _cardContainer(
                    theme,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(theme, _getRemarksTitle()!),

                        SizedBox(height: Constant.CONTAINER_SIZE_12),

                        Text(
                          'Embark on a culinary voyage across India. '
                        'Saffron Sky offers a vibrant tapestry of regional dishes, '
                          'from the rich butter chicken of the North to the coconut-infused '
                          'curries of the South. Our aromatic biryanis are cooked in '
                          'sealed pots, and our tandoori specialties are marinated '
                          'for 24 hours. The colorful, inviting decor and attentive '
                        'service make every meal a celebration',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: Constant.CONTAINER_SIZE_16),
                ]

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardContainer(ThemeData theme, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: Constant.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
      ),
      child: child,
    );
  }

  Widget _sectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.white
      ),
    );
  }

  Widget _imageItem(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Constant.CONTAINER_SIZE_12,
        horizontal: Constant.CONTAINER_SIZE_14,
      ),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.image_outlined,
            size: Constant.CONTAINER_SIZE_22,
            color: Colors.white,
          ),
          SizedBox(width: Constant.CONTAINER_SIZE_12),
          Expanded(
            child: Text(
              'Container image.jpg',
              maxLines: Constant.MAX_LINE_1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_12,
        vertical: Constant.SIZE_04,
      ),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(Constant.SIZE_085),
        borderRadius: BorderRadius.circular(Constant.SIZE_08),
      ),
      child: Text(
        status,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: Constant.CONTAINER_SIZE_12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

}
