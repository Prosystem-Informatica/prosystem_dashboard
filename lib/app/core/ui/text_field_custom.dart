import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldCustom extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final List<TextInputFormatter>? formatters;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? inputType;
  final ValueChanged<String>? onChanged;

  const TextFieldCustom({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.formatters,
    this.validator,
    this.obscureText = false,
    this.inputType,
    this.onChanged
  });

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 14.33,
            color: Colors.black,
            fontWeight: FontWeight.w500,)
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 41,
          width: 300,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Color(0xFF0511F2),
              width: 2,
            ),
          ),
          child: TextFormField(
              validator: widget.validator,
              scrollPadding: EdgeInsets.zero,
              textAlignVertical: TextAlignVertical.center,
              controller: widget.controller,
              obscureText: widget.obscureText,
              style: TextStyle(color: Colors.black),
              inputFormatters: widget.formatters,
              onChanged: widget.onChanged,
              keyboardType: widget.inputType,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.black.withOpacity(.32)),
              )
          ),
        ),
      ],
    );
  }
}
