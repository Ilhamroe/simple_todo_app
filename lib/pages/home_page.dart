import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_todo_app/db/db_todos.dart';
import 'package:simple_todo_app/utils/colors.dart';
import 'package:simple_todo_app/utils/fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nameController = TextEditingController();
  String selectedAvatar = '';
  String greeting = '';
  IconData greetingIcon = Icons.wb_sunny;
  List<Map<String, dynamic>> todos = [];

  @override
  void initState() {
    super.initState();
    loadProfile();
    setGreeting();
    loadTodos();
  }

  Future<void> loadTodos() async {
    final todoData = await TodoService.getAllData();

    print("Todo data loaded: $todoData");

    setState(() {
      todos = todoData;
    });
  }

  Future<void> loadProfile() async {
    final box = Hive.box('profileBox');
    setState(() {
      nameController.text = box.get('name') ?? '';
      selectedAvatar = box.get('avatar') ?? '';
    });
  }

  void setGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      greeting = 'Selamat Pagi';
      greetingIcon = Icons.wb_sunny;
    } else if (hour >= 12 && hour < 15) {
      greeting = 'Selamat Siang';
      greetingIcon = Icons.wb_sunny_outlined;
    } else if (hour >= 15 && hour < 18) {
      greeting = 'Selamat Sore';
      greetingIcon = Icons.wb_twilight;
    } else {
      greeting = 'Selamat Malam';
      greetingIcon = Icons.nights_stay;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        surfaceTintColor: bgColor,
        backgroundColor: bgColor,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Hallo ${nameController.text}',
            style: fontMonserrat.copyWith(fontSize: 26.0, color: Colors.black),
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                context.go('/settings');
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(greetingIcon, size: 26, color: Colors.amber),
                Text(
                  greeting,
                  style:
                      fontMonserrat.copyWith(color: Colors.grey, fontSize: 21),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (todos.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "Tidak ada aktivitas yang tersedia.",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 4 : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    final startTime = todo['startTime'] as DateTime;
                    final endTime = todo['endTime'] as DateTime;
                    final duration = endTime.difference(startTime);
                    final durationHours = duration.inHours;
                    final durationMinutes = duration.inMinutes.remainder(60);

                    return GestureDetector(
                      onTap: () {
                        context.go(
                          '/assigntodo',
                          extra: {
                            'todo': todo,
                            'isEdit': true,
                          },
                        );
                      },
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (todo['image'] != null &&
                                  todo['image'].isNotEmpty)
                                Image.asset(todo['image'],
                                    height: 80, fit: BoxFit.cover)
                              else
                                const Icon(Icons.image_not_supported, size: 80),
                              Text(
                                todo['description'] ?? 'No Description',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Rating: ${todo['favoriteRating'] ?? 0}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Duration: ${durationHours}h ${durationMinutes}m',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(
            '/assigntodo',
            extra: {
              'todo': null,
              'isEdit': false,
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
