import 'package:flutter/material.dart';
import 'package:simple_todo_app/utils/colors.dart';
import 'package:simple_todo_app/utils/fonts.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final double width;
  final double height;
  final Color color;
  final String textButton;

  const ButtonWidget({
    Key? key,
    required this.onTap,
    this.width = double.infinity,
    this.height = 50.0,
    this.color = Colors.grey,
    required this.textButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.8,
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth > 600 ? 50.0 : 16.0,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          textButton,
          style: fontMonserrat.copyWith(color: bgColor),
        ),
      ),
    );
  }
}
