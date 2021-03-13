import 'dart:convert';
import 'dart:core';

import 'package:booking_app/common/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Person with ChangeNotifier {
  final String? id;
  final String? firstName;
  final String? lastName;
  final int? age;
  final Map<String, dynamic> servicesData;

  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.servicesData,
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
      required Map<String, dynamic> servicesData}) async {
    try {
      final response = await http.post(Uri.https(_url, '/person.json'),
          body: json.encode({
            'firstName': first,
            'lastName': last,
            'age': age,
            'servicesData': servicesData.map((name, value) {
              if (value is DateTime)
                return MapEntry(name, value.toIso8601String());
              else if (value is TimeOfDay) {
                print(timeToString(value));
                return MapEntry(name, timeToString(value));
              }
              return MapEntry(name, value);
            })
          }));
      if (response.statusCode >= 400) {
        throw Error;
      }
      _persons.add(Person(
          id: json.decode(response.body)['name'],
          firstName: first,
          lastName: last,
          age: age,
          servicesData: servicesData));
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

  String convertPersonToJSON(Person person) {
    return json
        .encode({'firstName': person.firstName, 'lastName': person.lastName, 'age': person.age});
  }
}
