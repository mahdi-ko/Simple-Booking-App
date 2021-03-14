import 'package:booking_app/providers/person.dart';
import 'package:booking_app/providers/service.dart';
import 'package:booking_app/widgets/add_person.dart';
import 'package:booking_app/widgets/booked_services_screen.dart';
import 'package:booking_app/widgets/services_screen.dart';
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
          create: (_) => Persons(),
        ),
        ChangeNotifierProvider<Services>(
          create: (_) => Services(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Booking App',
        theme: ThemeData(
          unselectedWidgetColor: Colors.white,
          primarySwatch: Colors.blue,
          accentColor: Colors.orange[800],
        ),
        home: AddPerson(),
        routes: {
          ServicesScreen.route: (ctx) => ServicesScreen(),
          BookedServicesScreen.route: (ctx) => BookedServicesScreen(),
        },
      ),
    );
  }
}
