import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      items: <PopupMenuEntry<void>>[
        PopupMenuItem<void>(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: const [
              Icon(Icons.edit, size: 18),
              SizedBox(width: 10),
              Text("Edit"),
            ],
          ),
          onTap: onEdit,
        ),
        const PopupMenuDivider(),
        PopupMenuItem<void>(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: const [
              Icon(Icons.delete, size: 18, color: Colors.red),
              SizedBox(width: 10),
              Text("Delete", style: TextStyle(color: Colors.red)),
            ],
          ),
          onTap: onDelete,
        ),
      ],
    );
  }
}
