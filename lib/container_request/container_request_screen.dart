import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/number_constants.dart';
import '../common_widgets/custom_app_bar.dart';
import 'container_request_model.dart';


class ContainerRequestScreen extends StatefulWidget {
  const ContainerRequestScreen({super.key});

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

  void _updateRequestStatus(String id, String status, int? approvedQuantity) {
    setState(() {
      final index = _requests.indexWhere((request) => request.id == id);
      if (index != -1) {
        _requests[index] = _requests[index].copyWith(
          status: status,
          approvedQuantity: approvedQuantity,
        );
      }
    });
  }

  void _showApproveDialog(ContainerRequest request) {
    int approvedQuantity = request.requestedQuantity;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('Approve Request', style: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_18)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${request.restaurantName}', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: Constant.CONTAINER_SIZE_12),
                Text('Requested: ${request.requestedQuantity} containers'),
                SizedBox(height: Constant.CONTAINER_SIZE_16),
                Row(
                  children: [
                    Text('Approve:', style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(width: Constant.CONTAINER_SIZE_12),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12),
                        decoration: BoxDecoration(
                          color: Constant.blueshade100,
                          borderRadius: BorderRadius.circular(Constant.SIZE_08),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, size: Constant.CONTAINER_SIZE_16),
                              onPressed: () {
                                if (approvedQuantity > 1) {
                                  setDialogState(() => approvedQuantity--);
                                }
                              },
                            ),
                            Expanded(
                              child: Text(
                                '$approvedQuantity',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, size: Constant.CONTAINER_SIZE_16),
                              onPressed: () {
                                setDialogState(() => approvedQuantity++);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: Constant.greyshade100)),
              ),
              ElevatedButton(
                onPressed: () {
                  _updateRequestStatus(request.id, 'Approved', approvedQuantity);
                  Navigator.pop(context);
                  _showSuccessSnackbar('Request approved for $approvedQuantity containers');
                },
                style: ElevatedButton.styleFrom(backgroundColor: Constant.greenshade100),
                child: Text('Approve', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showRejectDialog(ContainerRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reject Request', style: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_18)),
        content: Text('Are you sure you want to reject the container request from ${request.restaurantName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Constant.greyshade100)),
          ),
          ElevatedButton(
            onPressed: () {
              _updateRequestStatus(request.id, 'Rejected', null);
              Navigator.pop(context);
              _showSuccessSnackbar('Request rejected');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Constant.pinkshade100),
            child: Text('Reject', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Constant.greenshade100,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openMaps(double lat, double lng, String address) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch Google Maps'), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildRequestCard(ContainerRequest request) {
    return Card(
      elevation: Constant.SIZE_02,
      margin: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16, vertical: Constant.SIZE_08),
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
                  padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12, vertical: Constant.SIZE_06),
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

            // Quantity Information
            _buildInfoRow(
              icon: Icons.inventory_2,
              label: 'Quantity:',
              value: '${request.requestedQuantity} containers',
              iconColor: Constant.indigoShade100,
            ),

            if (request.status == 'Approved' && request.approvedQuantity != null)
              _buildInfoRow(
                icon: Icons.check_circle,
                label: 'Approved:',
                value: '${request.approvedQuantity} containers',
                iconColor: Constant.greenshade100,
              ),

            SizedBox(height: Constant.CONTAINER_SIZE_12),

            // Address Section
            _buildAddressSection(request),


            if (request.status == 'Pending') ...[
              SizedBox(height: Constant.CONTAINER_SIZE_16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showRejectDialog(request),
                      icon: Icon(Icons.close, size: Constant.CONTAINER_SIZE_16),
                      label: Text('Reject'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constant.pinkshade100,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_12),
                      ),
                    ),
                  ),
                  SizedBox(width: Constant.CONTAINER_SIZE_12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showApproveDialog(request),
                      icon: Icon(Icons.check, size: Constant.CONTAINER_SIZE_16),
                      label: Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constant.greenshade100,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value, required Color iconColor}) {
    return Row(
      children: [
        Icon(icon, size: Constant.CONTAINER_SIZE_16, color: iconColor),
        SizedBox(width: Constant.SIZE_08),
        Text(label, style: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_14, fontWeight: FontWeight.w600, color: Colors.black54)),
        SizedBox(width: Constant.SIZE_08),
        Text(value, style: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_16, fontWeight: FontWeight.bold, color: Constant.indigoShade100)),
      ],
    );
  }

  Widget _buildAddressSection(ContainerRequest request) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_on, size: Constant.CONTAINER_SIZE_16, color: Colors.red),
        SizedBox(width: Constant.SIZE_08),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Address:', style: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_14, fontWeight: FontWeight.w600, color: Colors.black54)),
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
                          style: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_14, color: Colors.blue),
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
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Constant.orangeshade100;
      case 'approved': return Constant.greenshade100;
      case 'rejected': return Constant.pinkshade100;
      default: return Constant.greyshade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          leading: const SizedBox(),
          title: "Container Requests").getAppBar(context),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Constant.blueshade100)))
          : _requests.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2, size: Constant.CONTAINER_SIZE_80, color: Constant.greyshade100),
            SizedBox(height: Constant.CONTAINER_SIZE_16),
            Text('No Container Requests', style: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_18, color: Colors.black54)),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _requests.length,
        itemBuilder: (context, index) => _buildRequestCard(_requests[index]),
      ),
    );
  }
}