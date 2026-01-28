import '../constants/imports_util.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Container(
      padding:  EdgeInsets.fromLTRB(Constant.CONTAINER_SIZE_16,Constant.CONTAINER_SIZE_16, Constant.CONTAINER_SIZE_16,Constant.CONTAINER_SIZE_24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3B2E), // dark green
        borderRadius: BorderRadius.vertical(
          top: Radius.circular( Constant.CONTAINER_SIZE_24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.EXTEND_LEASE,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: Constant.CONTAINER_SIZE_20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: CircleAvatar(
                    radius: Constant.CONTAINER_SIZE_16,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.close, color: Colors.white, size: Constant.CONTAINER_SIZE_18),
                  ),
                ),
              ],
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_20),

            Container(
              padding:  EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DateRow(
                      title: 'Current Due Date',
                      value: '03.01.2026',
                  ),
                   Divider(color: Colors.white24, height: Constant.CONTAINER_SIZE_24),
                  _DateRow(title: 'New Due Date', value: '08.01.2026'),
                ],
              ),
            ),

             SizedBox(height: Constant.CONTAINER_SIZE_24),

            Text(
              Strings.PRODUCTS,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),

             SizedBox(height: Constant.CONTAINER_SIZE_12),

            _ProductTile(
              image: 'assets/images/dip_cup.png',
              title: 'Dip Cup',
              code: 'ST-DC-50',
              size: '50ml',
              qty: 1,
            ),

             SizedBox(height: Constant.CONTAINER_SIZE_12),

            _ProductTile(
              image: 'assets/images/round_container.png',
              title: 'Round Containers',
              code: 'ST-RDC-1000',
              size: '50ml',
              qty: 2,
            ),

             SizedBox(height: Constant.CONTAINER_SIZE_24),

            SizedBox(
              width: double.infinity,
              height: Constant.CONTAINER_SIZE_50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37), // gold
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_30),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  Strings.PAY_AED,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: Constant.CONTAINER_SIZE_16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _DateRow extends StatelessWidget {
  final String title;
  final String value;

  const _DateRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(color: Colors.white70, fontSize: Constant.CONTAINER_SIZE_13)),
        SizedBox(height: Constant.CONTAINER_SIZE_4),
        Text(value,
            style: TextStyle(
                color: Colors.white,
                fontSize: Constant.CONTAINER_SIZE_18,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ProductTile extends StatelessWidget {
  final String image;
  final String title;
  final String code;
  final String size;
  final int qty;

  const _ProductTile({
  required this.image,
  required this.title,
  required this.code,
  required this.size,
  required this.qty,
});

@override
Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.08),
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
      border: Border.all(color: Colors.white24),
    ),
    child: Row(
      children: [
        Container(
          height: Constant.CONTAINER_SIZE_50,
          width: Constant.CONTAINER_SIZE_50,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
          ),
          child: Image.asset(image, fit: BoxFit.contain),
        ),
        SizedBox(width: Constant.CONTAINER_SIZE_12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              Text(code,
                  style:
                  TextStyle(color: Colors.white70, fontSize: Constant.CONTAINER_SIZE_12)),
              Text(size,
                  style:
                  TextStyle(color: Colors.white70, fontSize: Constant.CONTAINER_SIZE_12)),
            ],
          ),
        ),
        Text(
          qty.toString(),
          style: TextStyle(
              color: const Color(0xFFD4AF37),
              fontSize: Constant.CONTAINER_SIZE_16,
              fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}
}

