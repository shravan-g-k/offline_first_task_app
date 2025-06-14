import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/home/cubit/task_cubit.dart';
import 'package:frontend/features/home/pages/add_new_task_page.dart';
import 'package:frontend/features/home/widgets/date_selector.dart';
import 'package:frontend/features/home/widgets/task_card.dart';
import 'package:frontend/models/task_model.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  static MaterialPageRoute route() => MaterialPageRoute(
        builder: (context) => const HomePage(),
      );
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    AuthUserLoggedIn user = context.read<AuthCubit>().state as AuthUserLoggedIn;
    String token = user.user.token;
    context.read<TaskCubit>().getTask(token: token);
    Connectivity().onConnectivityChanged.listen((event) {
      if (event.contains(ConnectivityResult.wifi)) {
        // ignore: use_build_context_synchronously
        context.read<TaskCubit>().getTask(token: token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewTaskPage.route());
            },
            icon: const Icon(
              CupertinoIcons.add,
            ),
          )
        ],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          List<TaskModel> tasks = [];
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TaskError) {
            return Center(
              child: Text(state.error),
            );
          } else if (state is GetTasksSuccess) {
            tasks = state.tasks.where((task) {
              return DateFormat('d').format(task.dueAt) ==
                      DateFormat('d').format(selectedDate) &&
                  selectedDate.month == task.dueAt.month &&
                  selectedDate.year == task.dueAt.year;
            }).toList();
          }

          return Column(
            children: [
              DateSelector(
                selectedDate: selectedDate,
                onTap: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Row(
                        children: [
                          Expanded(
                            child: TaskCard(
                              color: task.hexColor,
                              headerText: task.title,
                              descriptionText: task.description,
                            ),
                          ),
                        ],
                      );
                    }),
              )
            ],
          );
        },
      ),
    );
  }
}
