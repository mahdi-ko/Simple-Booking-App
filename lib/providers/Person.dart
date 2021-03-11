import 'dart:core';

import 'package:flutter/material.dart';

class Person with ChangeNotifier {
  final int? id;
  final String? firstName;
  final String? lastName;
  final int? age;

  Person({required this.id, required this.firstName, required this.lastName, required this.age});
}

class Persons with ChangeNotifier {
  final List<Person> _persons = [];

  List<Person> get persons => _persons;

  void addPerson({String? first, String? last, int? age}) {
    _persons.add(Person(id: 1, firstName: first, lastName: last, age: age));
  }

  void removePerson({required int? id}) {
    _persons.removeWhere((person) {
      return person.id == id;
    });
  }
}
