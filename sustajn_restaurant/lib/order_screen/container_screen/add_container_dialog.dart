import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/number_constants.dart';
import '../models/add_container_model.dart';

class AddContainerDialog extends StatefulWidget {
  final ContainerItem item;

  const AddContainerDialog({super.key, required this.item});

  @override
  State<AddContainerDialog> createState() => _AddContainerDialogState();
}

class _AddContainerDialogState extends State<AddContainerDialog> {
  int qty = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Constant.CONTAINER_SIZE_30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Constant.CONTAINER_SIZE_60,
              height: Constant.SIZE_05,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(Constant.SIZE_05),
              ),
            ),
        
            SizedBox(height: Constant.CONTAINER_SIZE_20),
        
            Container(
              width: Constant.CONTAINER_SIZE_90,
              height: Constant.CONTAINER_SIZE_90,
              decoration: BoxDecoration(
                color: Constant.grey.withOpacity(0.2),
                borderRadius:
                BorderRadius.circular(Constant.CONTAINER_SIZE_20),
              ),
              child:
              Image.asset(widget.item.image, fit: BoxFit.contain),
            ),
        
            SizedBox(height: Constant.SIZE_15),
        
            Text(widget.item.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white
                )),
            Text(widget.item.code,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white
                )),
            Text(widget.item.volume,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white
                )),
        
            SizedBox(height: Constant.SIZE_15),
        
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Constant.CONTAINER_SIZE_16,
                  vertical: Constant.SIZE_06),
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(Constant.CONTAINER_SIZE_20),
                border: Border.all(
                    color: Constant.gold),
              ),
              child: Text(
                "Available Quantity: ${widget.item.availableQty}",
                style: theme.textTheme.bodySmall?.copyWith(
                    color: Constant.gold),
              ),
            ),
        
            SizedBox(height: Constant.CONTAINER_SIZE_20),
        
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _qtyButton(
                  icon: Icons.remove,
                  onTap: () {
                    if (qty > 0) {
                      setState(() => qty--);
                    }
                  },
                  theme: theme,
                ),
                SizedBox(width: Constant.CONTAINER_SIZE_20),
                Text(qty.toString(),
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: Colors.white
                    )),
                SizedBox(width: Constant.CONTAINER_SIZE_20),
                _qtyButton(
                  icon: Icons.add,
                  onTap: () {
                    if (qty < widget.item.availableQty) {
                      setState(() => qty++);
                    }
                  },
                  theme: theme,
                ),
              ],
            ),
        
            SizedBox(height: Constant.CONTAINER_SIZE_25),
        
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.amber, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:  EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_12),
                    ),
                    child: const Text("Cancel",
                    style: TextStyle(color: Constant.gold),),
                  ),
                ),
                SizedBox(width: Constant.CONTAINER_SIZE_12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (qty > 0) {
                        Navigator.pop(context, qty);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.gold,
                      disabledBackgroundColor: Constant.gold,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: Constant.CONTAINER_SIZE_12,
                      ),
                      elevation: Constant.SIZE_00,
                    ),
                    child: Text(
                      "Add",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
        
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyButton({
    required IconData icon,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Constant.CONTAINER_SIZE_40,
        height: Constant.CONTAINER_SIZE_40,
        decoration: BoxDecoration(
          color: Constant.white.withOpacity(0.3),
          borderRadius:
          BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        ),
        child: Icon(icon,
        color: Colors.white,),
      ),
    );
  }
}
