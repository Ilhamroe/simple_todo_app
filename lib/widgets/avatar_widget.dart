import 'package:flutter/material.dart';
import 'package:simple_todo_app/utils/fonts.dart';

class AvatarPicker extends StatefulWidget {
  final String selectedAvatar;
  final Function(String) onAvatarSelected;

  const AvatarPicker({
    Key? key,
    required this.selectedAvatar,
    required this.onAvatarSelected,
  }) : super(key: key);

  @override
  _AvatarPickerState createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  void openAvatarSelectionModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 3; 
            double avatarRadius = 30; 

            if (constraints.maxWidth > 600) {
              crossAxisCount = 4;
              avatarRadius = 40;
            }
            if (constraints.maxWidth > 900) {
              crossAxisCount = 6;
              avatarRadius = 50;
            }

            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  Expanded(
                      child: Text(
                    'Select an Avatar',
                    style: fontMonserrat.copyWith(
                        fontSize: 12.0, color: Colors.black),
                  )),
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
                  itemCount: avatarList.length,
                  itemBuilder: (context, index) {
                    final avatar = avatarList[index];
                    return GestureDetector(
                      onTap: () {
                        widget.onAvatarSelected(avatar);
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: avatarRadius,
                        backgroundImage: AssetImage(avatar),
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

  final List<String> avatarList = [
    'assets/images/ava1.png',
    'assets/images/ava2.png',
    'assets/images/ava3.png',
    'assets/images/ava4.png',
    'assets/images/ava5.png',
    'assets/images/ava6.png',
  ];

  @override
  Widget build(BuildContext context) {
    double avatarRadius = MediaQuery.of(context).size.width > 600 ? 50 : 40;

    return GestureDetector(
      onTap: () => openAvatarSelectionModal(context),
      child: widget.selectedAvatar.isEmpty
          ? CircleAvatar(
              radius: avatarRadius,
              child: Icon(Icons.add, size: avatarRadius),
            )
          : CircleAvatar(
              radius: avatarRadius,
              backgroundImage: AssetImage(widget.selectedAvatar),
            ),
    );
  }
}
