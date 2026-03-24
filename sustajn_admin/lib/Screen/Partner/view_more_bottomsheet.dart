import 'package:container_tracking/constants/imports.util.dart';

import '../../utils/utility.dart';

class PartnerDetailsSheet extends StatelessWidget {
  const PartnerDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Padding(
          padding: EdgeInsets.all(Constant.SIZE_08),
          child: Column(
            children: [
              Utils.buildFloatingHeader(context),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF0E3B2E),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(Constant.CONTAINER_SIZE_24)),
                  ),
                  child: SafeArea(
                    top: false,
                    bottom: true,
                    child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _header(context),
                            SizedBox(height: Constant.SIZE_04),
                            _contactCard(),
                            _planCard(),
                            _paymentCard(),
                            _registrationCard(),
                            _businessCard(),
                            _socialMediaCard()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_14),
      child: Text(
        "More Details",
        style: TextStyle(
          color: Colors.white,
          fontSize: Constant.CONTAINER_SIZE_18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _contactCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Contact Number", style: _titleStyle),
          SizedBox(height: Constant.CONTAINER_SIZE_10),
          Text("Primary Number", style: _subTitleStyle),
          Text("+91 9872536434", style: _valueStyle),
          _divider,
          Text("Secondary Number", style: _subTitleStyle),
          Text("+91 9876243543", style: _valueStyle),
        ],
      ),
    );
  }

  Widget _planCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Plan Type", style: _titleStyle),
          SizedBox(height: Constant.SIZE_08),
          Text("Pay-per-use", style: _valueStyle),
        ],
      ),
    );
  }

  Widget _paymentCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Payment Type", style: _titleStyle),
          SizedBox(height: Constant.SIZE_08),
          Text("Online Payment Gateway", style: _subTitleStyle),
          SizedBox(height: Constant.SIZE_06),
          Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.white),
              SizedBox(width: Constant.SIZE_08),
              Text("karan@okicici", style: _valueStyle),
            ],
          )
        ],
      ),
    );
  }

  Widget _registrationCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Contact & Registration", style: _titleStyle),
          SizedBox(height: Constant.CONTAINER_SIZE_10),
          Text("Contact Person", style: _subTitleStyle),
          SizedBox(height: Constant.SIZE_02),
          Text("John Smith", style: _valueStyle),
          _divider,
          Text("Contact Number", style: _subTitleStyle),
          SizedBox(height: Constant.SIZE_02),
          Text("+91 9282727222", style: _valueStyle),
          _divider,
          Text("Email Registration", style: _subTitleStyle),
          SizedBox(height: Constant.SIZE_02),
          Text("john@email.com", style: _valueStyle),
          _divider,

          Text("Trade License Number", style: _subTitleStyle),
          SizedBox(height: Constant.SIZE_02),
          Text("-", style: _valueStyle),
          _divider,

          Text("Tax Number", style: _subTitleStyle),
          SizedBox(height: Constant.SIZE_02),
          Text("-", style: _valueStyle),
        ],
      ),
    );
  }

  Widget _businessCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Business", style: _titleStyle),
          SizedBox(height: Constant.CONTAINER_SIZE_10),
          Text("Type of Business", style: _subTitleStyle),
          SizedBox(height: Constant.SIZE_02),
          Text("-", style: _valueStyle),
          _divider,
          Text("Website", style: _subTitleStyle),
          SizedBox(height: Constant.SIZE_02),
          Text("-", style: _valueStyle),
        ],
      ),
    );
  }

  Widget _socialMediaCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Social Media", style: _titleStyle),
          SizedBox(height: Constant.CONTAINER_SIZE_12),
          Row(
            children: [
              _socialItem(Icons.camera_alt, "Instagram"),
              SizedBox(width: Constant.CONTAINER_SIZE_10),
              _socialItem(Icons.snapchat, "Snapchat"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _socialItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_10),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
          ),
          child: Icon(icon, color: Colors.white, size: Constant.CONTAINER_SIZE_20),
        ),
        SizedBox(height: Constant.SIZE_06),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: Constant.CONTAINER_SIZE_11,
          ),
        ),
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Padding(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_10),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
        decoration: BoxDecoration(
          color: Color(0xFF124536),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
          border: Border.all(color: Colors.white60),
        ),
        child: child,
      ),
    );
  }

  static final TextStyle _titleStyle = TextStyle(
    color: Colors.white,
    fontSize: Constant.CONTAINER_SIZE_16,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle _subTitleStyle = TextStyle(
    color: Colors.white60,
    fontSize: Constant.CONTAINER_SIZE_12,
  );

 static final TextStyle _valueStyle = TextStyle(
    color: Colors.white,
    fontSize: Constant.CONTAINER_SIZE_13,
  );

 static const _divider = Divider(color: Constant.grey, thickness: 0.5);

}