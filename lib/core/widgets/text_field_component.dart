import 'package:flutter/material.dart';
import 'package:pawnav/app/theme/colors.dart';

class TextFieldComponent extends StatefulWidget {

  TextInputType? textInputType;
  String hintText;
  bool? obscureText;
  TextEditingController controller;




  TextFieldComponent({super.key, this.textInputType, required this.hintText, this.obscureText, required this.controller});


  @override
  State<TextFieldComponent> createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent> {
  @override
  Widget build(BuildContext context) {

    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    return Padding(
      padding: EdgeInsets.only(left: width *0.1, right: width * 0.1, top: height * 0.01),
      child: Container(
        width: width * 0.9,
        height: height * 0.06,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black26,
            blurRadius: 10,
            offset: Offset(2, 4),
            ),
          ],
        ),
        child: TextFormField(
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none //remove stroke
            )
          ),
          obscureText: widget.obscureText?? false,
          controller: widget.controller,
          keyboardType: widget.textInputType,
        ),
      ),
    );
  }
}
