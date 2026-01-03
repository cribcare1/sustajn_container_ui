import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sustajn_customer/constants/string_utils.dart';
import '../../constants/imports_util.dart';
import '../../constants/number_constants.dart';
import '../../utils/utils.dart';

class TermsconditionScreen extends StatefulWidget {
  const TermsconditionScreen({super.key});

  @override
  State<TermsconditionScreen> createState() =>
      _TermsconditionScreenState();
}

class _TermsconditionScreenState extends State<TermsconditionScreen> {

  late Future<String> _termsFuture;

  @override
  void initState() {
    super.initState();
    _termsFuture = _loadTermsFromAssets();
  }

  Future<String> _loadTermsFromAssets() async {
    return await rootBundle
        .loadString('assets/note/terms_condition.txt');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: Constant.CONTAINER_SIZE_26,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  Text(
                    "Terms & Conditions",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Constant.CONTAINER_SIZE_20,
                ),
                child: FutureBuilder<String>(
                  future: _termsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Text(
                        "Failed to load terms & conditions",
                        style: TextStyle(color: Colors.red),
                      );
                    }

                    return Text(
                      snapshot.data ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        height: Constant.CONTAINER_SIZE_1,
                      ),
                    );
                  },
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Utils.termsDialog(
                      context,
                      Icons.warning_amber_outlined,
                      Strings.CONFIRM_ACCOUNT,
                      Strings.CONFIRM_MESSAGE,
                      Strings.CANCEL,
                      Strings.CREATE,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constant.gold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_20,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: Constant.CONTAINER_SIZE_16,
                    ),
                  ),
                  child: Text(
                    "Agree & Create Account",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
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

