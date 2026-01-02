import 'package:sustajn_customer/constants/string_utils.dart';

import '../../constants/imports_util.dart';
import '../../constants/number_constants.dart';
import '../../utils/utils.dart';


class TermsconditionScreen extends StatelessWidget {
  const TermsconditionScreen({super.key});

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
                child: Text(
                  _termsText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    height: Constant.CONTAINER_SIZE_1,
                  ),
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

const String _termsText =
    "Lorem ipsum dolor sit amet consectetur. Lacus augue "
    "suspendisse rhoncus hendrerit ut velit semper. Dignissim sed "
    "id magna sit varius dui enim lectus. Congue id id duis "
    "scelerisque. At non sed posuere sem orci. Ipsum et arcu "
    "lectus vitae ut magna. Risus vitae tellus vivamus mauris"
    "fringilla eget eu ipsum nisl. Id eget morbi interdum tellus "
    "egestas aliquam. Dui tempus leo sem habitant. Pulvinar sit "
    "suscipit aliquet nisl laoreet est."
    "Ultricies proin amet sagittis mollis. Velit blandit vel eleifend et "
    "gravida. Varius accumsan pellentesque nam eu. Tincidunt sem"
    "odio lobortis bibendum fames scelerisque bibendum. Vitae"
    "porttitor turpis lacus suspendisse est mollis. Id magna aliquet "
    "pellentesque amet et convallis quis. "
    "Hac vitae enim orci nunc. Amet amet rutrum a ut nec purus "
    "tristique ultrices tincidunt. Consequat neque nisl sed laoreet "
    "cursus diam. Rutrum commodo pellentesque lectus tempor."
    "Auctor vel aliquam risus cras donec mattis pellentesque. Sed "
    "sed arcu sollicitudin sem. Etiam tristique fames sagittis"
    "feugiat a ut rhoncus massa congue. Diam volutpat tincidunt"
    "rhoncus faucibus condimentum ullamcorper laoreet. Sem"
    "ipsum risus neque nisi arcu pharetra velit pulvinar maecenas. "
    "Ac vulputate ultrices amet facilisi ut. Convallis convallis eget "
    "diam rhoncus nisl in porttitor. Mauris molestie dolor turpis at "
    "diam. Ac a eget maecenas nibh arcu sit. Sed vel viverra"
    "vulputate quam purus proin. Id fermentum mauris tellus tellus. "
    "Tincidunt dui eget.";