import 'package:booking_app/widgets/add_person.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddPerson(),
    );
  }
}
