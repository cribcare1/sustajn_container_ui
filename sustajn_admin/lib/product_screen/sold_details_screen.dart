import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../common_widgets/custom_app_bar.dart';
import '../common_widgets/custom_back_button.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';

enum SoldTab { user, partner }

final soldTabProvider = StateProvider<SoldTab>((ref) => SoldTab.user);

class SoldDetailsScreen extends ConsumerStatefulWidget {
  const SoldDetailsScreen({super.key});

  @override
  ConsumerState<SoldDetailsScreen> createState() => _SoldScreenState();
}

class _SoldScreenState extends ConsumerState<SoldDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(soldTabProvider);

    return Scaffold(
      backgroundColor: Constant.PrimaryColor,

      appBar: CustomAppBar(
        title: Strings.SOLD,
        leading: CustomBackButton(onTap: () => Navigator.pop(context)),
      ).getAppBar(context),

      body: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
              decoration: BoxDecoration(
                color: Constant.PrimaryColor,
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_18),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  Container(
                    width: Constant.CONTAINER_SIZE_60,
                    height: Constant.CONTAINER_SIZE_60,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(Constant.SIZE_10),
                    ),
                    child: const Icon(Icons.inventory_2, color: Colors.white),
                  ),
                  SizedBox(width: Constant.CONTAINER_SIZE_12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dip Cup",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Constant.CONTAINER_SIZE_18,
                          ),
                        ),
                        SizedBox(height: Constant.SIZE_04),
                        Text(
                          "ST-DC-50",
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: Constant.SIZE_02),
                        Text("50ml", style: TextStyle(color: Colors.white38)),
                      ],
                    ),
                  ),
                  Text(
                    "10",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Constant.CONTAINER_SIZE_22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_18),

            Container(
              height: Constant.CONTAINER_SIZE_45,
              decoration: BoxDecoration(
                color: Constant.green4,
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_30),
              ),
              child: Row(
                children: [
                  _segment(
                    title: "User",
                    selected: tab == SoldTab.user,
                    onTap: () {
                      ref.read(soldTabProvider.notifier).state = SoldTab.user;
                    },
                  ),
                  _segment(
                    title: "Partner",
                    selected: tab == SoldTab.partner,
                    onTap: () {
                      ref.read(soldTabProvider.notifier).state =
                          SoldTab.partner;
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_16),

            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: tab == SoldTab.user
                    ? "Search by User ID"
                    : "Search by Partner Name",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                suffixIcon: const Icon(
                  Icons.filter_list,
                  color: Colors.white54,
                ),
                filled: true,
                fillColor: Constant.green4,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    Constant.CONTAINER_SIZE_30,
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_20),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: tab == SoldTab.user
                    ? const _UserUI()
                    : const _PartnerUI(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _segment({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.all(Constant.SIZE_04),
          decoration: BoxDecoration(
            color: selected ? Colors.white24 : Colors.transparent,
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_25),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: selected ? Colors.amber : Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _UserUI extends StatelessWidget {
  const _UserUI();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          "November-2025",
          style: TextStyle(
            fontSize: Constant.CONTAINER_SIZE_16,
            color: Colors.white70,
          ),
        ),
        SizedBox(height: Constant.SIZE_10),
        _userCard(),
      ],
    );
  }

  Widget _userCard() {
    return Container(
      margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_14),
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: Constant.green4,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SIDD-1542",
                  style: TextStyle(
                    fontSize: Constant.CONTAINER_SIZE_16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Constant.SIZE_05),
                Text(
                  "25.11.2025 | 09:00",
                  style: TextStyle(
                    fontSize: Constant.CONTAINER_SIZE_14,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "1",
            style: TextStyle(
              color: Constant.PrimaryAssentColor,
              fontWeight: FontWeight.bold,
              fontSize: Constant.CONTAINER_SIZE_18,
            ),
          ),
          SizedBox(width: Constant.SIZE_08),
          Icon(Icons.chevron_right, color: Colors.white),
        ],
      ),
    );
  }
}

class _PartnerUI extends StatelessWidget {
  const _PartnerUI();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          "November-2025",
          style: TextStyle(
            fontSize: Constant.CONTAINER_SIZE_16,
            color: Colors.white70,
          ),
        ),
        SizedBox(height: Constant.SIZE_10),
        _partnerCard("ROKA Business Bay", "01.11.2025 | 10:12", "2"),
        SizedBox(height: Constant.CONTAINER_SIZE_16),
        const Text("October-2025", style: TextStyle(color: Colors.white70)),
        SizedBox(height: Constant.CONTAINER_SIZE_10),
        _partnerCard("Sfumato Gastro Atelier", "10.10.2025 | 14:23", "4"),
        _partnerCard("ROKA Business Bay", "09.10.2025 | 12:23", "3"),
      ],
    );
  }

  Widget _partnerCard(String title, String subtitle, String qty) {
    return Container(
      margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_14),
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: Constant.green4,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Constant.CONTAINER_SIZE_16,
                  ),
                ),
                SizedBox(height: Constant.SIZE_05),
                Text(subtitle, style: const TextStyle(color: Colors.white54)),
              ],
            ),
          ),
          Text(
            qty,
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: Constant.CONTAINER_SIZE_18,
            ),
          ),
          SizedBox(width: Constant.SIZE_08),
          const Icon(Icons.chevron_right, color: Colors.white),
        ],
      ),
    );
  }
}
