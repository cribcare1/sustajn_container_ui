import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../common_widgets/submit_button.dart';
import '../../../constants/imports_util.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/utility.dart';

class AddDamagedContainerSheet extends StatefulWidget {
  const AddDamagedContainerSheet({Key? key}) : super(key: key);

  @override
  State<AddDamagedContainerSheet> createState() =>
      _AddDamagedContainerSheetState();
}

class _AddDamagedContainerSheetState extends State<AddDamagedContainerSheet> {
  final TextEditingController remarksController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile> selectedImages = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Constant.CONTAINER_SIZE_16),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: Constant.CONTAINER_SIZE_20,
                    right: Constant.CONTAINER_SIZE_20,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    top: Constant.CONTAINER_SIZE_20,
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Scanned Damage Container",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: Constant.LABEL_TEXT_SIZE_18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: Constant.CONTAINER_SIZE_16),

                        Container(
                          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
                          decoration: BoxDecoration(
                            color: Color(0xFF184E3B),
                            borderRadius: BorderRadius.circular(
                              Constant.CONTAINER_SIZE_14,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: Constant.CONTAINER_SIZE_50,
                                width: Constant.CONTAINER_SIZE_50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(
                                    Constant.CONTAINER_SIZE_10,
                                  ),
                                ),
                                child: Image.asset(Strings.CUP_IMG),
                              ),
                              SizedBox(width: Constant.CONTAINER_SIZE_12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Dip Cups",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: Constant.SIZE_04),
                                  Text(
                                    "ST-DC-50",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  Text(
                                    "50ml",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: Constant.CONTAINER_SIZE_16),

                        /// REMARKS FIELD
                        TextField(
                          controller: remarksController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: Strings.REMARKS,
                            hintStyle: TextStyle(color: Colors.white60),
                            filled: true,
                            fillColor: Color(0xFF184E3B),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Constant.CONTAINER_SIZE_12,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                Constant.CONTAINER_SIZE_12,
                              ),
                              borderSide: BorderSide(color: Constant.grey),
                            ),
                          ),
                        ),

                        SizedBox(height: Constant.CONTAINER_SIZE_16),

                        /// IMAGE UPLOAD BOX
                        GestureDetector(
                          onTap: _pickImages,
                          child: Container(
                            height: Constant.CONTAINER_SIZE_120,
                            decoration: BoxDecoration(
                              color: Color(0xFF184E3B),
                              borderRadius: BorderRadius.circular(
                                Constant.CONTAINER_SIZE_14,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    color: Colors.white70,
                                  ),
                                  SizedBox(height: Constant.SIZE_08),
                                  Text(
                                    "Upload container image (max 5 photos)",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: Constant.CONTAINER_SIZE_12,
                                    ),
                                  ),
                                  SizedBox(height: Constant.SIZE_04),
                                  Text(
                                    "Choose",
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Constant.CONTAINER_SIZE_12),

                        if (selectedImages.isNotEmpty)
                          Wrap(
                            spacing: Constant.CONTAINER_SIZE_10,
                            runSpacing: Constant.CONTAINER_SIZE_10,
                            children: List.generate(selectedImages.length, (
                              index,
                            ) {
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      Constant.CONTAINER_SIZE_10,
                                    ),
                                    child: Image.file(
                                      File(selectedImages[index].path),
                                      height: Constant.CONTAINER_SIZE_50,
                                      width: Constant.CONTAINER_SIZE_50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  /// Remove Button
                                  Positioned(
                                    top: -5,
                                    right: -5,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedImages.removeAt(index);
                                        });
                                      },
                                      child: CircleAvatar(
                                        radius: Constant.CONTAINER_SIZE_12,
                                        backgroundColor: Colors.red,
                                        child: Icon(
                                          Icons.close,
                                          size: Constant.CONTAINER_SIZE_14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        SizedBox(height: Constant.CONTAINER_SIZE_10),
                        SizedBox(
                          width: double.infinity,
                          child: SubmitButton(
                            onRightTap: () {},
                            rightText: Strings.CONFIRM,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Utils.buildFloatingHeader(context),
          ],
        );
      },
    );
  }

  Future<void> _pickImages() async {
    if (selectedImages.length >= 5) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Maximum 5 images allowed")));
      return;
    }

    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      setState(() {
        final remaining = 5 - selectedImages.length;
        selectedImages.addAll(images.take(remaining));
      });
    }
  }
}
