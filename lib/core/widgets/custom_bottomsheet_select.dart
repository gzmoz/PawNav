import 'package:flutter/material.dart';

class BottomSheetSelect extends StatefulWidget {
  final String title;
  final String placeholder;
  final String? value;
  final List<String> items;
  final ValueChanged<String> onSelected;

  const BottomSheetSelect({
    super.key,
    required this.title,
    required this.placeholder,
    required this.items,
    required this.onSelected,
    this.value,
  });

  @override
  State<BottomSheetSelect> createState() => _BottomSheetSelectState();
}

class _BottomSheetSelectState extends State<BottomSheetSelect> {
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
            onTap: widget.items.isEmpty
                ? null
                : () {
              _focusNode.requestFocus();
              _openBottomSheet(context);
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
                      widget.value ?? widget.placeholder,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
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

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return _BottomSheetList(
          items: widget.items,
          selectedValue: widget.value,
          onSelected: (val) {
            Navigator.pop(context);
            widget.onSelected(val);

            _focusNode.unfocus();
          },
        );
      },
    ).whenComplete(() {
      _focusNode.unfocus();
    });
  }
}




class _BottomSheetList extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String> onSelected;

  const _BottomSheetList({
    required this.items,
    required this.onSelected,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),

          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item == selectedValue;

                return GestureDetector(
                  onTap: () => onSelected(item),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.shade50
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF2563EB)
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.black87,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check,
                            color: Colors.blue,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


