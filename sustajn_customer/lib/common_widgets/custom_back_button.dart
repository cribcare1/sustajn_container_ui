import '../constants/imports_util.dart';
import '../constants/number_constants.dart';

class CustomBackButton extends StatelessWidget {
  final Future<bool> Function()? onBack;

  const CustomBackButton({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () async {
        if (onBack != null) {
          final shouldPop = await onBack!();
          if (shouldPop) {
            Navigator.pop(context);
          }
        } else {
          Navigator.pop(context);
        }
      },
      child: Container(
        width: Constant.CONTAINER_SIZE_30,
        height: Constant.CONTAINER_SIZE_30,
        margin: EdgeInsets.all(Constant.SIZE_08),
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Constant.grey, width: 0.3),
        ),
        child: const Icon(Icons.arrow_back_ios, color: Colors.white70),
      ),
    );
  }
}
