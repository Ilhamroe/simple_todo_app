import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_todo_app/db/db_profiles.dart';
import 'package:simple_todo_app/utils/colors.dart';
import 'package:simple_todo_app/utils/fonts.dart';
import 'package:simple_todo_app/widgets/avatar_widget.dart';
import 'package:simple_todo_app/widgets/button_widget.dart';
import 'package:simple_todo_app/widgets/text_field_widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController nameController = TextEditingController();
  String selectedAvatar = '';

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final profileData = await ProfileService.loadProfile();

    setState(() {
      nameController.text = profileData['name'] ??
          '';
      selectedAvatar =
          profileData['avatar'] ?? '';
    });
  }

  Future<void> saveProfile(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final name = nameController.text;

    if (name.isEmpty || selectedAvatar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan Avatar harus diisi')),
      );
      return;
    }

    await ProfileService.updateProfile(name, selectedAvatar);

    print("Nama yang diketik: $name");
    print("Avatar yang dipilih: $selectedAvatar");

    context.go('/homepage'); 
  }

  void onAvatarSelected(String avatar) {
    setState(() {
      selectedAvatar = avatar;
    });
  }

  Future<bool?> showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text(
              'Apakah kamu yakin ingin menghapus profil dan semua aktivitas?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => context.go('/homepage'),
            icon: const Icon(Icons.arrow_back)),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Edit Profile',
            style: fontNunito.copyWith(
              fontSize: 21.0,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                      textButton: 'Simpan Perubahan',
                    ),
                    const SizedBox(height: 20),
                    ButtonWidget(
                      onTap: () async {
                        final shouldDelete =
                            await showDeleteConfirmationDialog(context);
                        if (shouldDelete == true) {
                          await ProfileService.deleteProfileAndTodos();
                          context.go('/homepage');
                        }
                      },
                      color: Colors.red,
                      textButton: 'Hapus Profil & Todo',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
