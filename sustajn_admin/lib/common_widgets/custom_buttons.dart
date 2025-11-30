import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onClear;
  final VoidCallback onApply;

  const ActionButtons({
    super.key,
    required this.onClear,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // CLEAR
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onClear,
            child: const Text("Clear"),
          ),
        ),

        const SizedBox(width: 16),

        // APPLY
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffC8A832),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onApply,
            child: const Text(
              "Apply",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
