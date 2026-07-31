import 'package:flutter/material.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';

class DeleteBottomSheet extends StatefulWidget {
  const DeleteBottomSheet({super.key});

  @override
  State<DeleteBottomSheet> createState() => _DeleteBottomSheetState();
}

class _DeleteBottomSheetState extends State<DeleteBottomSheet> {
  final TextEditingController remarksController = TextEditingController();

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(
        Constant.CONTAINER_SIZE_24,
        Constant.CONTAINER_SIZE_16,
        Constant.CONTAINER_SIZE_24,
        Constant.CONTAINER_SIZE_24,
      ),
      decoration: BoxDecoration(
        color: Constant.green6,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Constant.CONTAINER_SIZE_30)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Constant.CONTAINER_SIZE_42,
              height: Constant.SIZE_05,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_28),

            Container(
              width: Constant.CONTAINER_SIZE_80,
              height: Constant.CONTAINER_SIZE_80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
                border: Border.all(color: Colors.white.withOpacity(.12)),
              ),
              child: Center(child: Image.asset("assets/icons/instruction.png")),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_26),

            Text(
              Strings.DELETE_CONTAINER,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_14),

            Text(
              Strings.DELETE_DES,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
                height: 1.5,
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_24),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: Constant.CONTAINER_SIZE_45,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.amber),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_15),
                        ),
                      ),
                      child: const Text(
                        Strings.CANCEL,
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: Constant.CONTAINER_SIZE_14),

                Expanded(
                  child: SizedBox(
                    height: Constant.CONTAINER_SIZE_45,
                    child: ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constant.gold2,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_15),
                          side: const BorderSide(color: Colors.white),
                        ),
                      ),
                      child: const Text(
                        Strings.DELETE,
                        style: TextStyle(
                          color: Constant.green6,
                          fontWeight: FontWeight.bold,
                        ),
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
}
