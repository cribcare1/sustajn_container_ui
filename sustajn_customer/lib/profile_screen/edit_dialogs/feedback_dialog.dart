import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_customer/provider/feedback_provider.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utils.dart';

class FeedbackBottomSheet extends ConsumerStatefulWidget {
  final int userId;
  const FeedbackBottomSheet({super.key, required this.userId});

  @override
  ConsumerState<FeedbackBottomSheet> createState() =>
      _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState
    extends ConsumerState<FeedbackBottomSheet> {
  int selectedIndex = -1;
  final TextEditingController subjectController =
  TextEditingController();
  final TextEditingController remarksController =
  TextEditingController();

  final List<Map<String, String>> feedbackOptions = [
    {'label': 'Frustrated', 'emoji': '😡'},
    {'label': 'Disappointed', 'emoji': '😔'},
    {'label': 'Satisfied', 'emoji': '😐'},
    {'label': 'Happy', 'emoji': '😊'},
    {'label': 'Excellent', 'emoji': '😍'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final feedbackState = ref.watch(feedbackNotifier); // 👈 WATCH LOADING

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Constant.CONTAINER_SIZE_20),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              Flexible(
                child: SingleChildScrollView(
                  padding:
                  EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEmojiRow(context),
                      SizedBox(
                          height: Constant.CONTAINER_SIZE_16),
                      _buildTextField(
                        context,
                        controller: subjectController,
                        hint: 'Subject*',
                        maxLines: 1,
                        enabled: !feedbackState.isLoading,
                      ),
                      SizedBox(
                          height: Constant.CONTAINER_SIZE_16),
                      _buildTextField(
                        context,
                        controller: remarksController,
                        hint: 'Your Remarks*',
                        maxLines: 5,
                        showCounter: true,
                        enabled: !feedbackState.isLoading,
                      ),
                      SizedBox(
                          height: Constant.CONTAINER_SIZE_20),

                      feedbackState.isLoading
                          ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                          : _buildSubmitButton(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.CONTAINER_SIZE_12,
      ),
      child: Row(
        children: [
          Text(
            'Feedback',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(Constant.SIZE_06),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.cardColor,
              ),
              child: Icon(
                Icons.close,
                size: Constant.SIZE_18,
                color: theme.iconTheme.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiRow(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = ref.watch(feedbackNotifier).isLoading;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(feedbackOptions.length, (index) {
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: isLoading
              ? null
              : () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Column(
            children: [
              Container(
                width: Constant.CONTAINER_SIZE_44,
                height: Constant.CONTAINER_SIZE_44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.1),
                ),
                alignment: Alignment.center,
                child: Text(
                  feedbackOptions[index]['emoji']!,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              SizedBox(height: Constant.SIZE_04),
              Text(
                feedbackOptions[index]['label']!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontSize: Constant.CONTAINER_SIZE_10,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField(
      BuildContext context, {
        required TextEditingController controller,
        required String hint,
        required int maxLines,
        bool showCounter = false,
        bool enabled = true,
      }) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: showCounter ? 500 : null,
      enabled: enabled,
      cursorColor: Colors.white,
      style:
      theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
        theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
        counterText: showCounter ? null : '',
        counterStyle: const TextStyle(color: Colors.white),
        contentPadding:
        EdgeInsets.all(Constant.CONTAINER_SIZE_12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Constant.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Constant.grey),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
          BorderSide(color: Constant.grey.withOpacity(0.4)),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: Constant.CONTAINER_SIZE_48,
      child: ElevatedButton(
        onPressed: () {
          Utils.printLog("Send Feedback clicked");
          _getNetworkData();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Constant.gold,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(Constant.CONTAINER_SIZE_12),
          ),
        ),
        child: Text(
          'Send Feedback',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.primaryColor,
          ),
        ),
      ),
    );
  }

  Future<void> _getNetworkData() async {
    final feedbackState = ref.read(feedbackNotifier);

    try {
      final isNetworkAvailable =
      await ref.read(networkProvider.notifier).isNetworkAvailable();

      if (isNetworkAvailable) {
        feedbackState.setIsLoading(true);
        feedbackState.setContext(context);

        await ref.read(feedbackProvider({
          "userId": widget.userId,
          "rating": null,
          "subject": subjectController.text,
          "remark": remarksController.text,
        }));

        feedbackState.setIsLoading(false);

        if (!mounted) return;
        Navigator.pop(context);
      } else {
        feedbackState.setIsLoading(false);
        if (!mounted) return;
        showCustomSnackBar(
          context: context,
          message: Strings.NO_INTERNET_CONNECTION,
          color: Colors.red,
        );
      }
    } catch (e) {
      feedbackState.setIsLoading(false);
      Utils.printLog('Error sending feedback: $e');
    } finally {
      if (mounted) FocusScope.of(context).unfocus();
    }
  }
}
