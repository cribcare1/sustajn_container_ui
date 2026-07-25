import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/number_constants.dart';
import '../constants/string_utils.dart';

class ContainerPopUpScreen extends ConsumerStatefulWidget {
  final VoidCallback onConfirm;
  const ContainerPopUpScreen({super.key, required this.onConfirm});

  @override
  ConsumerState<ContainerPopUpScreen> createState() =>
      ContainerPopUpScreenState();
}

class ContainerPopUpScreenState extends ConsumerState<ContainerPopUpScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(
        Constant.CONTAINER_SIZE_24,
        Constant.CONTAINER_SIZE_12,
        Constant.CONTAINER_SIZE_24,
        Constant.CONTAINER_SIZE_30,
      ),
      decoration: BoxDecoration(
        color: Constant.backgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Constant.CONTAINER_SIZE_28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Constant.CONTAINER_SIZE_50,
              height: Constant.SIZE_05,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_28),
            Container(
              width: Constant.CONTAINER_SIZE_70,
              height: Constant.CONTAINER_SIZE_70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.04),
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
                border: Border.all(color: Colors.white.withOpacity(.12)),
              ),
              child: Center(
                child: Image.asset(
                  Strings.GOLDEN_BOWL_IMG,
                  width: Constant.CONTAINER_SIZE_42,
                  height: Constant.CONTAINER_SIZE_42,
                ),
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_24),

            Text(
              "Add this container?",
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: Constant.CONTAINER_SIZE_28,
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_16),

            Text(
              "This will add a new container with ID "
              "‘ST-DC-50’ to your inventory. "
              "You can edit or delete it later.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
                height: 1.6,
                fontSize: 16,
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_33),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: Constant.CONTAINER_SIZE_55,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Constant.goldenColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_18,
                          ),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Constant.goldenColor,
                          fontWeight: FontWeight.w600,
                          fontSize: Constant.CONTAINER_SIZE_16,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: Constant.CONTAINER_SIZE_14),

                Expanded(
                  child: SizedBox(
                    height: Constant.CONTAINER_SIZE_55,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constant.goldenColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_18,
                          ),
                        ),
                      ),
                      child: Text(
                        "Add Container",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: Constant.CONTAINER_SIZE_16,
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
