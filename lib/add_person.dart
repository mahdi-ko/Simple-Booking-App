import 'package:flutter/material.dart';

class AddPerson extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Services'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Colors.blue)),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'please fill out this field';
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Colors.blue)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
