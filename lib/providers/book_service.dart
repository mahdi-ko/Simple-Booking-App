import 'package:booking_app/providers/service.dart';

class BookedService {
  final DateTime date;
  final String time;
  final List<Service> services;
  const BookedService({required this.date, required this.time, required this.services});
}
