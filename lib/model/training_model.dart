import 'package:intl/intl.dart';

class Training {
  final String id;
  final String title;
  final String description;
  final String date;
  final String startTime;
  final String endTime;

  Training({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  factory Training.fromFirestore(Map<String, dynamic> data, String id) {
    final duration = data['trainingDuration'] ?? {};

    final startRaw = duration['start'] ?? '';
    final endRaw = duration['end'] ?? '';

    // Parse and format times
    final startDateTime = DateTime.tryParse(startRaw);
    final endDateTime = DateTime.tryParse(endRaw);

    final formattedDate = startDateTime != null
        ? DateFormat('yyyy-MM-dd').format(startDateTime)
        : 'Unknown Date';
    final formattedStart = startDateTime != null
        ? DateFormat('hh:mm a').format(startDateTime)
        : '';
    final formattedEnd =
        endDateTime != null ? DateFormat('hh:mm a').format(endDateTime) : '';

    return Training(
      id: id,
      title: data['trainingTitle'] ?? '',
      description: data['trainingDesc'] ?? '',
      date: formattedDate,
      startTime: formattedStart,
      endTime: formattedEnd,
    );
  }
}
