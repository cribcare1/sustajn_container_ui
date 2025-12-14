import 'dart:io';

import 'package:container_tracking/container_list/container_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../common_provider/network_provider.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../common_widgets/submit_button.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';

class AddContainerScreen extends ConsumerStatefulWidget {
  const AddContainerScreen({super.key});

  @override
  ConsumerState<AddContainerScreen> createState() => _AddContainerScreenState();
}

class _AddContainerScreenState extends ConsumerState<AddContainerScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _productController = TextEditingController();
  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _productController.dispose();
    _productIdController.dispose();
    _volumeController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _showChooseDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => _buildChooseDialog(),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        ref.read(containerNotifierProvider).setImage( File(pickedFile.path));
      }

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error picking image: ${e.toString()}"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
  
@override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref.read(containerNotifierProvider).setContext(context);
    });
    super.initState();
  }
  String? _validateProduct(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Required";
    }
    final regex = RegExp(r'^[a-zA-Z\s]+$');
    if (!regex.hasMatch(value)) {
      return "Only letters and spaces allowed";
    }
    return null;
  }

  String? _validateProductId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Required";
    }
    final regex = RegExp(r'^[a-zA-Z0-9]+$');
    if (!regex.hasMatch(value)) {
      return "Only letters and numbers allowed";
    }
    return null;
  }

  String? _validateVolume(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Required";
    }
    final regex = RegExp(r'^[a-zA-Z0-9\s]+$');
    if (!regex.hasMatch(value)) {
      return "Only letters and numbers allowed";
    }
    return null;
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Required";
    }
    final regex = RegExp(r'^[0-9]+$');
    if (!regex.hasMatch(value)) {
      return "Only numbers allowed";
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Required";
    }
    final regex = RegExp(r'^[0-9]+(\.[0-9]{1,2})?$');
    if (!regex.hasMatch(value)) {
      return "Only numbers and decimal point allowed";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final themeData = CustomTheme.getTheme(true);
    final containerState = ref.watch(containerNotifierProvider);
    return Scaffold(
      backgroundColor: themeData?.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: Strings.ADD_NEWCONTAINER_TITLE,
        leading: CustomBackButton(),
      ).getAppBar(context),

      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.CONTAINER_INFORMATION,
                            style: TextStyle(
                              fontSize: Constant.LABEL_TEXT_SIZE_18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: Constant.CONTAINER_SIZE_12),

                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildTextField(
                                  controller: _productController,
                                  hint: Strings.ENTER_PRODUCT,
                                  validator: _validateProduct,
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(height: Constant.CONTAINER_SIZE_12),

                                _buildTextField(
                                  controller: _productIdController,
                                  hint: Strings.ENTER_PRODUCT_ID,
                                  validator: _validateProductId,
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(height: Constant.CONTAINER_SIZE_12),

                                _buildTextField(
                                  controller: _volumeController,
                                  hint:Strings.ENTER_VOLUME,
                                  validator: _validateVolume,
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(height: Constant.CONTAINER_SIZE_12),

                                _buildTextField(
                                  controller: _quantityController,
                                  hint: Strings.ENTER_QUANTITY,
                                  validator: _validateQuantity,
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(height: Constant.CONTAINER_SIZE_12),

                                _buildTextField(
                                  controller: _priceController,
                                  hint: Strings.CONTAINER_PRICE,
                                  validator: _validatePrice,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Constant.CONTAINER_SIZE_20),
                    Container(
                      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.CONTAINER_IMAGE,
                            style: TextStyle(
                              fontSize: Constant.LABEL_TEXT_SIZE_18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: Constant.CONTAINER_SIZE_12),
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              _showChooseDialog();
                            },
                            child: _buildDashedContainer(
                              height: screenWidth * 0.35,
                              child: containerState.image == null ||  containerState.image == File("")
                                  ? _buildUploadUI()
                                  : _buildSelectedImageUI(),
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: Constant.CONTAINER_SIZE_20),
                  containerState.isSaving!?Center(child: CircularProgressIndicator(),):
                  SubmitButton(onRightTap: () {
                    Map<String, dynamic> body = {
                      "name": _productController.text,
                      "id": null,
                      "capacity": _volumeController.text,
                      "quantity": _quantityController.text,
                      "active":true,
                    };
                      if (_formKey.currentState!.validate()) {
                                  // Navigator.pop(context, {
                                  //   "name": _productController.text,
                                  //   "id": _productIdController.text,
                                  //   "volume": _volumeController.text,
                                  //   "quantity": _quantityController.text,
                                  //   "image": containerState.image,
                                  // });
                                  _getNetworkData(containerState,body);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Please complete required fields")),
                                  );
                                }
                    },rightText: "Add Container",),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    required TextInputType keyboardType,
    IconData? suffix,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8F9F7),
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: Constant.LABEL_TEXT_SIZE_14,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Constant.CONTAINER_SIZE_12,
          vertical: 0,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE8EFEA)),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFBFDCCF)),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        ),
        suffixIcon: suffix != null ? Icon(suffix, color: Colors.grey) : null,
      ),
    );
  }

  Widget _buildDashedContainer({required double height, required Widget child}) {
    return DottedBorder(
      color: const Color(0xFFBFDCCF),
      strokeWidth: Constant.SIZE_02,
      dashPattern: const [6, 6],
      borderType: BorderType.RRect,
      radius: Radius.circular(Constant.CONTAINER_SIZE_12),
      child: Container(
        height: height,
        width: double.infinity,
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: child,
      ),
    );
  }


  Widget _buildChooseDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.CHOOSE,
                  style: TextStyle(
                    fontSize: Constant.LABEL_TEXT_SIZE_18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Constant.CONTAINER_SIZE_12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDialogOption(
                      label: Strings.CAMERA,
                      icon: Icons.camera_alt_outlined,
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                    _buildDialogOption(
                      label: Strings.GALLERY,
                      icon: Icons.image_outlined,
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_12),

          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: Constant.CONTAINER_SIZE_28,
              height: Constant.CONTAINER_SIZE_28,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child:  Icon(Icons.close, size: Constant.CONTAINER_SIZE_18, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUploadUI() {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: Constant.SIZE_01, minHeight: Constant.SIZE_01),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: Constant.CONTAINER_SIZE_45,
                height: Constant.CONTAINER_SIZE_45,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF7F1),
                  borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                ),
                child: Icon(
                  Icons.image,
                  size: Constant.CONTAINER_SIZE_28,
                  color: const Color(0xFF4B7A61),
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Text(
                Strings.UPLOAD_IMAGE,
                style: TextStyle(
                  fontSize: Constant.LABEL_TEXT_SIZE_14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Text(
                Strings.CHOOSE,
                style: TextStyle(
                  fontSize: Constant.LABEL_TEXT_SIZE_15,
                  color: const Color(0xFF2D8F6E),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedImageUI() {
    final state = ref.read(containerNotifierProvider);
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
          child: Image.file(
            state.image!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: Constant.SIZE_08,
          right: Constant.SIZE_08,
          child: GestureDetector(
            onTap: (){
              state.setImage(null);
            },
            child: Container(
              width: Constant.CONTAINER_SIZE_28,
              height: Constant.CONTAINER_SIZE_28,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child:  Icon(Icons.close, size: Constant.CONTAINER_SIZE_18, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildDialogOption({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
      child: Column(
        children: [
          Container(
            width: Constant.CONTAINER_SIZE_80,
            height: Constant.CONTAINER_SIZE_80,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF7F1),
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            ),
            child: Icon(icon, size: Constant.CONTAINER_SIZE_36, color: const Color(0xFF2D8F6E)),
          ),
          SizedBox(height: Constant.CONTAINER_SIZE_12),
          Text(
            label,
            style: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_14),
          ),
        ],
      ),
    );
  }
  _getNetworkData(var containerState, Map<String, dynamic> body) async {
    try {
      // if (containerState.isValid) {
        await ref
            .read(networkProvider.notifier)
            .isNetworkAvailable()
            .then((isNetworkAvailable) async {
          try {
            if (isNetworkAvailable) {
              containerState.setIsLoading(true);
              ref.read(addContainerProvider(body));
            } else {
              containerState.setIsLoading(false);
              if(!mounted) return;
              showCustomSnackBar(context: context, message: Strings.NO_INTERNET_CONNECTION, color: Colors.red);
            }
          } catch (e) {
            Utils.printLog('Error on button onPressed: $e');
            containerState.setIsLoading(false);
          }
          if(!mounted) return;
          FocusScope.of(context).unfocus();
        });
      // }
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      containerState.setIsLoading(false);
    }
  }
}