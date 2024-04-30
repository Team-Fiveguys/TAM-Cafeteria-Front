class NotificationModel {
  final int id;
  final String title;
  final String content;
  final String date;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.isRead,
  });
}
