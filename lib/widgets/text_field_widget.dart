import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextController extends StatefulWidget {
  final String placeholder;
  final IconData? iconData;
  final TextEditingController controller;
  final TextInputType inputType;
  final List<TextInputFormatter> inputFormatter;
  final double width;
  final double height;

  const CustomTextController({
    super.key,
    required this.placeholder,
    this.iconData,
    required this.inputType,
    required this.inputFormatter,
    required this.controller,
    this.width = double.infinity,
    this.height = 50.0,
  });

  @override
  State<CustomTextController> createState() => _CustomTextControllerState();
}

class _CustomTextControllerState extends State<CustomTextController> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.8,
      height: widget.height,
      // padding: EdgeInsets.symmetric(
      //   horizontal: screenWidth > 600 ? 50.0 : 16.0,
      // ),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.inputType,
        inputFormatters: widget.inputFormatter,
        decoration: InputDecoration(
          prefixIcon: widget.iconData != null ? Icon(widget.iconData) : null,
          hintText: widget.placeholder,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
