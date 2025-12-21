import 'dart:convert';
import 'dart:io';

import 'package:container_tracking/container_list/container_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/model/login_model.dart';
import '../../common_provider/network_provider.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../common_widgets/submit_button.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/SharedPreferenceUtils.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import '../model/container_list_model.dart';

class AddContainerScreen extends ConsumerStatefulWidget {
  final InventoryData? inventoryData;

  const AddContainerScreen({super.key, this.inventoryData});

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
  final TextEditingController _desController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  _fetchData() {
    if (widget.inventoryData != null) {
      _productController.text = widget.inventoryData!.containerName;
      _productIdController.text = widget.inventoryData!.productId;
      _desController.text = widget.inventoryData!.containerDescription;
      _volumeController.text = widget.inventoryData!.capacityMl.toString();
      _quantityController.text = widget.inventoryData!.totalContainers
          .toString();
      _priceController.text = widget.inventoryData!.costPerUnit.toString();
      if (widget.inventoryData!.imageUrl != "") {
        ref
            .read(containerNotifierProvider)
            .setImage(
              File(
                "${NetworkUrls.IMAGE_BASE_URL}container/${widget.inventoryData!.imageUrl}",
              ),
            );
      }
    }
  }

  @override
  void dispose() {
    _productController.dispose();
    _volumeController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _productIdController.dispose();
    _desController.dispose();
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
        ref.read(containerNotifierProvider).setImage(File(pickedFile.path));
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

  LoginModel? loginModel;

  Future<void> _getUserData() async {
    final Map<String, dynamic>? json =
    await SharedPreferenceUtils.getMapFromSF(Strings.PROFILE_DATA);

    if (json != null) {
      loginModel = LoginModel.fromJson(json);
      setState(() {});
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(containerNotifierProvider).setContext(context);
      ref.read(containerNotifierProvider).setImage(null);
      _fetchData();
      _getUserData();
      _productController.addListener(updateProductId);
      _volumeController.addListener(updateProductId);
    });
    super.initState();
  }

  String generateProductId(String productName, String volume) {
    if (productName.trim().isEmpty || volume.trim().isEmpty) {
      return '';
    }

    final words = productName.trim().split(RegExp(r'\s+'));
    String code = '';

    if (words.length == 1) {
      final word = words.first;
      code = word.length >= 2 ? word.substring(0, 2) : word.substring(0, 1);
    } else if (words.length == 2) {
      code = words[0][0] + words[1][0];
    } else {
      code = words.first[0] + words.last[0];
    }

    return '${code.toUpperCase()}-$volume';
  }

  void updateProductId() {
    final productName = _productController.text;
    final volume = _volumeController.text;

    _productIdController.text = generateProductId(productName, volume);
  }

  String? _validateProduct(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Required";
    }
    return null;
  }

  String? _validateProductId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Required";
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
                        borderRadius: BorderRadius.circular(
                          Constant.CONTAINER_SIZE_16,
                        ),
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
                                  controller: _volumeController,
                                  hint: Strings.ENTER_VOLUME,
                                  validator: _validateVolume,
                                  keyboardType: TextInputType.number,
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
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                ),
                                SizedBox(height: Constant.CONTAINER_SIZE_12),
                                _buildTextField(
                                  controller: _productIdController,
                                  hint: Strings.ENTER_PRODUCT_ID,
                                  validator: _validateProductId,
                                  keyboardType: TextInputType.text,
                                  isReadonly: true,
                                ),
                                SizedBox(height: Constant.CONTAINER_SIZE_12),
                                _buildTextField(
                                  maxLine: 4,
                                  controller: _desController,
                                  hint: Strings.DESCRIPTION_TEXT,
                                  keyboardType: TextInputType.text,
                                  validator: (String? p1) {
                                    return null;
                                  },
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
                        borderRadius: BorderRadius.circular(
                          Constant.CONTAINER_SIZE_16,
                        ),
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
                              child:
                                  containerState.image == null ||
                                      containerState.image == File("")
                                  ? _buildUploadUI()
                                  : _buildSelectedImageUI(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Constant.CONTAINER_SIZE_20),
                    containerState.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : SubmitButton(
                            onRightTap: () {
                              Map<String, dynamic> body =
                                  (widget.inventoryData != null)
                                  ? {
                                      "containerName": _productController.text,
                                      "productId": _productIdController.text,
                                      "capacityMl": _volumeController.text,
                                      "quantity": _quantityController.text,
                                      "price": _priceController.text,
                                      "foodSafe": true,
                                      "dishwasherSafe": true,
                                      "microwaveSafe": false,
                                      "userId": loginModel!.data.userId,
                                      "containerTypeId":
                                          widget.inventoryData!.containerTypeId,
                                      "description": _desController.text,
                                    }
                                  : {
                                      "containerName": _productController.text,
                                      "productId": _productIdController.text,
                                      "capacityMl": _volumeController.text,
                                      "quantity": _quantityController.text,
                                      "price": _priceController.text,
                                      "foodSafe": true,
                                      "dishwasherSafe": true,
                                      "microwaveSafe": false,
                                      "userId": loginModel!.data.userId,
                                      "description": _desController.text,
                                    };
                              if (_formKey.currentState!.validate()) {
                                if (containerState.image != null) {
                                  _getNetworkData(containerState, body);
                                } else {
                                  showCustomSnackBar(
                                    context: context,
                                    message: "Please upload container image",
                                    color: Colors.red,
                                  );
                                }
                              } else {
                                showCustomSnackBar(
                                  context: context,
                                  message: "Please complete required fields",
                                  color: Colors.red,
                                );
                              }
                            },
                            rightText: (widget.inventoryData != null)
                                ? "Edit Container"
                                : "Add Container",
                          ),
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
    int? maxLine = 1,
    bool isReadonly = false,
  }) {
    return TextFormField(
      readOnly: isReadonly,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLine,
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

  Widget _buildDashedContainer({
    required double height,
    required Widget child,
  }) {
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
      insetPadding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_20,
      ),
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
              child: Icon(
                Icons.close,
                size: Constant.CONTAINER_SIZE_18,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadUI() {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: Constant.SIZE_01,
            minHeight: Constant.SIZE_01,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: Constant.CONTAINER_SIZE_45,
                height: Constant.CONTAINER_SIZE_45,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF7F1),
                  borderRadius: BorderRadius.circular(
                    Constant.CONTAINER_SIZE_12,
                  ),
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
          child: (state.image!.path.contains("http:"))
              ? Image.network(
                  state.image!.path,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                )
              : Image.file(
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
            onTap: () {
              state.setImage(null);
            },
            child: Container(
              width: Constant.CONTAINER_SIZE_28,
              height: Constant.CONTAINER_SIZE_28,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: Constant.CONTAINER_SIZE_18,
                color: Colors.black,
              ),
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
            child: Icon(
              icon,
              size: Constant.CONTAINER_SIZE_36,
              color: const Color(0xFF2D8F6E),
            ),
          ),
          SizedBox(height: Constant.CONTAINER_SIZE_12),
          Text(label, style: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_14)),
        ],
      ),
    );
  }

  _getNetworkData(var containerState, Map<String, dynamic> body) async {
    try {
      containerState.setIsLoading(true);
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) async {
        try {
          if (isNetworkAvailable) {
            containerState.setIsLoading(true);
            ref.read(addContainerProvider(body));
          } else {
            containerState.setIsLoading(false);
            if (!mounted) return;
            showCustomSnackBar(
              context: context,
              message: Strings.NO_INTERNET_CONNECTION,
              color: Colors.red,
            );
          }
        } catch (e) {
          Utils.printLog('Error on button onPressed: $e');
          containerState.setIsLoading(false);
        }
        if (!mounted) return;
        FocusScope.of(context).unfocus();
      });
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      containerState.setIsLoading(false);
    }
  }
}
