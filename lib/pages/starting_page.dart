import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_todo_app/db/db_profiles.dart';
import 'package:simple_todo_app/utils/colors.dart';
import 'package:simple_todo_app/widgets/avatar_widget.dart';
import 'package:simple_todo_app/widgets/button_widget.dart';
import 'package:simple_todo_app/widgets/text_field_widget.dart';

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  final TextEditingController nameController = TextEditingController();
  String selectedAvatar = '';

  Future<void> saveProfile(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final name = nameController.text;

    if (name.isEmpty || selectedAvatar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan Avatar harus diisi')),
      );
      return;
    }

    await ProfileService.saveProfile(name, selectedAvatar);
    // ignore: avoid_print
    print("Nama yang diketik: $name");
    // ignore: avoid_print
    print("Avatar yang dipilih: $selectedAvatar");

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Profile disimpan!')),
    // );

    context.go('/homepage');
  }

  void onAvatarSelected(String avatar) {
    setState(() {
      selectedAvatar = avatar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Kenalan dulu yuk!',
                style: TextStyle(
                    fontFamily: 'NunitoSans',
                    fontSize: 30,
                    color: primaryColor),
              ),
              Image.asset('assets/images/logo.png'),
              Column(
                children: [
                  const SizedBox(height: 10),
                  AvatarPicker(
                    selectedAvatar: selectedAvatar,
                    onAvatarSelected: onAvatarSelected,
                  ),
                  const Text('Pilih avatar', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  CustomTextController(
                    placeholder: 'Masukkan Namamu',
                    iconData: Icons.person,
                    controller: nameController,
                    inputType: TextInputType.text,
                    inputFormatter: [
                      FilteringTextInputFormatter.singleLineFormatter
                    ],
                  ),
                  const SizedBox(height: 20),
                  ButtonWidget(
                    onTap: () => saveProfile(context),
                    color: primaryColor,
                    textButton: 'Lanjut',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
