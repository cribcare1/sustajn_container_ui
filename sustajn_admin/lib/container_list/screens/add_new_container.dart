import 'dart:convert';
import 'dart:io';
import 'package:container_tracking/common_widgets/card_widget.dart';
import 'package:container_tracking/container_list/container_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/model/login_model.dart';
import '../../common_provider/network_provider.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../common_widgets/submit_button.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../products_screen/add_container_popup.dart';
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
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _dishwashController = TextEditingController();
  final TextEditingController _microwaveController = TextEditingController();
  final TextEditingController _maxtemperatureController = TextEditingController();
  final TextEditingController _mintemperatureController = TextEditingController();
  final TextEditingController _lifespanfoodController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  _fetchData() {
    if (widget.inventoryData != null) {
      _productController.text = widget.inventoryData!.containerName!;
      _productIdController.text = widget.inventoryData!.productId!;
      _desController.text = widget.inventoryData!.containerDescription!;
      _volumeController.text = widget.inventoryData!.capacityMl.toString();
      _quantityController.text = widget.inventoryData!.totalContainers
          .toString();
      _materialController.text = widget.inventoryData!.material.toString();
      _colorController.text = widget.inventoryData!.colour.toString();
      _lengthController.text = widget.inventoryData!.lengthCm.toString();
      _heightController.text = widget.inventoryData!.heightCm.toString();
      _weightController.text = widget.inventoryData!.weightGrams.toString();
      _foodController.text = widget.inventoryData!.foodSafe.toString();
      _dishwashController.text = widget.inventoryData!.dishwasherSafe.toString();
      _microwaveController.text = widget.inventoryData!.microwaveSafe.toString();
      _maxtemperatureController.text = widget.inventoryData!.maxTemperature.toString();
      _mintemperatureController.text = widget.inventoryData!.minTemperature.toString();
      _lifespanfoodController.text = widget.inventoryData!.lifespanCycle.toString();
      _costController.text = widget.inventoryData!.costPerUnit.toString();
    }
  }

  @override
  void dispose() {
    _productController.dispose();
    _volumeController.dispose();
    _quantityController.dispose();
    _productIdController.dispose();
    _desController.dispose();
    _materialController.dispose();
    super.dispose();
  }
  LoginData? loginModel;

  Future<void> _getUserData() async {
    final Map<String, dynamic>? json =
    await SharedPreferenceUtils.getMapFromSF(Strings.PROFILE_DATA);

    if (json != null) {
      loginModel = LoginData.fromJson(json);
      setState(() {});
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(containerNotifierProvider).setContext(context);
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

  String? _validateMaterial(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Required";
    }
    return null;
  }
  String? _validateColor(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Required";
    }
    return null;
  }

  String? _validateLength(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Required";
    }
    final regex = RegExp(r'^[0-9]+$');
    if (!regex.hasMatch(value)) {
      return "Only numbers allowed";
    }
    return null;
  }

  String? _validateHeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Required";
    }
    final regex = RegExp(r'^[0-9]+$');
    if (!regex.hasMatch(value)) {
      return "Only numbers allowed";
    }
    return null;
  }

  String? _validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Required";
    }
    final regex = RegExp(r'^[0-9]+$');
    if (!regex.hasMatch(value)) {
      return "Only numbers allowed";
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
        centerTitle: false,
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
                    GlassSummaryCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.CONTAINER_INFORMATION,
                            style: themeData!.textTheme.titleMedium
                          ),
                          SizedBox(height: Constant.CONTAINER_SIZE_12),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildTextField(
                                  controller: _productController,
                                  hint: Strings.SELECT_PRODUCT,
                                  validator: _validateProduct,
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(height: Constant.CONTAINER_SIZE_12),
                                _buildTextField(
                                  controller: _productIdController,
                                  hint: Strings.SELECT_PRODUCT_ID,
                                  validator: _validateProductId,
                                  keyboardType: TextInputType.text,
                                  // isReadonly: true,
                                ),
                                SizedBox(height: Constant.CONTAINER_SIZE_12),
                                _buildTextField(
                                  controller: _volumeController,
                                  hint: Strings.SELECT_VOLUME,
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
                                Container(
                                  padding: EdgeInsets.all(Constant.CONTAINER_SIZE_10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white.withOpacity(0.01),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.25),
                                      width: 0.08,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.01),
                                        blurRadius: 18,
                                        offset: const Offset(0, 8)
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Strings.CONTAINER_SPEC,
                                        style: TextStyle(
                                          fontSize: Constant.LABEL_TEXT_SIZE_18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildTextField(
                                  maxLine: 8,
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

                    SizedBox(height: Constant.CONTAINER_SIZE_12),
                    _buildTextField(
                      controller: _materialController,
                      hint: Strings.CONTAINER_MATERIAL,
                      validator: _validateMaterial,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_12),
                    _buildTextField(
                      controller: _colorController,
                      hint: Strings.CONTAINER_COLOR,
                      validator: _validateColor,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_12),
                    _buildTextField(
                      controller: _lengthController,
                      hint: Strings.LENGTH,
                      validator: _validateLength,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_12),
                    _buildTextField(
                      controller: _heightController,
                      hint: Strings.HEIGHT,
                      validator: _validateHeight,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_12),
                    _buildTextField(
                      controller: _weightController,
                      hint: Strings.WEIGHT,
                      validator: _validateWeight,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_12),
                    _buildTextField(
                      controller: _foodController,
                      hint: Strings.FOOD_SAFE,
                      validator: _validateProductId,
                      keyboardType: TextInputType.text,
                      isReadonly: true,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_12),
                    _buildTextField(
                      controller: _productIdController,
                      hint: Strings.DISH_WASH,
                      validator: _validateProductId,
                      keyboardType: TextInputType.text,
                      isReadonly: true,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_12),
                    _buildTextField(
                      controller: _productIdController,
                      hint: Strings.MICROWAVE,
                      validator: _validateProductId,
                      keyboardType: TextInputType.text,
                      isReadonly: true,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_12),
                    _buildTextField(
                      controller: _productIdController,
                      hint: Strings.MAX_TEMP,
                      validator: _validateProductId,
                      keyboardType: TextInputType.text,
                      isReadonly: true,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_12),
                    _buildTextField(
                      controller: _productIdController,
                      hint: Strings.MIN_TEMPERATURE,
                      validator: _validateProductId,
                      keyboardType: TextInputType.text,
                      isReadonly: true,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_12),
                    _buildTextField(
                      controller: _productIdController,
                      hint: Strings.LIFESPAN,
                      validator: _validateProductId,
                      keyboardType: TextInputType.text,
                      isReadonly: true,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_12),
                    _buildTextField(
                      controller: _productIdController,
                      hint: Strings.COST,
                      validator: _validateProductId,
                      keyboardType: TextInputType.text,
                      isReadonly: true,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_12),

                    containerState.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : SubmitButton(
                            onRightTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => const RejectOrderSheet(),
                              );
                              Map<String, dynamic> body =
                                  (widget.inventoryData != null)
                                  ? {
                                      "containerName": _productController.text,
                                      "productId": _productIdController.text,
                                      "capacityMl": _volumeController.text,
                                      "quantity": _quantityController.text,
                                      "foodSafe": true,
                                      "dishwasherSafe": true,
                                      "microwaveSafe": false,
                                      "userId": loginModel!.userId,
                                      "containerTypeId":
                                          widget.inventoryData!.containerTypeId,
                                      "description": _desController.text,
                                    }
                                  : {
                                      "containerName": _productController.text,
                                      "productId": _productIdController.text,
                                      "capacityMl": _volumeController.text,
                                      "quantity": _quantityController.text,
                                      "foodSafe": true,
                                      "dishwasherSafe": true,
                                      "microwaveSafe": false,
                                      "userId": loginModel!.userId,
                                      "description": _desController.text,
                                    };
                              _getNetworkData(containerState, body);
                                showCustomSnackBar(
                                  context: context,
                                  message: "Please complete required fields",
                                  color: Colors.red,
                                );
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
      style: Theme.of(context).textTheme.titleSmall,
      readOnly: isReadonly,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLine,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Theme.of(context).primaryColor,
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
              color: Theme.of(context).secondaryHeaderColor,
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
              ],
            ),
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_12),

          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: Constant.CONTAINER_SIZE_28,
              height: Constant.CONTAINER_SIZE_28,
              decoration:  BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: Constant.CONTAINER_SIZE_18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
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
