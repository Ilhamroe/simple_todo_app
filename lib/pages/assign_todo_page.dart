import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_todo_app/db/db_todos.dart';
import 'package:simple_todo_app/utils/colors.dart';
import 'package:simple_todo_app/utils/fonts.dart';
import 'package:simple_todo_app/widgets/activity_widget.dart';
import 'package:simple_todo_app/widgets/button_widget.dart';
import 'package:simple_todo_app/widgets/text_field_widget.dart';

class AssignTodoPage extends StatefulWidget {
  final Map<String, dynamic>? todo;
  final bool isEdit;

  const AssignTodoPage({
    Key? key,
    this.todo,
    this.isEdit = false,
  }) : super(key: key);

  @override
  State<AssignTodoPage> createState() => _AssignTodoPageState();
}

class _AssignTodoPageState extends State<AssignTodoPage> {
  final TextEditingController descriptionController = TextEditingController();
  late DateTime startTime = DateTime.now();
  late DateTime endTime = DateTime.now();
  String selectedImage = '';
  int favoriteRating = 0;

  @override
  void initState() {
    super.initState();

    if (widget.isEdit && widget.todo != null) {
      final todo = widget.todo!;
      descriptionController.text = todo['description'] ?? '';
      selectedImage = todo['image'] ?? '';
      favoriteRating = todo['favoriteRating'] ?? 0;
      startTime = todo['startTime'] ?? DateTime.now();
      endTime = todo['endTime'] ?? DateTime.now();
    } else {
      startTime = DateTime.now();
      endTime = DateTime.now();
    }
  }

  Future<void> saveTodo(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final description = descriptionController.text;

    if (description.isEmpty || selectedImage.isEmpty || favoriteRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    if (widget.isEdit) {
      // edit todo
      await TodoService.updateDataById(
        widget.todo!['id'],
        selectedImage,
        description,
        favoriteRating,
        startTime,
        endTime,
      );
    } else {
      // simpan todo
      await TodoService.saveTodo(
        selectedImage,
        description,
        favoriteRating,
        startTime,
        endTime,
      );
    }

    context.go('/homepage');
  }

  Future<void> handleDeleteTodo() async {
    if (widget.todo != null && widget.todo!.containsKey('id')) {
      final int todoId = widget.todo!['id'];
      final bool? shouldDelete = await showDeleteConfirmationDialog(context);

      if (shouldDelete == true) {
        await TodoService.deleteDataById(todoId);
        context.go('/homepage');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todo tidak ditemukan!')),
      );
    }
  }

  Widget buildRatingStars(double screenWidth) {
    double iconSize = screenWidth > 600 ? 40.0 : 20.0;

    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          padding: EdgeInsets.zero,
          iconSize: iconSize,
          icon: Icon(
            index < favoriteRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              favoriteRating = index + 1;
            });
          },
        );
      }),
    );
  }


  void onImageSelected(String image) {
    setState(() {
      selectedImage = image;
    });
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(startTime),
    );
    if (picked != null) {
      setState(() {
        startTime = DateTime(startTime.year, startTime.month, startTime.day,
            picked.hour, picked.minute);
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(endTime),
    );
    if (picked != null) {
      setState(() {
        endTime = DateTime(endTime.year, endTime.month, endTime.day,
            picked.hour, picked.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        surfaceTintColor: bgColor,
        backgroundColor: bgColor,
        leading: IconButton(onPressed: () => context.go('/homepage'), icon: const Icon(Icons.arrow_back)),
        title: Text(
          widget.isEdit ? 'Edit Aktivitas' : 'Masukkan Aktivitas Harianmu!',
          style: fontNunito.copyWith(fontSize: 21.0, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          widget.isEdit
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => handleDeleteTodo(),
                  ),
                )
              : Container(),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = MediaQuery.of(context).size.height;
          bool isWideScreen = screenWidth > 600;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ActivityWidget(
                    selectedImage: selectedImage,
                    onImageSelected: onImageSelected,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Pilih avatar',
                    style: fontMonserrat.copyWith(
                      fontSize: isWideScreen ? 40.0 : 30.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  CustomTextController(
                    placeholder: 'Masukkan Deskripsi Aktivitas',
                    iconData: Icons.description,
                    controller: descriptionController,
                    inputType: TextInputType.text,
                    inputFormatter: [
                      FilteringTextInputFormatter.singleLineFormatter
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWideScreen ? 50.0 : 10.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Rating Aktivitas:',
                                style: fontMonserrat.copyWith(
                                  fontSize: isWideScreen ? 30.0 : 21.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            buildRatingStars(
                                screenWidth),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Waktu Mulai: ${TimeOfDay.fromDateTime(startTime).format(context)}',
                                style: fontMonserrat.copyWith(
                                  fontSize: isWideScreen ? 30.0 : 21.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.access_time),
                              onPressed: () => _selectStartTime(context),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Waktu Selesai: ${TimeOfDay.fromDateTime(endTime).format(context)}',
                                style: fontMonserrat.copyWith(
                                  fontSize: isWideScreen ? 30.0 : 21.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.access_time),
                              onPressed: () => _selectEndTime(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  ButtonWidget(
                    onTap: () => saveTodo(context),
                    color: primaryColor,
                    textButton: widget.isEdit ? 'Update' : 'Save',
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<bool?> showDeleteConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah kamu yakin ingin menghapus aktivitas ini?'),
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
