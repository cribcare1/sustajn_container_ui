import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sustajn_restaurant/common_widgets/card_widget.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/constants/imports_util.dart';
import 'package:sustajn_restaurant/lease_receive/model/container_return_list_model.dart';
import 'package:sustajn_restaurant/network_provider/network_provider.dart';
import 'package:sustajn_restaurant/provider/profile_provider.dart';
import 'package:sustajn_restaurant/utils/utility.dart';

import '../../../constants/network_urls.dart';
import '../../../constants/string_utils.dart';
import '../../../notifier/profile_notifier.dart';

class DamageContainerBottomSheet extends ConsumerStatefulWidget {
  final ProductOrderListResponseList item;
  final String customerId;

  const DamageContainerBottomSheet({
    super.key,
    required this.item,
    required this.customerId,
  });

  @override
  ConsumerState<DamageContainerBottomSheet> createState() =>
      _DamageContainerBottomSheetState();
}

class _DamageContainerBottomSheetState
    extends ConsumerState<DamageContainerBottomSheet> {
  final TextEditingController _remarksController = TextEditingController();

  File? selectedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  void removeImage() {
    setState(() {
      selectedImage = null;
    });
  }

  /// VIEW IMAGE FULL SCREEN
  void viewImage() {
    if (selectedImage == null) return;

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.black,
          child: InteractiveViewer(child: Image.file(selectedImage!)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Utils.buildFloatingHeader(context),
              SizedBox(height: Constant.SIZE_08),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xff0F3D2E),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Scanned Damage Container",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_16),
                    GlassSummaryCard(
                      child: Row(
                        children: [
                          Container(
                            height: Constant.TEXT_FIELD_HEIGHT,
                            width: Constant.TEXT_FIELD_HEIGHT,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(
                                Constant.SIZE_08,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                Constant.SIZE_08,
                              ),
                              child: Image.network(
                                "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${widget.item.productImageUrl}",
                                errorBuilder: (context, obj, stack) {
                                  return Image.asset(
                                    "assets/images/no_image_container.png",
                                  );
                                },
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.item.productName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                widget.item.productUniqueId,
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(
                                "${widget.item.containerQuantity}ml",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _remarksController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Remarks",
                        hintStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.green.shade900.withOpacity(.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.green.shade900.withOpacity(.4),
                        ),
                        child: Column(
                          children: const [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              color: Colors.white70,
                              size: 28,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Upload container image",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (selectedImage != null)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.green.shade900.withOpacity(.4),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: viewImage,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  selectedImage!,
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                selectedImage!.path.split('/').last,
                                style: const TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              onPressed: viewImage,
                              icon: const Icon(
                                Icons.visibility,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: removeImage,
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    profileState.isSaving
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox(
                            width: double.infinity,
                            child: SubmitButton(
                              onRightTap: () {
                                if (selectedImage == null) {
                                  Fluttertoast.showToast(msg: "Select Image");
                                  return;
                                } else {
                                  Map<String, dynamic> body = {
                                    "containerTypeId": widget.item.productId,
                                    "remark": _remarksController.text,
                                    "restaurantId": Utils.userId,
                                    "userId": widget.customerId,
                                    "isDamagedByRestaurant": false,
                                    "isDamagedByUser": true,
                                    "image":selectedImage!.path,
                                  };
                                  _networkCall(profileState, body: body);
                                }
                              },

                              rightText: Strings.CONFIRM,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _networkCall(
    ProfileState leasState, {
    required Map<String, dynamic> body,
  }) async {
    try {
      leasState.setIsSaving(true);
      Future.delayed(Duration(seconds: 2));
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) async {
        try {
          if (isNetworkAvailable) {
            ref.read(damageContainer(body));
          } else {
            leasState.setIsSaving(false);
            if (!mounted) return;
            showCustomSnackBar(
              context: context,
              message: Strings.NO_INTERNET_CONNECTION,
              color: Colors.red,
            );
          }
        } catch (e) {
          Utils.printLog('Error on button onPressed: $e');
          leasState.setIsSaving(false);
        }
        if (!mounted) return;
        FocusScope.of(context).unfocus();
      });
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      leasState.setIsSaving(false);
    }
  }
}
