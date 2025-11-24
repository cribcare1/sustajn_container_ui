import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common_widgets/custom_app_bar.dart';
import '../common_widgets/custom_back_button.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../utils/theme_utils.dart';
import 'model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Container tracking',
        theme: CustomTheme.getTheme(true),
        home: const ContainerRequestScreen(),
      ),
    );
  }
}
class ContainerRequestScreen extends StatefulWidget {
  const ContainerRequestScreen({super.key});

  @override
  State<ContainerRequestScreen> createState() => _ContainerRequestScreenState();
}

class _ContainerRequestScreenState extends State<ContainerRequestScreen> {
  final TextEditingController _containerCountController = TextEditingController();
  final List<ContainerRequest> _requests = [];
  int _totalContainersReceived = 0;
  String _restaurantAddress = "123 Main Street, Restaurant City, RC 12345";
  double _latitude = 40.7128;
  double _longitude = -74.0060;

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    _requests.addAll([
      ContainerRequest(
        id: '1',
        requestedCount: 5,
        approvedCount: 5,
        status: RequestStatus.approved,
        requestDateTime: DateTime.now().subtract(const Duration(days: 2)),
        restaurantAddress: _restaurantAddress,
        latitude: _latitude,
        longitude: _longitude,
      ),
      ContainerRequest(
        id: '2',
        requestedCount: 3,
        approvedCount: 2,
        status: RequestStatus.approved,
        requestDateTime: DateTime.now().subtract(const Duration(days: 1)),
        restaurantAddress: _restaurantAddress,
        latitude: _latitude,
        longitude: _longitude,
      ),
      ContainerRequest(
        id: '3',
        requestedCount: 4,
        status: RequestStatus.pending,
        requestDateTime: DateTime.now(),
        restaurantAddress: _restaurantAddress,
        latitude: _latitude,
        longitude: _longitude,
      ),
    ]);
    _totalContainersReceived = 7;
  }

  void _submitRequest() {
    if (_containerCountController.text.isEmpty) return;

    final requestedCount = int.tryParse(_containerCountController.text) ?? 0;
    if (requestedCount <= 0) return;

    final newRequest = ContainerRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      requestedCount: requestedCount,
      status: RequestStatus.pending,
      requestDateTime: DateTime.now(),
      restaurantAddress: _restaurantAddress,
      latitude: _latitude,
      longitude: _longitude,
    );

    setState(() {
      _requests.insert(0, newRequest);
      _containerCountController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Container request submitted successfully!',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Constant.successColor,
      ),
    );
  }

  void _deleteRequest(String requestId) {
    setState(() {
      _requests.removeWhere((request) => request.id == requestId);
    });
  }


  void _openGoogleMaps() async {
    final mapsUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$_latitude,$_longitude'
    );

    try {
      await launchUrl(mapsUri);
    } catch (e) {
      print('Could not launch Google Maps: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(true);
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      appBar: CustomAppBar(title: 'Container Requests',
      leading: CustomBackButton()).getAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Constant.PADDING_HEIGHT_10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatisticsCard(),
            SizedBox(height: Constant.CONTAINER_SIZE_20),

            _buildRequestForm(themeData!),
            SizedBox(height: Constant.CONTAINER_SIZE_20),

            _buildRequestList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Card(
      elevation: Constant.SIZE_02,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
      ),
      child: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
        child: Row(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              color: Constant.primaryColor,
              size: Constant.CONTAINER_SIZE_30,
            ),
            SizedBox(width: Constant.CONTAINER_SIZE_15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.TOTAL_CONTAINERS_RECEIVED,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_05),
                  Text(
                    '$_totalContainersReceived',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Constant.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestForm(ThemeData themeData) {
    return Card(
      elevation: Constant.SIZE_02,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
      ),
      child: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.NEW_CONTAINER_REQUEST,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_20),

            TextFormField(
              controller: _containerCountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: Strings.NUMBER_OF_CONTAINERS_REQUIRED,
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Constant.SIZE_08),
                ),
                prefixIcon: Icon(Icons.numbers, color: Constant.primaryColor),
              ),
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        Strings.RESTAURANT_ADDRESS,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _openGoogleMaps,
                      icon: Icon(
                        Icons.map_outlined,
                        color: Constant.primaryColor,
                        size: Constant.CONTAINER_SIZE_24,
                      ),
                      tooltip: Strings.VERIFY_LOCATION_ON_MAP,
                    ),
                  ],
                ),
                SizedBox(height: Constant.SIZE_08),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                  decoration: BoxDecoration(
                    color: Constant.greyshade100.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(Constant.SIZE_08),
                    border: Border.all(color: Constant.greyshade100),
                  ),
                  child: Text(
                    _restaurantAddress,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_24),

            SizedBox(
              width: double.infinity,
              height: Constant.TEXT_FIELD_HEIGHT,
              child: ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeData.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                  ),
                  elevation: Constant.SIZE_02,
                ),
                child: Text(
                  Strings.SUBMIT_REQUEST,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestList() {
    if (_requests.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.list_alt,
              size: Constant.CONTAINER_SIZE_64,
              color: Constant.greyshade100,
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_16),
            Text(
              Strings.NO_CONTAINER_REQUESTS_YET,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.REQUEST_HISTORY,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: Constant.CONTAINER_SIZE_16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _requests.length,
          separatorBuilder: (context, index) => SizedBox(height: Constant.CONTAINER_SIZE_12),
          itemBuilder: (context, index) {
            final request = _requests[index];
            return _buildRequestItem(request);
          },
        ),
      ],
    );
  }

  Widget _buildRequestItem(ContainerRequest request) {
    return Card(
      elevation: Constant.SIZE_01,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
      ),
      child: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    request.status.displayName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: request.status.color,
                ),
                if (request.canDelete)
                  IconButton(
                    onPressed: () => _deleteRequest(request.id),
                    icon: Icon(
                      Icons.delete_outline,
                      color: Constant.errorColor,
                      size: Constant.CONTAINER_SIZE_20,
                    ),
                    tooltip: Strings.DELETE_REQUEST,
                  ),
              ],
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_12),
            Row(
              children: [
                _buildInfoItem(
                  Icons.numbers,
                  '${Strings.REQUESTED}: ${request.requestedCount}',
                  Theme.of(context).textTheme.bodyMedium,
                ),
                if (request.approvedCount != null) ...[
                  SizedBox(width: Constant.CONTAINER_SIZE_16),
                  _buildInfoItem(
                    Icons.check_circle,
                    '${Strings.APPROVED}: ${request.approvedCount}',
                    Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Constant.successColor,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: Constant.SIZE_08),
            _buildInfoItem(
              Icons.access_time,
              _formatDateTime(request.requestDateTime),
              Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, TextStyle? style) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: Constant.CONTAINER_SIZE_16,
          color: style?.color ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
        SizedBox(width: Constant.SIZE_05),
        Text(text, style: style),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _containerCountController.dispose();
    super.dispose();
  }
}