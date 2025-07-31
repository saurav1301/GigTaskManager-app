import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskCard extends StatelessWidget {
  final DocumentSnapshot taskDoc;

  const TaskCard({super.key, required this.taskDoc});

  @override
  Widget build(BuildContext context) {
    final title = taskDoc['title'] ?? '';
    final Timestamp timestamp = taskDoc['date'] as Timestamp;
    final DateTime date = timestamp.toDate();
    final tags = List<String>.from(taskDoc['tags'] ?? []);
    final isDone = taskDoc['isDone'] ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDone ? Colors.grey[200] : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isDone ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? Colors.grey : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('d MMM').format(date),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Row(
            children: tags.map((tag) {
              Color color;
              switch (tag.toLowerCase()) {
                case 'personal':
                  color = Colors.orange;
                  break;
                case 'app':
                  color = Colors.blue;
                  break;
                case 'work':
                  color = Colors.redAccent;
                  break;
                case 'cf':
                case 'study':
                  color = Colors.purple;
                  break;
                default:
                  color = Colors.grey;
              }
              return Container(
                margin: const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
