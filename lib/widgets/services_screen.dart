import 'package:booking_app/common/common_widgets.dart';
import 'package:booking_app/providers/service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServicesScreen extends StatefulWidget {
  static const route = '/services';

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  Map<String, bool> chosenServices = {};
  ThemeData? theme;
  bool didRanDidChangeDep = false;

  @override
  void didChangeDependencies() {
    if (!didRanDidChangeDep) {
      chosenServices = ModalRoute.of(context)!.settings.arguments as Map<String, bool>;
      theme = Theme.of(context);
      didRanDidChangeDep = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final services = Provider.of<Services>(context, listen: false).services;

    return Scaffold(
      appBar: AppBar(
        title: Text('Services'),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          style: orangeButtonStyle(theme),
          child: Text('Back'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 25),
          HeaderText('Choose Services', theme!),
          Expanded(
            child: GridView(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 4,
                mainAxisSpacing: 10,
              ),
              children: services.map((service) {
                return ServiceWidget(service: service, chosenServices: chosenServices);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceWidget extends StatefulWidget {
  final Service service;
  final Map<String, bool> chosenServices;
  const ServiceWidget({required this.service, required this.chosenServices});

  @override
  _ServiceWidgetState createState() => _ServiceWidgetState();
}

class _ServiceWidgetState extends State<ServiceWidget> {
  bool? isChecked;
  @override
  Widget build(BuildContext context) {
    isChecked = widget.chosenServices[widget.service.name] ?? false;

    return GestureDetector(
      onTap: () {
        _changeCheckVal(!isChecked!);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              widget.service.imageSrc!,
              color: Colors.black26,
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Positioned(
            left: 10,
            top: 20,
            child: Text(
              widget.service.name!,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Positioned(
            right: 10,
            top: 20,
            child: Checkbox(
              value: isChecked,
              onChanged: (newVal) {
                _changeCheckVal(newVal!);
              },
            ),
          )
        ],
      ),
    );
  }

  void _changeCheckVal(bool newVal) {
    widget.chosenServices[widget.service.name!] = newVal;
    setState(() {
      isChecked = newVal;
    });
  }
}
