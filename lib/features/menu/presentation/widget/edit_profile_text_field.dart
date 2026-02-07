import 'package:flutter/material.dart';

class EditProfileTextField extends StatefulWidget {
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
  State<EditProfileTextField> createState() =>
      _EditProfileTextFieldState();
}

class _EditProfileTextFieldState extends State<EditProfileTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  /*@override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }*/

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
  }


  @override
  void didUpdateWidget(covariant EditProfileTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // SADECE kullanıcı yazmıyorken sync et
    if (!_focusNode.hasFocus &&
        oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixText: widget.prefixText,
        suffixIcon:
        widget.suffixIcon != null ? Icon(widget.suffixIcon) : null,
        helperText: widget.helperText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}


