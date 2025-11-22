import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../constants/number_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          leading: const SizedBox(),
          title: "Profile",action: [
        IconButton(
          icon: Icon(Icons.edit,color: Colors.white,),
          onPressed: () {},
        ),
      ]).getAppBar(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                child: Column(
                  children: [
                    // User Info
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
                      decoration: BoxDecoration(
                        color: Color(0xffe9f2ff),
                        borderRadius: BorderRadius.circular(Constant.SIZE_15),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.person,
                            size: Constant.CONTAINER_SIZE_50,
                            color: Color(0xff6eac9e),
                          ),
                          SizedBox(height: Constant.CONTAINER_SIZE_16),
                          Text(
                            'Lucky',
                            style: TextStyle(
                              fontSize: Constant.LABEL_TEXT_SIZE_24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: Constant.SIZE_08),
                          Text(
                            'lucky@example.com',
                            style: TextStyle(
                              fontSize: Constant.LABEL_TEXT_SIZE_16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Constant.CONTAINER_SIZE_20),

                    // Profile Details
                    Column(
                      children: [
                        _buildProfileItem(Icons.phone, 'Mobile Number', '2309876543'),
                        SizedBox(height: Constant.SIZE_10),
                        _buildProfileItem(Icons.location_on, 'Location', 'Bengaluru, Karnataka'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value) {
    return Container(
      height: Constant.CONTAINER_SIZE_70,
      decoration: BoxDecoration(
        color: Color(0xffe9f2ff),
        borderRadius: BorderRadius.circular(Constant.SIZE_10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: Constant.SIZE_03,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, size: Constant.CONTAINER_SIZE_24, color: Color(0xff6eac9e)),
        title: Text(
          title,
          style: TextStyle(
            fontSize: Constant.LABEL_TEXT_SIZE_14,
            color: Colors.grey.shade600,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: Constant.LABEL_TEXT_SIZE_16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}