import '../../constants/imports_util.dart';
import '../../constants/number_constants.dart';

class SoldTab extends StatelessWidget {
   SoldTab({super.key});

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [

              _monthHeader("November-2025",150),

              _soldItemCard(
                date:"20/11/2025 | 10:00pm",
                imagePath:"assets/images/dip_cup.png",
                title:"Dip Cup",
                code:"ST-DC-50",
                qtyText:"50ml",
                qty:2,
                price:"₹100",
              ),

              _soldItemCard(
                date:"20/11/2025 | 10:00pm",
                imagePath:"assets/images/round_container.png",
                title:"Round Container",
                code:"ST-RDC-500",
                qtyText:"50ml",
                qty:2,
                price:"₹150",
              ),

              const SizedBox(height: 8),

              _monthHeader("October-2025",150),

              _soldItemCard(
                date:"20/11/2025 | 10:00pm",
                imagePath:"assets/images/round_container.png",
                title:"Round Container",
                code:"ST-RDC-500",
                qtyText:"50ml",
                qty:1,
                price:"₹150",
              ),
            ],
          ),
        ),
      ],
    );
  }

  _soldItemCard({required String date, required String imagePath, required String title, required String code, required String qtyText, required int qty, required String price}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
          color: Constant.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: Constant.grey.withOpacity(0.2)
          )
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            date,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // const SizedBox(height: 4),

                    Text(
                      code,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),

                    // const SizedBox(height: 2),

                    Text(
                      qtyText,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/images/img.png',
                        height: Constant.CONTAINER_SIZE_16,
                        width: Constant.CONTAINER_SIZE_16,),
                      const SizedBox(width: 4),

                      Text(
                        "$qty",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),


                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _monthHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              Image.asset('assets/images/img.png',
                height: Constant.CONTAINER_SIZE_16,
                width: Constant.CONTAINER_SIZE_16,),
              const SizedBox(width: 6),
              Text(
                "$count",
                style: const TextStyle(color: Colors.white),
              )
            ],
          )
        ],
      ),
    );
  }
}