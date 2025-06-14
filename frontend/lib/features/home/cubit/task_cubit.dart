import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constant/utils.dart';
import 'package:frontend/features/home/repo/task_local_repo.dart';
import 'package:frontend/features/home/repo/task_remote_repo.dart';
import 'package:frontend/models/task_model.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  final TaskRemoteRepo _taskRemoteRepo = TaskRemoteRepo();
  final TaskLocalRepo _taskLocalRepo = TaskLocalRepo();


  Future<void> createNewTask({
    required String title,
    required String description,
    required Color hexColor,
    required String token,
    required DateTime dueAt,
    required String uid,
  }) async {
    try {
      emit(TaskLoading());

      final TaskModel task = await _taskRemoteRepo.createTask(
        title: title,
        description: description,
        hexColor: rgbToHex(hexColor),
        token: token,
        dueAt: dueAt,
        uid: uid,
      );

       await _taskLocalRepo.insertTask(task);

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
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> syncTasks(String token) async{
    final unsyncedTasks = await _taskLocalRepo.getUnsyncedTasks();

    if(unsyncedTasks.isEmpty) return;
    final isSynced = await _taskRemoteRepo.syncTasks(
      token:  token,
      tasks: unsyncedTasks,
    );

    if(isSynced){
      for(final task in unsyncedTasks){
        await _taskLocalRepo.updateRowValue(task.id, 1);
      }
    }
  }
}
