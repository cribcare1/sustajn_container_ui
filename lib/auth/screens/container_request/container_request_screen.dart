import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/number_constants.dart';
import 'container_request_model.dart';
import 'google_map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ContainerRequestScreen(),
    );
  }
}

class ContainerRequestScreen extends StatefulWidget {
  const ContainerRequestScreen({Key? key}) : super(key: key);

  @override
  State<ContainerRequestScreen> createState() => _ContainerRequestScreenState();
}

class _ContainerRequestScreenState extends State<ContainerRequestScreen> {
  List<ContainerRequest> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _requests = ContainerRequest.sampleRequests;
        _isLoading = false;
      });
    });
  }

  void _openMaps(double lat, double lng, String address) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch Google Maps'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildRequestCard(ContainerRequest request) {
    return Card(
      elevation: Constant.SIZE_02,
      margin: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.SIZE_08,
      ),
      child: Container(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Constant.blueshade100.withOpacity(0.3), Constant.tealshade100.withOpacity(0.3)],
          ),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    request.restaurantName,
                    style: TextStyle(
                      fontSize: Constant.LABEL_TEXT_SIZE_18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Constant.CONTAINER_SIZE_12,
                    vertical: Constant.SIZE_06,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(request.status),
                    borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
                  ),
                  child: Text(
                    request.status,
                    style: TextStyle(
                      fontSize: Constant.CONTAINER_SIZE_12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_12),
            // Quantity Row
            Row(
              children: [
                Icon(Icons.inventory_2, size: Constant.CONTAINER_SIZE_16, color: Constant.indigoShade100),
                SizedBox(width: Constant.SIZE_08),
                Text(
                  'Quantity:',
                  style: TextStyle(
                    fontSize: Constant.LABEL_TEXT_SIZE_14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(width: Constant.SIZE_08),
                Text(
                  '${request.requestedQuantity} containers',
                  style: TextStyle(
                    fontSize: Constant.LABEL_TEXT_SIZE_16,
                    fontWeight: FontWeight.bold,
                    color: Constant.indigoShade100,
                  ),
                ),
              ],
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_12),

            // Address Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, size: Constant.CONTAINER_SIZE_16, color: Colors.red),
                SizedBox(width: Constant.SIZE_08),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address:',
                        style: TextStyle(
                          fontSize: Constant.LABEL_TEXT_SIZE_14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: Constant.SIZE_04),
                      GestureDetector(
                        onTap: () => _openMaps(request.latitude, request.longitude, request.address),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: Constant.SIZE_04),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  request.address,
                                  style: TextStyle(
                                    fontSize: Constant.LABEL_TEXT_SIZE_14,
                                    color: Colors.blue,
                                  ),
                                  maxLines: Constant.MAX_LINE_2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: Constant.SIZE_08),
                              Icon(Icons.open_in_new, size: Constant.CONTAINER_SIZE_14, color: Colors.blue),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Constant.orangeshade100;
      case 'approved':
        return Constant.greenshade100;
      case 'rejected':
        return Constant.pinkshade100;
      default:
        return Constant.greyshade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Container Requests',
          style: TextStyle(
            fontSize: Constant.LABEL_TEXT_SIZE_20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Constant.blueshade100,
        elevation: Constant.SIZE_02,
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Constant.blueshade100),
        ),
      )
          : _requests.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2,
              size: Constant.CONTAINER_SIZE_80,
              color: Constant.greyshade100,
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_16),
            Text(
              'No Container Requests',
              style: TextStyle(
                fontSize: Constant.LABEL_TEXT_SIZE_18,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      )
          : Expanded(
            child: ListView.builder(
              itemCount: _requests.length,
              itemBuilder: (context, index) {
                return _buildRequestCard(_requests[index]);
              },
            ),
          ),
    );
  }
}