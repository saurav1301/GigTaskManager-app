import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rxdart/rxdart.dart';
import '../components/task_card.dart'; // Import TaskCard

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isSearchFocused = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.trim().toLowerCase();
      });
    });
  }

  Stream<DateTime> get _dateTimeStream => Stream<DateTime>.periodic(
    const Duration(seconds: 60),
    (_) => DateTime.now(),
  ).startWith(DateTime.now());

  void deleteTask(String docId) {
    FirebaseFirestore.instance.collection('tasks').doc(docId).delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Task deleted')));
  }

  void markTaskDone(DocumentSnapshot taskDoc) {
    FirebaseFirestore.instance.collection('tasks').doc(taskDoc.id).update({
      'isDone': !(taskDoc['isDone'] ?? false),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: StreamBuilder<DateTime>(
            stream: _dateTimeStream,
            builder: (context, dateSnapshot) {
              final now = dateSnapshot.data ?? DateTime.now();

              Widget section(String title, List<DocumentSnapshot> tasks) {
                if (tasks.isEmpty) return const SizedBox();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...tasks.map((taskDoc) {
                      return Slidable(
                        key: Key(taskDoc.id),
                        startActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.25,
                          children: [
                            CustomSlidableAction(
                              onPressed: (_) => markTaskDone(taskDoc),
                              backgroundColor: Colors.transparent,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                width: 50,
                                height: 50,
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.25,
                          children: [
                            CustomSlidableAction(
                              onPressed: (_) => deleteTask(taskDoc.id),
                              backgroundColor: Colors.transparent,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                width: 50,
                                height: 50,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        child: TaskCard(taskDoc: taskDoc),
                      );
                    }).toList(),
                  ],
                );
              }

              return Column(
                children: [
                  // Header Section
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C91F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.dashboard, color: Colors.white),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: isSearchFocused
                                  ? MediaQuery.of(context).size.width * 0.6
                                  : 180,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextField(
                                controller: searchController,
                                onTap: () {
                                  setState(() {
                                    isSearchFocused = true;
                                  });
                                },
                                onEditingComplete: () {
                                  setState(() {
                                    isSearchFocused = false;
                                  });
                                  FocusScope.of(context).unfocus();
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  hintText: 'Search',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const Icon(Icons.more_horiz, color: Colors.white),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Today, ${DateFormat('d MMM').format(now)}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const Text(
                          'My tasks',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('tasks')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('No tasks found'));
                        }

                        final todayTasks = <DocumentSnapshot>[];
                        final tomorrowTasks = <DocumentSnapshot>[];
                        final weekTasks = <DocumentSnapshot>[];

                        final nowDate = DateTime(now.year, now.month, now.day);
                        final tomorrowDate = nowDate.add(
                          const Duration(days: 1),
                        );

                        for (var doc in snapshot.data!.docs) {
                          final data = doc.data() as Map<String, dynamic>;
                          final taskTitle = (data['title'] as String)
                              .toLowerCase();
                          final taskDate = (data['date'] as Timestamp).toDate();
                          final taskDateOnly = DateTime(
                            taskDate.year,
                            taskDate.month,
                            taskDate.day,
                          );

                          if (searchQuery.isNotEmpty &&
                              !taskTitle.contains(searchQuery)) {
                            continue;
                          }

                          if (taskDateOnly == nowDate) {
                            todayTasks.add(doc);
                          } else if (taskDateOnly == tomorrowDate) {
                            tomorrowTasks.add(doc);
                          } else if (taskDateOnly.isAfter(tomorrowDate) &&
                              taskDateOnly.isBefore(
                                nowDate.add(const Duration(days: 7)),
                              )) {
                            weekTasks.add(doc);
                          }
                        }

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              section('Today', todayTasks),
                              section('Tomorrow', tomorrowTasks),
                              section('This Week', weekTasks),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
