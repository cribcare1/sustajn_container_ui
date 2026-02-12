import 'package:sustajn_restaurant/auth/screens/terms_and_condition_screen.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';

import '../../constants/imports_util.dart';
import '../../models/get_profile_data.dart';
import '../model/plan_model.dart';

class SubscriptionDetailsScreen extends StatefulWidget {
  final PlanModel? planModel;
  final SubscriptionResponse? subscriptionResponse;
  final String previousScreen;
  const SubscriptionDetailsScreen({super.key,  this.planModel,this.subscriptionResponse, this.previousScreen = ""});

  @override
  State<SubscriptionDetailsScreen> createState() => _SubscriptionDetailsScreenState();
}

class _SubscriptionDetailsScreenState extends State<SubscriptionDetailsScreen> {

  var data;

  @override
  void initState() {
    _getData();
    super.initState();
  }
  _getData(){
    if(widget.subscriptionResponse != null && widget.previousScreen =="profile"){
      data = widget.subscriptionResponse;
    }else if(widget.planModel != null && widget.previousScreen ==""){
      data = widget.planModel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Plan Details",
          leading: CustomBackButton(),
        ).getAppBar(context),
        body: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _freemiumCard(theme),
              SizedBox(height: Constant.CONTAINER_SIZE_24),
              if(widget.previousScreen =="profile")...[
                Text(data?.description ?? "",style: theme.textTheme.titleSmall!.copyWith(color: Colors.white),),
              ],
              if(widget.previousScreen =="")...[
                Expanded(
                  child: SingleChildScrollView(child: _featureList(theme)),
                ),
                SizedBox(height: Constant.CONTAINER_SIZE_16),
                SizedBox(
                  width: double.infinity,
                  child: SubmitButton(
                    onRightTap: () => NavUtil.navigateToPushScreen(
                      context,
                      TermsAndConditionScreen(),
                    ),
                    rightText: "Proceed to Terms & Conditions",
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _freemiumCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_24),
        border: Border.all(color: Constant.gold),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A4D2E), Color(0xFF052F1E)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         Text(data?.planName ?? "",style: theme.textTheme.titleMedium!.copyWith(color: Colors.white),),
          SizedBox(height: Constant.SIZE_10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset("assets/logo/dirham_icon.png"),
              Text(
                " ${data?.totalContainers ?? 0}",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Constant.gold,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _featureList(ThemeData theme) {
    return Column(
      children: widget.planModel!.features
          .map((e) => _featureItem(theme, e))
          .toList(growable: false),
    );
  }

  Widget _featureItem(ThemeData theme, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: Constant.CONTAINER_SIZE_22,
            width: Constant.CONTAINER_SIZE_22,
            decoration: BoxDecoration(
              color: Constant.gold,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: theme.primaryColor,
              size: Constant.SIZE_15,
            ),
          ),
          SizedBox(width: Constant.SIZE_10),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
