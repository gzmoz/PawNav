import 'package:flutter/material.dart';

class EditProfileTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final bool enabled;
  final String? prefixText;
  final IconData? suffixIcon;
  final String? helperText;
  final ValueChanged<String>? onChanged;

  const EditProfileTextField({
    super.key,
    required this.label,
    required this.initialValue,
    this.enabled = true,
    this.prefixText,
    this.suffixIcon,
    this.helperText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      enabled: enabled,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefixText,
        suffixIcon:
        suffixIcon != null ? Icon(suffixIcon) : null,
        helperText: helperText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
