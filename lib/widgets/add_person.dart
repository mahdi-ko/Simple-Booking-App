import 'package:booking_app/common/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPerson extends StatefulWidget {
  @override
  _AddPersonState createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateTime? chosenDate = DateTime.now();
  TimeOfDay? chosenTime = TimeOfDay.now();

  final inputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.blue));

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Services'),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Personal Information',
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: inputBorder,
                  ),
                  validator: (value) {
                    return validateName(value);
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: inputBorder,
                  ),
                  validator: (value) {
                    return validateName(value);
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d?\d'))],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: inputBorder,
                  ),
                  validator: (value) {
                    if (double.tryParse(value!) == null) return 'please enter a number';
                    if (double.parse(value) < 13) return 'children can\'t book services sorry';
                  },
                ),
                SizedBox(height: 40),
                Text(
                  'Booking Information',
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: 20),
                _DateOrTimeRow(
                    controller: dateController,
                    onPressed: () async {
                      final tmpHolder = await datePicker(context: context);

                      if (tmpHolder != null) {
                        chosenDate = tmpHolder;
                        setState(() {
                          dateController.text = convertDate(chosenDate)!;
                        });
                      }
                    },
                    inputBorder: inputBorder),
                SizedBox(height: 20),
                _DateOrTimeRow(
                  controller: timeController,
                  inputBorder: inputBorder,
                  onPressed: () async {
                    final tmpHolder = await timePicker(context: context);

                    if (tmpHolder != null) {
                      chosenTime = tmpHolder;
                      setState(() {
                        timeController.text = chosenTime!.format(context);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime?> datePicker({required BuildContext? context}) async {
    final now = DateTime.now();
    return await showDatePicker(
        currentDate: chosenDate,
        firstDate: now,
        context: context!,
        helpText: 'you can book in the next 100 days',
        initialDate: chosenDate!,
        lastDate: DateTime.now().add(Duration(days: 100)));
  }

  Future<TimeOfDay?> timePicker({required BuildContext? context}) {
    return showTimePicker(context: context!, initialTime: TimeOfDay.now());
  }
}

class _DateOrTimeRow extends StatelessWidget {
  const _DateOrTimeRow({
    required this.controller,
    required this.onPressed,
    required this.inputBorder,
  });

  final TextEditingController? controller;
  final Function? onPressed;
  final OutlineInputBorder? inputBorder;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 8,
          child: OutlinedButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.resolveWith((s) {
                return Size(10, 40);
              }),
            ),
            onPressed: () {
              onPressed!();
            },
            child: Text('Date'),
          ),
        ),
        Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 15,
          child: SizedBox(
            height: 40,
            child: TextFormField(
              enabled: false,
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Chosen date',
                border: inputBorder,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
