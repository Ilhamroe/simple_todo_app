import 'package:hive/hive.dart';
import 'package:simple_todo_app/db/db_todos.dart';

class ProfileService {
  static const String _boxName = 'profileBox';

  // Open the Hive box
  static Future<Box> openBox() async {
    return await Hive.openBox(_boxName);
  }

  // Save profile to Hive
  static Future<void> saveProfile(String name, String avatar) async {
    var box = await openBox();
    await box.put('name', name);
    await box.put('avatar', avatar);
  }

  // Load profile from Hive
  static Future<Map<String, String>> loadProfile() async {
    var box = await openBox();
    final name = box.get('name', defaultValue: '');
    final avatar = box.get('avatar', defaultValue: '');

    return {'name': name, 'avatar': avatar};
  }

  // Update profile data
  static Future<void> updateProfile(String name, String avatar) async {
    var box = await openBox();
    await box.put('name', name);
    await box.put('avatar', avatar);
  }

  // Delete profile data
  static Future<void> deleteProfile() async {
    var box = await openBox();
    await box.delete('name');
    await box.delete('avatar');
  }

  // Delete profile and all todos
  static Future<void> deleteProfileAndTodos() async {
    var box = await openBox();

    await box.delete('name');
    await box.delete('avatar');

    await TodoService.deleteAllTodos();

    print('Profile and all todos have been deleted');
  }
}

// Save profile using the ProfileService
// Future<void> saveProfile() async {
//   FocusScope.of(context).unfocus();
//   final name = nameController.text;

//   if (name.isEmpty || selectedAvatar.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Name and Avatar must be selected')),
//     );
//     return;
//   }

//   await ProfileService.saveProfile(name, selectedAvatar);
//   print("Nama yang diketik: $name");
//   print("Avatar yang dipilih: $selectedAvatar");

//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text('Profile saved!')),
//   );
// }

  // // Load profile using the ProfileService
  // Future<void> loadProfile() async {
  //   final profile = await ProfileService.loadProfile();
  //   setState(() {
  //     nameController.text = profile['name'] ?? '';
  //     selectedAvatar = profile['avatar'] ?? '';
  //   });
  // }

  // // Update profile (reuse saveProfile method)
  // Future<void> updateProfile() async {
  //   final name = nameController.text;
  //   await ProfileService.updateProfile(name, selectedAvatar);
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Profile updated!')),
  //   );
  // }

  // // Delete profile using ProfileService
  // Future<void> deleteProfile() async {
  //   await ProfileService.deleteProfile();
  //   setState(() {
  //     nameController.clear();
  //     selectedAvatar = '';
  //   });
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Profile deleted!')),
  //   );
  // }