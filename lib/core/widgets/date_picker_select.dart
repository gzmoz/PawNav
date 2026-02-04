import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerSelect extends StatefulWidget {
  final String title;
  final String placeholder;
  final DateTime? value;
  final ValueChanged<DateTime> onSelected;

  const DatePickerSelect({
    super.key,
    required this.title,
    required this.placeholder,
    required this.onSelected,
    this.value,
  });

  @override
  State<DatePickerSelect> createState() => _DatePickerSelectState();
}

class _DatePickerSelectState extends State<DatePickerSelect> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasFocus = _focusNode.hasFocus;

    final Color activeColor =
    hasFocus ? const Color(0xFF2563EB) : const Color(0xFFD1D5DB);

    final String displayText = widget.value == null
        ? widget.placeholder
        : DateFormat('dd MMM yyyy').format(widget.value!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 16, 4),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
        ),

        Focus(
          focusNode: _focusNode,
          child: InkWell(
            onTap: () async {
              _focusNode.requestFocus();

              final picked = await showDatePicker(
                context: context,
                initialDate: widget.value ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF2563EB),       // header, selected date, OK button
                        onPrimary: Colors.white,          // header text
                        surface: Colors.white,            // dialog background
                        onSurface: Colors.black,           // normal text
                      ),

                      dialogBackgroundColor: Colors.white,

                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFF2563EB), // OK / CANCEL
                        ),
                      ),

                      datePickerTheme: DatePickerThemeData(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(
                            color: Color(0xFF2563EB), //  kenar rengi
                            width: 1.2,
                          ),
                        ),

                        todayBorder: const BorderSide(
                          color: Color(0xFF2563EB),
                          width: 1.2,
                        ),

                        todayForegroundColor:
                        MaterialStatePropertyAll(Colors.black),


                        dayForegroundColor:
                        MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.white;
                          }
                          return Colors.black;
                        }),


                        dayBackgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Color(0xFF2563EB);
                          }
                          return null;
                        }),
                      ),
                    ),
                    child: child!,
                  );
                },
              );


              if (picked != null) {
                widget.onSelected(picked);
              }

              _focusNode.unfocus();
            },
            borderRadius: BorderRadius.circular(12),
            child: InputDecorator(
              decoration: InputDecoration(
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD1D5DB),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF2563EB),
                    width: 1,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      displayText,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: activeColor,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: activeColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
