

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/controller/taskcontoller.dart';
import 'package:get/get.dart';

import '../model/task.dart';
import 'theme.dart';
class MyBottomSheet{

  TaskController _taskController = Get.put(TaskController());

  editButton(Task task){
    return bottomSheetButton(
      label: 'Edit Task',
      onTap: () {
        _taskController.markTaskCompleted(task.id!);
        Get.back();
      },
      clr: primaryClr,
    );
  }

  isCompletedButtom(Task task) {
    return bottomSheetButton(
      label: 'Task Completed',
      onTap: () {
        _taskController.markTaskCompleted(task.id!);
        Get.back();
      },
      clr: primaryClr,
    );
  }

  deleteTaskButton(Task task) {
    return bottomSheetButton(
      label: 'Delete Task',
      onTap: () {
        _taskController.delete(task);
        Get.back();
      },
      clr: Colors.red[300]!,
    );
  }

  closeButton() {
    return bottomSheetButton(
      label: ' Close ',
      onTap: () => Get.back(),
      clr: Colors.red[300]!,
      isClose: true,
    );
  }

  bottomSheetButton(
      {required String label,
        required Function()? onTap,
        required Color clr,
        BuildContext? context,
        bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 55,
        width: MediaQuery.of(context!).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true ? Colors.red : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
            isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}