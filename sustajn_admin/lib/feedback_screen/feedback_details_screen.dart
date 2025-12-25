import 'package:container_tracking/common_widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:container_tracking/common_widgets/custom_app_bar.dart';
import 'package:container_tracking/common_widgets/custom_back_button.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../utils/theme_utils.dart';
import '../utils/utility.dart';
import 'model/feedback_details_model.dart';


class FeedbackDetailsScreen extends StatelessWidget {
  final FeedbackModel data;

   const FeedbackDetailsScreen({
    super.key, required this.data

  });


  String? _badgeText() {
    switch (data.status) {
      case FeedbackStatus.newUnread:
        return null;
      case FeedbackStatus.inProgress:
        return Strings.STATUS_INPROGRESS;
      case FeedbackStatus.resolved:
        return Strings.STATUS_RESOLVED;
      case FeedbackStatus.rejected:
        return Strings.STATUS_REJECTED;
    }
  }

  String? _remarksTitle() {
    switch (data.status) {
      case FeedbackStatus.newUnread:
        return null;
      case FeedbackStatus.inProgress:
        return Strings.ACK_REMARKS;
      case FeedbackStatus.resolved:
        return Strings.RESOLVED_REMARKS;
      case FeedbackStatus.rejected:
        return Strings.REJECTED_RAMARKS;
    }
  }

  bool get _showBottomButtons =>
      data.status == FeedbackStatus.newUnread ||
          data.status == FeedbackStatus.inProgress;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeText = _badgeText();
    final badgeColor = CustomTheme.badgeColor(context, data.status);
    final remarksTitle = _remarksTitle();

    return SafeArea(
      top: false,bottom: true,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: Strings.FEEDBACK_DETAILS,
          leading: const CustomBackButton(),
        ).getAppBar(context),

        body: SingleChildScrollView(
          padding: EdgeInsets.all(Constant.PADDING_HEIGHT_10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (badgeText != null && badgeColor != null)
                Align(
                  alignment: Alignment.center,
                  child: GlassSummaryCard(
                    child: Text(
                      badgeText,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              SizedBox(height: Constant.PADDING_HEIGHT_10),
              GlassSummaryCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: Constant.CONTAINER_SIZE_30 / 2,
                      backgroundColor: theme.colorScheme.primary.withOpacity(
                        0.1,
                      ),
                    ),
                    SizedBox(width: Constant.CONTAINER_SIZE_16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.name, style: theme.textTheme.titleMedium),
                          SizedBox(height: Constant.SIZE_05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _infoColumn(theme, Strings.REPORT_ID, data.reportId),
                              _infoColumn(theme, Strings.DATE_TIME, data.dateTime),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_15),
              _whiteCard(
                context,
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Strings.SUBJECT, style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: Constant.SIZE_10,),
                    Text('High-quality leak-proof stainless steel lunch '
                        'box with multiple compartments. Durable, reusable, and '
                        'perfect for office or school meals.', style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_15),
              _whiteCard(
                context,
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Strings.DESCRIPTION,  style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ), ),
                    SizedBox(height: Constant.SIZE_10,),
                    Text('Lightweight yet strong, this reusable cotton tote '
                        'bag is perfect for groceries, books, and everyday essentials. '
                        'Made from 100% organic cotton and machine washable for '
                        'long-term use.', style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_15),

              _whiteCard(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      Strings.IMAGES,
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: Constant.SIZE_06),

                    Column(
                      children: [
                        "image_01.png",
                        "image_02.jpg",
                        "product_photo.png",
                        "banner_sample.jpg",
                      ]
                          .map(
                            (img) => Padding(
                          padding: EdgeInsets.only(bottom: Constant.SIZE_10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.image,
                                size: Constant.CONTAINER_SIZE_20,
                                color: theme.primaryColor,
                              ),
                              SizedBox(width: Constant.CONTAINER_SIZE_12),
                              Expanded(
                                child: Text(
                                  img,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ],
                ),
              ),


              SizedBox(height: Constant.CONTAINER_SIZE_15),

              if (remarksTitle != null) ...[
                SizedBox(height: Constant.CONTAINER_SIZE_15),
                Text(remarksTitle, style: theme.textTheme.titleMedium),
                _whiteCard(
                  context,
                  child: Text(data.remarks, style: theme.textTheme.bodyMedium),
                ),
              ],

              SizedBox(
                height: _showBottomButtons
                    ? Constant.CONTAINER_SIZE_100
                    : Constant.CONTAINER_SIZE_30,
              ),
            ],
          ),
        ),

        bottomSheet: _showBottomButtons
            ? Container(
          height: Constant.CONTAINER_SIZE_100,
          padding: EdgeInsets.symmetric(horizontal: Constant.PADDING_HEIGHT_10),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: Constant.SIZE_05,
              ),
            ],
          ),
          child: _buildBottomButtons(context),
        )
            : const SizedBox.shrink(),

      ),
    );
  }

  Widget _infoColumn(ThemeData theme, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.bodySmall),
        Text(value, style: theme.textTheme.titleSmall!.copyWith(
    fontWeight: FontWeight.bold,)),
      ],
    );
  }

  Widget _whiteCard(
    BuildContext context, {
    required Widget child,
  }) {
    final _ = Theme.of(context);
    return GlassSummaryCard(
      child: child,
    );
  }



  Widget _buildBottomButtons(BuildContext context) {
    final theme = Theme.of(context);
    if (!_showBottomButtons) return SizedBox.shrink();
    if (data.status == FeedbackStatus.newUnread) {
      return Row(
        children: [

          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Utils.displayDialog(context, Icons.delete_outline_outlined, Strings.REJECT_FEEDBACK, Strings.REJECT_DIALOG_TXT, Strings.REJECT_BUTTON);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: Constant.CONTAINER_SIZE_18,
                ),
              ),
              child: Text(
                Strings.REJECT_BUTTON,
                style: theme.textTheme.labelLarge?.copyWith(color: Colors.red),
              ),
            ),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Utils.displayDialog(context, Icons.done,Strings.ACK_TITLE,Strings.ACK_DIALOG_TXT,Strings.APPROVE_TXT);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC8B531),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                ),
                padding: EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_18),
              ),
              child: Text(
                Strings.ACKNOWLEDGEMENT_TXT,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      );
    }


    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Utils.displayDialog(context, Icons.delete_outline_outlined, Strings.REJECT_FEEDBACK, Strings.REJECT_DIALOG_TXT, Strings.REJECT_BUTTON);
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
              ),
              padding: EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_18),
            ),
            child: Text(
              Strings.REJECT_BUTTON,
              style: theme.textTheme.labelLarge?.copyWith(color: Colors.red),
            ),
          ),
        ),
        SizedBox(width: Constant.CONTAINER_SIZE_12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Utils.displayDialog(context, Icons.download_done, Strings.RESOLVE_FEEDBACK,Strings.RESOLVE_DIALOG_TXT, Strings.RESOLVE_BUTTON);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC8B531),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
              ),
              padding: EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_18),
            ),
            child: Text(
              Strings.RESOLVE_BUTTON,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }




}
