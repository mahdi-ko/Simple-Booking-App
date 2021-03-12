import 'package:flutter/cupertino.dart';

class Service {
  final int? id;
  final String? name;
  final String? imageSrc;

  Service({required this.id, required this.name, required this.imageSrc});
}

class Services with ChangeNotifier {
  final _services = [
    Service(id: 1, name: 'Amazing Car', imageSrc: 'assets/car.jpg'),
    Service(id: 2, name: 'Wonderful House', imageSrc: 'assets/house.jpg'),
    Service(id: 3, name: 'Poweful laptop', imageSrc: 'assets/laptop.jpg'),
    Service(id: 4, name: 'Harmony Headphones', imageSrc: 'assets/headphones.jpg'),
    Service(id: 5, name: 'Next Generation Phone', imageSrc: 'assets/mobile.jpg')
  ];

  List<Service> get services => _services;
}
