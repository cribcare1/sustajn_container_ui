import 'package:flutter/material.dart';
import '../../constants/number_constants.dart';

class FeedbackBottomSheet extends StatefulWidget {
  const FeedbackBottomSheet({Key? key}) : super(key: key);

  @override
  State<FeedbackBottomSheet> createState() => _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  int _selectedIndex = -1;

  final List<Map<String, String>> feedbackOptions = [
    {'emoji': '😡', 'label': 'Frustrated'},
    {'emoji': '😕', 'label': 'Disappointed'},
    {'emoji': '😐', 'label': 'Okay'},
    {'emoji': '🙂', 'label': 'Satisfied'},
    {'emoji': '😍', 'label': 'Great'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Constant.CONTAINER_SIZE_16),
              topRight: Radius.circular(Constant.CONTAINER_SIZE_16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Feedback',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: Constant.LABEL_TEXT_SIZE_18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      size: Constant.CONTAINER_SIZE_20,
                      color: Colors.white,
                    ),
                  )
                ],
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  feedbackOptions.length,
                      (index) => Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedIndex = index);
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(
                              Constant.CONTAINER_SIZE_10,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selectedIndex == index
                                  ? Colors.white.withOpacity(0.15)
                                  : Colors.white.withOpacity(0.1),
                            ),
                            child: Text(
                              feedbackOptions[index]['emoji']!,
                              style: TextStyle(
                                fontSize: Constant.LABEL_TEXT_SIZE_24,
                              ),
                            ),
                          ),
                          SizedBox(height: Constant.SIZE_05),
                          Text(
                            feedbackOptions[index]['label']!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: Constant.CONTAINER_SIZE_12,
                              color: Colors.white
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_20),

              Flexible(
                child: TextFormField(
                  controller: _controller,
                  maxLines: Constant.MAX_LINE_5,
                  style: TextStyle(color: Colors.white70),
                  maxLength: Constant.CONATAINER_SIZE_255.toInt(),
                  decoration: InputDecoration(
                    hintText: 'Your Comment',
                    fillColor: theme.primaryColor,
                    filled: true,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                    contentPadding: EdgeInsets.all(
                      Constant.CONTAINER_SIZE_14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_12),

                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                      borderSide: BorderSide(
                        color: Constant.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                      borderSide: BorderSide(
                        color: Constant.grey,
                      ),
                    ),
                    counterText:
                    '${_controller.text.length}/${Constant.CONTAINER_SIZE_500.toInt()}',
                    counterStyle: TextStyle(color: Colors.white70)
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC8B531),
                    padding: EdgeInsets.symmetric(
                      vertical: Constant.CONTAINER_SIZE_14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                    ),
                  ),
                  child: Text(
                    'Send Feedback',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
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
}
