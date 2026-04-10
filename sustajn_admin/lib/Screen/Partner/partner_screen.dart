import 'package:container_tracking/Screen/Partner/partner_details_screen.dart';
import 'package:container_tracking/common_widgets/custom_app_bar.dart';
import 'package:container_tracking/common_widgets/custom_back_button.dart';
import 'package:container_tracking/constants/imports.util.dart';

import '../../common_widgets/card_widget.dart';
import '../../common_widgets/custom_search_bar.dart';
import '../../common_widgets/filter_screen.dart';
import '../../constants/network_urls.dart';
import '../../utils/theme_utils.dart';

class PartnerModel {
  final String name;
  final String address;
  final String image;

  PartnerModel({
    required this.name,
    required this.address,
    required this.image,
  });
}

class PartnerScreen extends StatefulWidget {
  const PartnerScreen({super.key});

  @override
  State<PartnerScreen> createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerScreen> {
  final List<PartnerModel> items = [
    PartnerModel(
      name: "Hari Plaza",
      address: "Balasore, Odisha, 234520",
      image: "assets/images/resturant.jpeg",
    ),
    PartnerModel(
      name: "Hotel Swad",
      address: "Gunjur, Karnatak, 327676",
      image: "assets/images/resturant.jpeg",
    ),
    PartnerModel(
      name: "Pet Puja",
      address: "Jaipur, Rajasthan, 886733",
      image: "assets/images/resturant.jpeg",
    ),
    PartnerModel(
      name: "Hotel NH View",
      address: "Bhubaneswar, Odisha, 544323",
      image: "assets/images/resturant.jpeg",
    ),
    PartnerModel(
      name: "The Fresh",
      address: "Marthalli, Karnatak, 763764",
      image: "assets/images/resturant.jpeg",
    ),
    PartnerModel(
      name: "Hotel Royal",
      address: "Ameerpet, Hyderabad, Telengana, 767656",
      image: "assets/images/resturant.jpeg",
    ),
  ];

  List<PartnerModel> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = items;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(true);
    return Scaffold(
      appBar: CustomAppBar(
        title: "Partner",
        leading: CustomBackButton(),
      ).getAppBar(context),

      body: Column(
        children: [
          CustomSearchBar(
            hintText: "Search by Partner Name",
            onChanged: (value) {
              setState(() {
                filteredItems = items.where((item) {
                  return item.name.toLowerCase().contains(value.toLowerCase());
                }).toList();
              });
            },
            onFilterTap: () async {
              // filter logic
            },
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_16),
          Expanded(
            child: ListView.separated(
              itemCount: filteredItems.length,
              separatorBuilder: (context, index) =>
                  SizedBox(height: Constant.CONTAINER_SIZE_12),
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return _containerTile(item, themeData!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _containerTile(PartnerModel item, ThemeData themeData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PartnerDetailsScreen(name: item.name, address: item.address),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12),
        child: GlassSummaryCard(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    Constant.CONTAINER_SIZE_12,
                  ),
                  border: Border.all(color: Colors.white),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    Constant.CONTAINER_SIZE_12,
                  ),
                  child: Image.asset(
                    item.image,
                    width: Constant.CONTAINER_SIZE_50,
                    height: Constant.CONTAINER_SIZE_50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: Constant.CONTAINER_SIZE_14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      overflow: TextOverflow.ellipsis,
                      style: themeData.textTheme.titleMedium,
                    ),
                    SizedBox(height: Constant.SIZE_04),
                    Text(item.address, style: themeData.textTheme.titleSmall),
                  ],
                ),
              ),
              SizedBox(width: Constant.SIZE_10),
              Icon(
                Icons.arrow_forward_ios,
                size: Constant.CONTAINER_SIZE_16,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
