import 'package:flutter/material.dart';
import 'package:simple_todo_app/utils/fonts.dart';

class ActivityWidget extends StatefulWidget {
  final String selectedImage;
  final Function(String) onImageSelected;
  const ActivityWidget({
    Key? key,
    required this.selectedImage,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  State<ActivityWidget> createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<ActivityWidget> {
  void openImageSelectionModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 3;
            double imageRadius = 30;

            if (constraints.maxWidth > 600) {
              crossAxisCount = 4;
              imageRadius = 40;
            }
            if (constraints.maxWidth > 900) {
              crossAxisCount = 6;
              imageRadius = 50;
            }

            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('Select an Image', style: fontMonserrat.copyWith(fontSize: 12.0, color: Colors.black),)),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  )
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: imageList.length,
                  itemBuilder: (context, index) {
                    final image = imageList[index];
                    return GestureDetector(
                      onTap: () {
                        widget.onImageSelected(image);
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: imageRadius,
                        backgroundImage: AssetImage(image),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  final List<String> imageList = [
    'assets/images/camping.png',
    'assets/images/football.png',
    'assets/images/laptop.png',
    'assets/images/reading.png',
    'assets/images/shopping.png',
    'assets/images/tourist.png',
    'assets/images/yoga.png',
  ];

  @override
  Widget build(BuildContext context) {
    double imageRadius = MediaQuery.of(context).size.width > 600 ? 50 : 40;

    return GestureDetector(
      onTap: () => openImageSelectionModal(context),
      child: widget.selectedImage.isEmpty
          ? CircleAvatar(
              radius: imageRadius,
              child: Icon(Icons.add, size: imageRadius),
            )
          : CircleAvatar(
              radius: imageRadius,
              backgroundImage: AssetImage(widget.selectedImage),
            ),
    );
  }
}