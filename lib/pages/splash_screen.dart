import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_todo_app/utils/colors.dart';
import 'package:flutter/foundation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    animationController.forward();

    // Panggil permintaan izin setelah animasi selesai
    Future.delayed(const Duration(seconds: 2), () async {
      await requestStoragePermission();
      checkFirstSeen();
    });
  }

  Future<void> checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);
    if (seen) {
      context.go('/homepage');
    } else {
      await prefs.setBool('seen', true);
      context.go('/startingpage');
    }
  }

  Future<void> requestStoragePermission() async {
    if (kIsWeb) {
      print("Platform is web, no storage permission required.");
      return;
    }

    var status = await Permission.storage.status;

    if (status.isGranted) {
      print("Storage permission already granted.");
    } else if (status.isDenied) {
      status = await Permission.storage.request();

      if (status.isGranted) {
        print("Storage permission granted.");
      } else {
        print("Storage permission denied.");
      }
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Opacity(
              opacity: animation.value,
              child: child,
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/logo.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
