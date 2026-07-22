import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/number_constants.dart';
import '../constants/string_utils.dart';

class ContainerDetailedScreen extends ConsumerStatefulWidget {
  const ContainerDetailedScreen({super.key});

  @override
  ConsumerState<ContainerDetailedScreen> createState() => _ContainerDetailedScreenState();
}
class _ContainerDetailedScreenState extends ConsumerState<ContainerDetailedScreen> {
  // TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const bg = Constant.PrimaryColor;
    const gold = Constant.PrimaryAssentColor;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(Strings.CONTAINER_DETAILS),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
              decoration: BoxDecoration(
                color: const Color(0xFF146C43),
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_18),
                border: Border.all(color: gold),
              ),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/no_image_container.png",
                    height: 90,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.inventory_2,size:90,color:Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Text("Dip Cup",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const Text("ST-DC-50",
                      style: TextStyle(color: Colors.white70)),
                  const Text("50ml",
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 6),
                  Text("View More Details",
                      style: TextStyle(color: gold,fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.25,
              children: const [
                _Summary("Ordered","3,000",false),
                _Summary("Issued to Partner","2,200",true),
                _Summary("In Circulation","400",true),
                _Summary("With Partner","1,500",true),
                _Summary("Sold","90",true),
                _Summary("Damaged","10",true),
                _Summary("In-Stock","1,100",false),
                _Summary("Returned","100",true),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final String title;
  final String value;
  final bool arrow;
  const _Summary(this.title,this.value,this.arrow);

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD8B236);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              children:[
                Expanded(child:Text(title,style:const TextStyle(color:Colors.white70,fontSize:12))),
                if(arrow)
                  const CircleAvatar(
                    radius:10,
                    backgroundColor: gold,
                    child: Icon(Icons.arrow_forward,size:12,color:Colors.black),
                  )
              ]
          ),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
