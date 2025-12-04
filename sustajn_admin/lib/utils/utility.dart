import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../feedback_screen/model/feedback_details_model.dart';

class Utils {
  static Future<void> showEditDeleteMenu({
    required BuildContext context,
    required GlobalKey iconKey,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) async {
    final RenderBox renderBox = iconKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    await showMenu<void>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx + size.width - 150,
        position.dy + size.height,
        position.dx,
        0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
      ),
      elevation: 4,
      items: <PopupMenuEntry<void>>[
        PopupMenuItem<void>(
          height: Constant.CONTAINER_SIZE_40,
          padding:  EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12),
          child: Row(
            children:  [
              Icon(Icons.edit, size: Constant.LABEL_TEXT_SIZE_18),
              SizedBox(width: Constant.SIZE_10),
              Text(Strings.EDIT),
            ],
          ),
          onTap: onEdit,
        ),
        const PopupMenuDivider(),
        PopupMenuItem<void>(
          height: Constant.CONTAINER_SIZE_40,
          padding:  EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12),
          child: Row(
            children:  [
              Icon(Icons.delete, size: Constant.CONTAINER_SIZE_18, color: Colors.red),
              SizedBox(width: Constant.SIZE_10),
              Text(Strings.DELETE, style: TextStyle(color: Colors.red)),
            ],
          ),
          onTap: onDelete,
        ),
      ],
    );
  }



  static displayDialog(BuildContext context, IconData icon,String title, String subTitle, String buttonText) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: Constant.PADDING_HEIGHT_10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
        ),
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: Constant.CONTAINER_SIZE_40,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Text(title, style: theme.textTheme.titleMedium),
              SizedBox(height: Constant.SIZE_05),
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Remarks*",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      Constant.CONTAINER_SIZE_12,
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: Color(0xFFC8B531)
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_12,
                          ),
                        ),
                      ),
                      child: Text("Cancel",  style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.primaryColor,
                      ),),
                    ),
                  ),
                  SizedBox(width: Constant.CONTAINER_SIZE_12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_12,
                          ),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
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



}
