import 'package:flutter/material.dart';

class AddContainerScreen extends StatelessWidget {
  const AddContainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F3727),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    const SizedBox(width: 10),
                    const Text(
                      "Add New Container",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  "Container Information",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                buildDropdown("Select Product*"),
                buildDropdown("Select Product ID*"),
                buildTextField("Select Volume in ml (automatically populated)"),
                buildTextField("Quantity*"),

                const SizedBox(height: 20),

                const Text(
                  "Container Specification",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                buildTextArea("Container Description"),

                buildTextField("Container Material"),
                buildTextField("Container Color"),
                buildTextField("Dimension Length cm"),
                buildTextField("Dimension Height cm"),
                buildTextField("Weight Grams"),

                buildTextField("Food Safe"),
                buildTextField("Dishwash Safe"),
                buildTextField("Microwave Safe"),

                buildTextField("Max Temperature"),
                buildTextField("Min Temperature"),
                buildTextField("Lifespan Cycle"),
                buildTextField("Cost Per Unit"),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AE37),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Colors.white,
                            width: 1,
                          )
                      ),
                    ),
                    child: const Text(
                      "Add Container",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: inputDecoration(hint),
      ),
    );
  }

  Widget buildDropdown(String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        dropdownColor: const Color(0xFF0F3D2E),
        style: const TextStyle(color: Colors.white),

        hint: Text(
          hint,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),

        decoration: inputDecoration(""),

        iconEnabledColor: Colors.white,
        isExpanded: true,

        items: const [
          DropdownMenuItem(
            value: "1",
            child: Text("Option 1", style: TextStyle(color: Colors.white)),
          ),
          DropdownMenuItem(
            value: "2",
            child: Text("Option 2", style: TextStyle(color: Colors.white)),
          ),
        ],
        onChanged: (value) {},
      ),
    );
  }

  Widget buildTextArea(String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        maxLines: 4,
        maxLength: 500,
        style: const TextStyle(color: Colors.white),
        decoration: inputDecoration(hint).copyWith(
          counterStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54, fontSize: 12),
      filled: true,
      fillColor: const Color(0xFF1E5B46),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.white54),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.white54),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }
}