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
      child: Container(
        width: Constant.CONTAINER_SIZE_25,
        height: Constant.CONTAINER_SIZE_25,
        margin: EdgeInsets.all(Constant.SIZE_10),
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_100),
          border: Border.all(color: Constant.grey, width: 0.3),
        ),
        child: Icon(Icons.keyboard_arrow_left, color: Colors.white70),
      ),
    );
  }
}
