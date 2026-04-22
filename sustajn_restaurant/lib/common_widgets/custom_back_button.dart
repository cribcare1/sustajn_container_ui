import '../constants/imports_util.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const CustomBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          Navigator.pop(context);
        }
      },
      child: Icon(Icons.keyboard_arrow_left, color: Colors.white70),
    );
  }
}
