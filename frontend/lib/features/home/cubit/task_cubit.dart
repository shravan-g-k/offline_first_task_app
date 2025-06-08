import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constant/utils.dart';
import 'package:frontend/features/home/repo/task_remote_repo.dart';
import 'package:frontend/models/task_model.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  final TaskRemoteRepo _taskRemoteRepo = TaskRemoteRepo();

  Future<void> createNewTask({
    required String title,
    required String description,
    required Color hexColor,
    required String token,
    required DateTime dueAt,
  }) async {
    try {
      emit(TaskLoading());

      final TaskModel task = await _taskRemoteRepo.createTask(
        title: title,
        description: description,
        hexColor: rgbToHex(hexColor),
        token: token,
        dueAt: dueAt,
      );

      emit(AddNewTaskSuccess(task));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
  Future<void> getTask({
  
    required String token,
  }) async {
    try {
      emit(TaskLoading());

      final List<TaskModel> tasks = await _taskRemoteRepo.getTasks(

        token: token,
      );

      emit(GetTasksSuccess(tasks));
    } catch (e,s) {
      emit(TaskError(e.toString()));
    }
  }
}
