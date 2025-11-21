import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;


  const CustomTextFormField({this.hintText, this.controller, this.prefixIcon,
      this.suffixIcon, required this.obscureText, this.keyboardType, this.validator});

  @override
  Widget build(BuildContext context) {

    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    return SizedBox(
      // height: height *0.07,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon != null
          ? Padding(
            //padding: const EdgeInsets.all(12.0),
            padding: EdgeInsets.only(left: width * 0.05, right: width *0.05),
            child: SizedBox(
                width: width * 0.05,
                height: height * 0.05,
                child: prefixIcon,
            ),
          )
          : null,
          suffixIcon: suffixIcon != null
              ? Padding(
            padding: EdgeInsets.only(right: width * 0.025),
            child: SizedBox(
                width: width * 0.05,
                height: height * 0.05,
                child: suffixIcon,
            ),
          )
              : null,
      
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      
      ),
    );
  }
}
