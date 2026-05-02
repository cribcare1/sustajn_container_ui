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
      child: const Icon(Icons.arrow_back_ios, color: Colors.white70),
    );
  }
}
