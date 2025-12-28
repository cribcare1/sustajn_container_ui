import '../../constants/imports_util.dart';
import '../../constants/number_constants.dart';

class FreemiumBottomSheet extends StatelessWidget {
  const FreemiumBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(context),
            SizedBox(height: Constant.CONTAINER_SIZE_20),

            Flexible(
              child: SingleChildScrollView(
                child: _freemiumCard(theme),
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_20),
            _upgradeButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: Icon(
          Icons.close,
          color: Colors.white,
          size: Constant.CONTAINER_SIZE_24,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _freemiumCard(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(Constant.SIZE_03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_24),
        border: Border.all(
          color: Constant.grey.withOpacity(0.5), // OUTER BORDER
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
          border: Border.all(
            color: Constant.gold, // INNER BORDER
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor.withOpacity(0.9),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Column(
          children: [
            _iconSection(theme),
            SizedBox(height: Constant.CONTAINER_SIZE_12),
            _priceSection(theme),
            SizedBox(height: Constant.CONTAINER_SIZE_20),
            _featureList(theme),
            SizedBox(height: Constant.CONTAINER_SIZE_20),
            _learnMoreButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _iconSection(ThemeData theme) {
    return Column(
      children: [
        Icon(
          Icons.percent,
          color: Colors.white,
          size: Constant.CONTAINER_SIZE_40,
        ),
        SizedBox(height: Constant.SIZE_10),
        Text(
          'Freemium',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _priceSection(ThemeData theme) {
    return Text(
      '₹ 0.00',
      style: theme.textTheme.headlineMedium?.copyWith(
        color: Constant.gold,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _featureList(ThemeData theme) {
    return Column(
      children: [
        _featureItem(theme,
            'Lorem ipsum dolor sit amet consectetur.\nVel ac nunc tempus ornare neque odio massa in quis.'),
        _featureItem(theme,
            'Lorem ipsum dolor sit amet consectetur.'),
        _featureItem(theme,
            'Lorem ipsum dolor sit amet consectetur.'),
      ],
    );
  }

  Widget _featureItem(ThemeData theme, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: Constant.SIZE_10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: Constant.gold,
            size: Constant.CONTAINER_SIZE_20,
          ),
          SizedBox(width: Constant.SIZE_10),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _learnMoreButton(ThemeData theme) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Constant.gold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
        ),
        padding: EdgeInsets.symmetric(
          vertical: Constant.SIZE_10,
          horizontal: Constant.CONTAINER_SIZE_30,
        ),
      ),
      child: Text(
        'Learn More',
        style: theme.textTheme.labelLarge?.copyWith(
          color: Constant.gold,
        ),
      ),
    );
  }

  Widget _upgradeButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Constant.gold,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          ),
          padding: EdgeInsets.symmetric(
            vertical: Constant.CONTAINER_SIZE_14,
          ),
        ),
        child: Text(
          'Upgrade',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.primaryColor,
          ),
        ),
      ),
    );
  }

}
