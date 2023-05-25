import 'package:flutter/material.dart';
import 'package:flutter_todo_app/controller/taskcontoller.dart';
import 'package:flutter_todo_app/ui/theme.dart';
import 'package:flutter_todo_app/ui/widgets/widgets_export.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {


  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();

  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
    25,
  ];

  String _selectedRepeat = 'none';
  List<String> repeatList = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

  int _selectedColor = 0;

  TextEditingController _titleEditController = TextEditingController();
  TextEditingController _noteEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(
          right: 20,
          left: 20,
        ),
        margin: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              MyInputField(
                title: 'Title',
                hint: "Enter your title here",
                controller: _titleEditController,
              ),
              MyInputField(
                  title: 'Note',
                  hint: "Enter your note here",
                  controller: _noteEditController),
              MyInputField(
                onlyRead: true,
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      onlyRead: true,
                      title: "Start Date",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: MyInputField(
                      onlyRead: true,
                      title: "End Date",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              MyInputField(
                onlyRead: true,
                title: 'Remind',
                hint: '$_selectedRemind minutes early',
                widget: buildDropdownButton(remindList, true),
              ),
              MyInputField(
                onlyRead: true,
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: buildDropdownButton(repeatList, false),
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(label: 'Create Task', onTap: () => _validateDate()),
                ],
              ),
              const SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }

  _validateDate() {
    if (_titleEditController.text.isNotEmpty &&
        _noteEditController.text.isNotEmpty) {
      _addTaskToDB();
      Get.back();
    } else if (_titleEditController.text.isEmpty ||
        _noteEditController.text.isEmpty) {
      Get.snackbar(
        'Required',
        'Something is missing',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: context.theme.backgroundColor,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
        colorText: pinkClr,
      );
    }
  }


  _addTaskToDB()async {
    int  value = await _taskController.addTask(
      task: Task(
        title: _titleEditController.text,
        note: _noteEditController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectedDate),
        endTime: _endTime,
        color: _selectedColor,
        startTime: _startTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      )
    );
    print('my id is' + '$value' );
  }

  Column _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text('Color', style: titleStyle),
        ),
        Wrap(
          spacing: 8.0,
          children: List.generate(3, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: CircleAvatar(
                radius: 14,
                backgroundColor: index == 0
                    ? primaryClr
                    : index == 1
                        ? pinkClr
                        : yellowClr,
                child: _selectedColor == index
                    ? const Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 16,
                      )
                    : Container(),
              ),
            );
          }),
        )
      ],
    );
  }

  Widget buildDropdownButton<T>(List<T> list, bool remindList) {
    return DropdownButton<T>(
      onChanged: (T? newValue) {
        // Do something with the selected value
        if (remindList) {
          setState(() {
            _selectedRemind = newValue as int;
          });
        } else {
          setState(() {
            _selectedRepeat = newValue as String;
          });
        }
      },
      items: list.map<DropdownMenuItem<T>>((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 4,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/img.png'),
        ),
        SizedBox(width: 20)
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
    );

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();

    String _formatedTime = pickedTime.format(context);

    if (pickedTime == null) {
      print('error');
    } else if (isStartTime) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (!isStartTime) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour: int.parse(_startTime.substring(0, 2)),
          minute: int.parse(_startTime.substring(3, 5))),
      initialEntryMode: TimePickerEntryMode.input,
    );
  }
}
