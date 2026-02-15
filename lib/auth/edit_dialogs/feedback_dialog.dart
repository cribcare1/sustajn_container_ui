import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';
import '../../constants/number_constants.dart';
import 'package:flutter/services.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/profile_provider.dart';
import '../../utils/utility.dart';

class FeedbackBottomSheet extends ConsumerStatefulWidget {
  const FeedbackBottomSheet({super.key});

  @override
  ConsumerState<FeedbackBottomSheet> createState() => _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends ConsumerState<FeedbackBottomSheet> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  int? selectedFeedbackIndex;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Utils.userId;
  }

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
                  padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEmojiRow(context),
                        SizedBox(height: Constant.CONTAINER_SIZE_16),
                        _buildTextField(
                          context,
                          controller: subjectController,
                          hint: '${Strings.SUBJECT}*',
                          maxLines: 1,
                        ),
                        SizedBox(height: Constant.CONTAINER_SIZE_16),
                        _buildTextField(
                          context,
                          controller: remarksController,
                          hint: '${Strings.YOUR_REMARKS}*',
                          maxLines: 5,
                          showCounter: true,
                          textInputAction: TextInputAction.done
                        ),
                        SizedBox(height: Constant.CONTAINER_SIZE_20),
                        _buildSubmitButton(context),
                      ],
                    ),
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
          Text(Strings.FEEDBACK,
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

  // 🔹 Emoji Selection Row
  Widget _buildEmojiRow(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(feedbackOptions.length, (index) {
            final isSelected = selectedFeedbackIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedFeedbackIndex = index;
                  remarksController.text = "";
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
                      style: TextStyle(fontSize: Constant.CONTAINER_SIZE_22),
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
        ),
      ],
    );
  }

  Widget _buildTextField(
      BuildContext context, {
        required TextEditingController controller,
        required String hint,
        required int maxLines,
        TextInputAction textInputAction = TextInputAction.next,
        bool showCounter = false,
      }) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      maxLines: maxLines,
      cursorColor: Colors.white,
      maxLength: showCounter ? 500 : null,
      textInputAction: textInputAction,
      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium
            ?.copyWith(color: Colors.white70),
        counterText: showCounter ? null : '',
        counterStyle: TextStyle(color: Colors.white),
        contentPadding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
        ),
        enabledBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
          borderSide: BorderSide(color: Constant.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
          borderSide: BorderSide(color: Constant.grey),
        )
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Constant.CONTAINER_SIZE_48,
      child: SubmitButton(
        onRightTap: _isLoading
            ? null
            : () async {
          if (!_formKey.currentState!.validate()) return;

          setState(() => _isLoading = true);
          final success = await _feedbackNetworkCall();
          if (!mounted) return;

          setState(() => _isLoading = false);

          if (success) {
            Utils.showToast(
              '${Strings.FEEDBACK_DETAILS} ${Strings.SUCC_MSG}',
            );
            Navigator.pop(context);
          }
        },
        rightText: Strings.SEND_FEEDBACK,
        isLoading: _isLoading,
      ),
    );
  }


  Map<String, dynamic> getJsonData() {
    final String? selectedLabel = selectedFeedbackIndex != null
        ? feedbackOptions[selectedFeedbackIndex!]['label']
        : null;

    final data = {
      "userId": Utils.userId,
      "rating": selectedLabel,
      "subject": subjectController.text,
      "remark": remarksController.text
    };
    return data;
  }

  _feedbackNetworkCall() async {
    Utils.printLog('feedback Network call');

    final isNetworkAvailable = await ref
        .read(networkProvider.notifier)
        .isNetworkAvailable();

    if (!isNetworkAvailable) {
      Utils.showToast(Strings.NO_INTERNET_CONNECTION);
      return;
    }
    try {
      await ref.read(feedbackProvider(getJsonData()).future);
      Utils.showToast('${Strings.FEEDBACK_DETAILS} ${Strings.SUCC_MSG}');
      Navigator.pop(context);

    } catch (e) {
      Utils.printLog(e.toString());
    }
  }

}
