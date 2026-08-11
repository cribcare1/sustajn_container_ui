import 'package:container_tracking/Screen/Partner/provider/provider/restaurant_list_provider.dart';
import 'package:container_tracking/constants/imports.util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_provider/network_provider.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/utility.dart';

class UsersDetailsSheet extends ConsumerStatefulWidget {
  final int? restaurantId;

  const UsersDetailsSheet({super.key, required this.restaurantId});

  @override
  ConsumerState<UsersDetailsSheet> createState() => _UsersDetailsSheetState();
}

class _UsersDetailsSheetState extends ConsumerState<UsersDetailsSheet> {
  @override
  void initState() {
    super.initState();
    _getRestaurantCall();
  }

  @override
  Widget build(BuildContext context) {
    final restaurantState = ref.watch(restaurantProvider);

    if (restaurantState.restaurantDtlsData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Padding(
          padding: EdgeInsets.all(Constant.SIZE_08),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Constant.PrimaryColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Constant.CONTAINER_SIZE_24),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    bottom: true,
                    child: Column(
                      children: [
                        _header(context),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: controller,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _contactCard(),
                                _planCard(),
                                _paymentCard(),
                                _registrationCard(),
                                _businessCard(),
                                _socialMediaCard(),
                              ],
                            ),
                          ),
                        ),
                      ],
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
        Strings.MORE_DETAILS,
        style: TextStyle(
          color: Constant.white,
          fontSize: Constant.CONTAINER_SIZE_18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _contactCard() {
    final restaurantState = ref.watch(restaurantProvider);
    final String primary =
        restaurantState.restaurantDtlsData!.data!.mobileNumber!;
    final String secondaryNo =
        restaurantState.restaurantDtlsData!.data!.secondaryNumber!;
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Strings.CONTACT_NUMBER, style: _titleStyle),
          SizedBox(height: Constant.CONTAINER_SIZE_10),
          Text(Strings.PRIMARY_NUMBER, style: _subTitleStyle),
          Text('+91 ${primary}'),

          if (secondaryNo != null && secondaryNo.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _divider,
                Text(Strings.SECONDARY_NUMBER, style: _subTitleStyle),
                Text(
                  '+91 ${restaurantState.restaurantDtlsData!.data!.secondaryNumber}',
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _planCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Strings.PLAN_TYPE, style: _titleStyle),
          SizedBox(height: Constant.SIZE_08),
          Text(Strings.PAY_USE, style: _valueStyle),
        ],
      ),
    );
  }

  Widget _paymentCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Strings.PAYMENT_TYPE, style: _titleStyle),
          SizedBox(height: Constant.SIZE_08),
          Text(Strings.ONLINE_PAYMENT_GATEWAY, style: _subTitleStyle),
          SizedBox(height: Constant.SIZE_06),
          Row(
            children: [
              Image.asset(Strings.GOOGLEPAY_IMG),
              SizedBox(width: Constant.SIZE_08),
              Text(Strings.KARANICICI, style: _valueStyle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _registrationCard() {
    final restaurantState = ref.watch(restaurantProvider);
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Strings.CONTACT_REGISTRATION, style: _titleStyle),
          SizedBox(height: Constant.CONTAINER_SIZE_10),
          Text(Strings.CONTACT_PERSON, style: _subTitleStyle),
          SizedBox(height: Constant.SIZE_02),
          Text(Strings.JOHN_SMITH, style: _valueStyle),
          _divider,
          Text(Strings.CONTACT_NUMBER, style: _subTitleStyle),
          SizedBox(height: Constant.SIZE_02),
          Text(
            '+91 ${restaurantState.restaurantDtlsData!.data!.mobileNumber!}',
          ),
          _divider,
          Text(Strings.EMAIL_REGISTRATION, style: _subTitleStyle),
          SizedBox(height: Constant.SIZE_02),
          Text(
            restaurantState
                .restaurantDtlsData!
                .data!
                .contactAndRegistrationDetailsResponse!
                .contactEmail!,
          ),
          _divider,

          Text(Strings.TRADE_LICENSE_NUMBER, style: _subTitleStyle),
          SizedBox(height: Constant.SIZE_02),
          Text(
            restaurantState
                .restaurantDtlsData!
                .data!
                .contactAndRegistrationDetailsResponse!
                .treadLicenseNumber!,
          ),
          _divider,

          Text(Strings.VAT_NUMBER, style: _subTitleStyle),
          SizedBox(height: Constant.SIZE_02),
          Text(
            restaurantState
                .restaurantDtlsData!
                .data!
                .contactAndRegistrationDetailsResponse!
                .vatNumber!,
          ),
        ],
      ),
    );
  }

  Widget _businessCard() {
    final restaurantState = ref.watch(restaurantProvider);
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Strings.BUSINESS, style: _titleStyle),
          SizedBox(height: Constant.CONTAINER_SIZE_10),
          Text(Strings.TYPE_OF_BUSINESS, style: _subTitleStyle),
          SizedBox(height: Constant.SIZE_02),
          Text(
            restaurantState
                .restaurantDtlsData!
                .data!
                .basicRestaurantDetails!
                .businessType!,
          ),
          _divider,
          Text(Strings.WEBSITE, style: _subTitleStyle),
          SizedBox(height: Constant.SIZE_02),
          Text(
            restaurantState
                .restaurantDtlsData!
                .data!
                .basicRestaurantDetails!
                .websiteDetails!,
          ),
        ],
      ),
    );
  }

  Widget _socialMediaCard() {
    final restaurantState = ref.watch(restaurantProvider);
    final socialMediaTypeList =
        restaurantState.restaurantDtlsData!.data!.socialMediaDetailsList ?? [];
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Strings.SOCIAL_MEDIA, style: _titleStyle),
          SizedBox(height: Constant.CONTAINER_SIZE_12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: socialMediaTypeList.map((item) {
                return Padding(
                  padding: EdgeInsets.only(right: Constant.CONTAINER_SIZE_10),
                  child: _socialItem(item.socialMediaType ?? ''),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String getSocialMediaImage(String type) {
    switch (type.toLowerCase()) {
      case Strings.INSTAGRAM:
        return Strings.INSTAGRAM_IMG;

      case Strings.FACEBOOK:
        return Strings.FACEBOOK_IMG;

      case Strings.SNAPCHAT:
        return Strings.SNAPCHAT_IMG;

      default:
        return Strings.INSTAGRAM_IMG;
    }
  }

  Widget _socialItem(String type) {
    final imagePath = getSocialMediaImage(type);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_10),
          decoration: BoxDecoration(
            color: Constant.grey,
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
          ),
          child: Image.asset(
            imagePath,
            width: Constant.CONTAINER_SIZE_20,
            height: Constant.CONTAINER_SIZE_20,
          ),
        ),
        SizedBox(height: Constant.SIZE_06),
        Text(
          type,
          style: TextStyle(
            color: Constant.white3,
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
          color: Constant.PrimaryColor,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
          border: Border.all(color: Constant.grey1),
        ),
        child: child,
      ),
    );
  }

  static final TextStyle _titleStyle = TextStyle(
    color: Constant.white,
    fontSize: Constant.CONTAINER_SIZE_16,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle _subTitleStyle = TextStyle(
    color: Constant.white3,
    fontSize: Constant.CONTAINER_SIZE_12,
  );

  static final TextStyle _valueStyle = TextStyle(
    color: Constant.white,
    fontSize: Constant.CONTAINER_SIZE_13,
  );

  static const _divider = Divider(color: Constant.grey, thickness: 0.5);

  _getRestaurantCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(restaurantProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final url = '${NetworkUrls.RESTAURANT_DETAILS}${widget.restaurantId}';
          ref.read(getRestaurantDtlsProvider(url));
        } else {
          orderState.setIsLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error in network function: $e');
    }
  }
}
