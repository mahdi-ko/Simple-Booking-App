import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:booking_app/providers/book_service.dart';
import 'package:booking_app/providers/service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Person with ChangeNotifier {
  final String? id;
  final String? firstName;
  final String? lastName;
  final int? age;
  final BookedService bookedService;

  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.bookedService,
  });
}

class Persons with ChangeNotifier {
  final List<Person> _persons = [];
  List<Person> get persons => _persons;

  static const _url = 'flutter-simple-booking-default-rtdb.firebaseio.com';

  Future<void> addPerson(
      {required String? first,
      required String? last,
      required int? age,
      required BookedService bookedService}) async {
    try {
      var response = await http.post(Uri.https(_url, '/persons.json'),
          body: json.encode({
            'firstName': first,
            'lastName': last,
            'age': age,
            'bookedServices': encodeBookedServicesToJson(bookedService),
          }));
      if (response.statusCode >= 400) {
        throw Error;
      }
      final personId = json.decode(response.body)['name'];

      _persons.add(Person(
        id: personId,
        firstName: first,
        lastName: last,
        age: age,
        bookedService: bookedService,
      ));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  void removePerson({required String? id}) {
    _persons.removeWhere((person) {
      return person.id == id;
    });
  }

  Map<String, dynamic> encodeBookedServicesToJson(BookedService bookedService) {
    return {
      'date': bookedService.date.toIso8601String(),
      'time': bookedService.time,
      'service': bookedService.services.map((service) {
        return {'id': service.id, 'name': service.name, 'imageSrc': service.imageSrc};
      }).toList()
    };
  }

  BookedService decodeBookedServicesToJson(Map<String, dynamic> bookServToDecode) {
    return BookedService(
        date: DateTime.parse(bookServToDecode['date'] as String),
        time: bookServToDecode['time'],
        services: (bookServToDecode['service'] as List<dynamic>).map((value) {
          return Service(
            id: value['id'],
            name: value['name'],
            imageSrc: value['imageSrc'],
          );
        }).toList());
  }

  Future<String?> fetchAndSetBookedServices() async {
    try {
      final response = await http.get(Uri.https(_url, '/persons.json'));
      if (response.body == 'null') return 'No Servcices Are Booked Yet';
      final Map<String, dynamic> extractedPersons = json.decode(response.body) ?? {};
      _persons.clear();
      extractedPersons.forEach((key, value) {
        _persons.add(Person(
            id: key,
            firstName: value['firstName'],
            lastName: value['lastName'],
            age: value['age'],
            bookedService: decodeBookedServicesToJson(value['bookedServices'])));
      });
      return 'Working as expected :-)';
    } catch (e) {
      if (e is SocketException) return 'There is a problem with you connection';
      return 'Error';
    }
  }
}
