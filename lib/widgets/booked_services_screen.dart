import 'dart:math';

import 'package:booking_app/common/common_methods.dart';
import 'package:booking_app/widgets/services_screen.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/providers/person.dart';
import 'package:provider/provider.dart';

class BookedServicesScreen extends StatelessWidget {
  static const route = '/bookedServices';

  @override
  Widget build(BuildContext context) {
    final persons = Provider.of<Persons>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Booked Services"),
      ),
      body: FutureBuilder(
        future: persons.fetchAndSetBookedServices(),
        builder: (_, snap) {
          return snap.connectionState == ConnectionState.done
              ? persons.persons.length > 0
                  ? ListView.builder(
                      itemCount: persons.persons.length,
                      itemBuilder: (__, i) => _BookedWidget(persons.persons.reversed.toList()[i]),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${snap.data}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _BookedWidget extends StatefulWidget {
  final Person person;

  const _BookedWidget(this.person);

  @override
  __BookedWidgetState createState() => __BookedWidgetState();
}

class __BookedWidgetState extends State<_BookedWidget> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ExpansionPanelList(
      expansionCallback: (panelIndex, _) {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      children: [
        ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: _isExpanded,
            headerBuilder: (_, __) => ListTile(
                  title: Text('Name: ' + widget.person.firstName! + ' ' + widget.person.lastName!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Age: ' + widget.person.age.toString()),
                      Text('Date of Booking: ' +
                          convertDate(widget.person.bookedService.date)! +
                          ' ' +
                          widget.person.bookedService.time),
                    ],
                  ),
                  isThreeLine: true,
                ),
            body: SizedBox(
              height: min(widget.person.bookedService.services.length * 200,
                  min(400, MediaQuery.of(context).size.height / 2)),
              child: ListView.builder(
                  itemCount: widget.person.bookedService.services.length,
                  itemBuilder: (_, i) => SizedBox(
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ServiceWidget(
                            chosenServices: {},
                            service: widget.person.bookedService.services[i],
                            showCheckBox: false,
                          ),
                        ),
                      )),
            )),
      ],
    ));
  }
}
