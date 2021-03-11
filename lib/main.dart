import 'package:booking_app/providers/Person.dart';
import 'package:booking_app/widgets/add_person.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Persons>(
          create: (_) {
            return Persons();
          },
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Booking App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.orange[700],
        ),
        home: AddPerson(),
      ),
    );
  }
}
