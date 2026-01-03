import 'package:flutter/material.dart';

import '../../../constants/number_constants.dart';

class SortFilterDialog extends StatefulWidget {
  const SortFilterDialog({Key? key}) : super(key: key);

  @override
  State<SortFilterDialog> createState() => _SortFilterDialogState();
}

class _SortFilterDialogState extends State<SortFilterDialog> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
        ),
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
        child: Stack(
          children: [
            Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dragHandle(theme),
              SizedBox(height: Constant.SIZE_15),
              _title(theme),
              SizedBox(height: Constant.CONTAINER_SIZE_20),
              _options(theme),
              SizedBox(height: Constant.CONTAINER_SIZE_25),
              _buttons(theme),
            ],
          ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: Constant.CONTAINER_SIZE_24,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
        ],
        ),
      ),
    );
  }



  Widget _dragHandle(ThemeData theme) {
    return Container(
      height: Constant.SIZE_04,
      width: Constant.CONTAINER_SIZE_40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
      ),
    );
  }

  Widget _title(ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Sort by',
        style: theme.textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontSize: Constant.LABEL_TEXT_SIZE_20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _options(ThemeData theme) {
    return Column(
      children: [
        _radioTile(
          theme: theme,
          title: 'Newest first to oldest',
          value: Constant.MAX_LINE_0,
        ),
        //todo this may needed
        // SizedBox(height: Constant.SIZE_15),
        // _radioTile(
        //   theme: theme,
        //   title: 'Borrow date — Oldest first',
        //   value: Constant.MAX_LINE_1,
        // ),
      ],
    );
  }

  Widget _radioTile({
    required ThemeData theme,
    required String title,
    required int value,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontSize: Constant.LABEL_TEXT_SIZE_16,
            ),
          ),
        ),
        RadioTheme(
          data: RadioThemeData(
            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return Constant.gold;
              }
              return Constant.gold;
            }),
          ),
          child: Radio<int>(
            value: value,
            groupValue: _selectedIndex,
            onChanged: (val) {
              setState(() {
                _selectedIndex = val;
              });
            },
          ),
        ),
      ],
    );
  }


  Widget _buttons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color:Constant.gold,
                width: Constant.SIZE_01,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(Constant.CONTAINER_SIZE_16),
              ),
              padding: EdgeInsets.symmetric(
                vertical: Constant.CONTAINER_SIZE_12,
              ),
            ),
            onPressed: () {
              setState(() {
                _selectedIndex = null;
              });
            },
            child: Text(
              'Clear',
              style: theme.textTheme.labelLarge?.copyWith(
                color: Constant.gold,
                fontSize: Constant.LABEL_TEXT_SIZE_16,
              ),
            ),
          ),
        ),
        SizedBox(width: Constant.SIZE_15),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Constant.gold,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(Constant.CONTAINER_SIZE_16),
              ),
              padding: EdgeInsets.symmetric(
                vertical: Constant.CONTAINER_SIZE_12,
              ),
            ),
            onPressed: () {
              Navigator.pop(context, _selectedIndex);
            },
            child: Text(
              'Apply',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.primaryColor,
                fontSize: Constant.LABEL_TEXT_SIZE_16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
