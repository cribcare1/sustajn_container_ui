import 'package:flutter/material.dart';
import '../../constants/number_constants.dart';
import '../../utils/theme_utils.dart';

class FeedbackBottomSheet extends StatefulWidget {
  const FeedbackBottomSheet({super.key});

  @override
  State<FeedbackBottomSheet> createState() => _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  int selectedIndex = -1;
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEmojiRow(context),
                      SizedBox(height: Constant.CONTAINER_SIZE_16),
                      _buildTextField(
                        context,
                        controller: subjectController,
                        hint: 'Subject*',
                        maxLines: 1,
                      ),
                      SizedBox(height: Constant.CONTAINER_SIZE_16),
                      _buildTextField(
                        context,
                        controller: remarksController,
                        hint: 'Your Remarks*',
                        maxLines: 5,
                        showCounter: true,
                      ),
                      SizedBox(height: Constant.CONTAINER_SIZE_20),
                      _buildSubmitButton(context),
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

  // 🔹 Header
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

  // 🔹 Emoji Selection Row
  Widget _buildEmojiRow(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(feedbackOptions.length, (index) {
            final isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  remarksController.text =
                  '${feedbackOptions[index]['label']} ';
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
        ),
      ],
    );
  }

  Widget _buildTextField(
      BuildContext context, {
        required TextEditingController controller,
        required String hint,
        required int maxLines,
        bool showCounter = false,
      }) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      maxLines: maxLines,
      cursorColor: Colors.white,
      maxLength: showCounter ? 500 : null,
      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium
            ?.copyWith(color: Colors.white70),
        counterText: showCounter ? null : '',
        counterStyle: TextStyle(color: Colors.white),
        contentPadding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Constant.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Constant.grey),
        )
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: Constant.CONTAINER_SIZE_48,
      child: ElevatedButton(
        onPressed: () {},
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
}
