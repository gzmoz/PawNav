import 'package:flutter/material.dart';

class PasswordTextFieldComponent extends StatefulWidget {
  final String hintText;
  TextEditingController controller;

  PasswordTextFieldComponent(this.hintText, this.controller, {super.key});

  @override
  State<PasswordTextFieldComponent> createState() =>
      _PasswordTextFieldComponentState();
}

class _PasswordTextFieldComponentState
    extends State<PasswordTextFieldComponent> {
  bool _isObscure = true; //don't show at first
  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    return Padding(
      padding: EdgeInsets.only(
          left: width * 0.1, right: width * 0.1, top: height * 0.01),
      child: Container(
        width: width * 0.9,
        height: height * 0.06,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: widget.controller,
          obscureText: _isObscure,
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none //remove stroke
            ),
            suffixIcon: IconButton(onPressed: (){
              setState(() {
                _isObscure = !_isObscure;
              });

            }, icon: Icon(
              _isObscure ? Icons.visibility_off : Icons.visibility,
            )),
          ),
        ),
      ),
    );
  }
}
