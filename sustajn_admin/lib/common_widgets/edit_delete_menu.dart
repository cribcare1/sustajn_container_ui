import 'package:flutter/material.dart';
import '../constants/number_constants.dart';

Future<void> showEditDeleteMenu({
  required BuildContext context,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
}) {
  final theme = Theme.of(context);
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return Dialog(
        elevation: 0,
        insetPadding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  onEdit();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Constant.CONTAINER_SIZE_15,
                    horizontal: Constant.CONTAINER_SIZE_20,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: Constant.CONTAINER_SIZE_20,
                        color: theme.colorScheme.onSurface,
                      ),
                      SizedBox(width: Constant.CONTAINER_SIZE_15),
                      Text(
                        "Edit",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: Constant.LABEL_TEXT_SIZE_16,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                height: Constant.SIZE_01,
                width: double.infinity,
                color: theme.dividerColor.withOpacity(0.3),
              ),


              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Constant.CONTAINER_SIZE_15,
                    horizontal: Constant.CONTAINER_SIZE_20,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: Constant.CONTAINER_SIZE_20,
                        color: theme.colorScheme.error,
                      ),
                      SizedBox(width: Constant.CONTAINER_SIZE_15),
                      Text(
                        "Delete",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: Constant.LABEL_TEXT_SIZE_16,
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
