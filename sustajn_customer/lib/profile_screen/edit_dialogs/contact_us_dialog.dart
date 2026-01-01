
import 'package:flutter/material.dart';
import '../../constants/number_constants.dart';

class ContactUsDialog extends StatefulWidget {
  const ContactUsDialog({Key? key}) : super(key: key);

  @override
  State<ContactUsDialog> createState() =>
      _ContactUsDialogState();
}

class _ContactUsDialogState extends State<ContactUsDialog> {




  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Constant.CONTAINER_SIZE_16),
              topRight: Radius.circular(Constant.CONTAINER_SIZE_16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Contact Us',
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: Constant.LABEL_TEXT_SIZE_18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius:
                    BorderRadius.circular(Constant.CONTAINER_SIZE_20),
                    child: Icon(
                      Icons.close,
                      size: Constant.CONTAINER_SIZE_20,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_16,),
              Row(
                children: [
                  Icon(Icons.phone, size: Constant.CONTAINER_SIZE_18,color: Colors.white,),
                  SizedBox(width: Constant.SIZE_10,),
                  Text(
                    '7865432134',
                    style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white
                    ),
                  ),
                ],
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_20,),
              Row(
                children: [
                  Icon(Icons.email, size: Constant.CONTAINER_SIZE_18,color: Colors.white,),
                  SizedBox(width: Constant.SIZE_10,),
                  Text(
                    'example@gmail.com',
                    style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white
                    ),
                  ),
                ],
              ),



            ],
          ),
        ),
      ),
    );
  }
}
