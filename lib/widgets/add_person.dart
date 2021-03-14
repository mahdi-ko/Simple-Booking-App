import 'package:booking_app/common/common_methods.dart';
import 'package:booking_app/common/common_widgets.dart';
import 'package:booking_app/providers/book_service.dart';
import 'package:booking_app/providers/person.dart';
import 'package:booking_app/providers/service.dart';
import 'package:booking_app/widgets/booked_services_screen.dart';
import 'package:booking_app/widgets/services_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddPerson extends StatefulWidget {
  @override
  _AddPersonState createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateTime? chosenDate = DateTime.now();
  TimeOfDay? chosenTime = TimeOfDay.now();
  String firstName = '';
  String lastName = '';
  int age = 0;
  Map<int, bool> chosenServices = {};
  GlobalKey<FormState> _formKey = GlobalKey();

  final inputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.blue));

  ThemeData? theme;
  Persons? persons;
  bool didRanChangeDep = false;

  bool isLoading = false;
  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    dateController.text = convertDate(chosenDate)!;
    persons = Provider.of<Persons>(context, listen: false);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!didRanChangeDep) {
      timeController.text = chosenTime!.format(context);
      theme = Theme.of(context);
      didRanChangeDep = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: <Widget>[
        ElevatedButton(
          child: Text('Booked Services'),
          onPressed: () {
            removeFocus(context);
            Navigator.of(context).pushNamed(BookedServicesScreen.route);
          },
          style: orangeButtonStyle(theme),
        ),
        ElevatedButton.icon(
          style: orangeButtonStyle(theme),
          icon: const Icon(Icons.local_fire_department_rounded),
          label: const Text('Submit'),
          onPressed: () {
            if (!isLoading) submit();
          },
        )
      ],
      appBar: AppBar(
        title: const Text('Book Services'),
      ),
      body: GestureDetector(
        onTap: () {
          removeFocus(context);
        },
        child: Form(
          key: _formKey,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        HeaderText('Personal Information', theme!),
                        SizedBox(height: 20),
                        TextFormField(
                          initialValue: firstName,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            border: inputBorder,
                          ),
                          validator: (value) {
                            return validateName(value);
                          },
                          onSaved: (newValue) {
                            firstName = newValue!.trim();
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          initialValue: lastName,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            border: inputBorder,
                          ),
                          validator: (value) {
                            return validateName(value);
                          },
                          onSaved: (newValue) {
                            lastName = newValue!.trim();
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          initialValue: age == 0 ? '' : age.toString(),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d?\d'))],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Age',
                            border: inputBorder,
                          ),
                          validator: (value) {
                            if (double.tryParse(value!) == null) return 'please enter your age';
                            if (double.parse(value) == 0) return 'you are 0 years old?';
                            if (double.parse(value) < 13)
                              return 'children can\'t book services sorry';
                          },
                          onSaved: (newValue) {
                            age = int.parse(newValue!);
                          },
                        ),
                        SizedBox(height: 40),
                        HeaderText('Booking Information', theme!),
                        SizedBox(height: 20),
                        _DateOrTimeRow(
                            text: 'Date',
                            controller: dateController,
                            onPressed: () async {
                              removeFocus(context);
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
                          text: 'Time',
                          controller: timeController,
                          inputBorder: inputBorder,
                          onPressed: () async {
                            removeFocus(context);
                            final tmpHolder = await timePicker(context: context);
                            if (tmpHolder != null) {
                              chosenTime = tmpHolder;
                              setState(() {
                                timeController.text = chosenTime!.format(context);
                              });
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text('Choose Services'),
                            onPressed: () {
                              removeFocus(context);
                              navigateToServices();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  void submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final servProvider = Provider.of<Services>(context, listen: false);

    final List<Service> services = [];
    chosenServices.forEach((serviceId, value) {
      if (value) {
        services.add(servProvider.getServiceBy(serviceId));
      }
    });
    if (services.isEmpty) {
      showSnackBar('Please choose at least 1 service');
      return;
    }
    _formKey.currentState!.save();

    final BookedService bookedService =
        BookedService(date: chosenDate!, time: convertTime(chosenTime!), services: services);
    changeIsLoading(true);
    try {
      await persons!
          .addPerson(first: firstName, last: lastName, age: age, bookedService: bookedService);
      showSnackBar('Booking successful', icon: Icons.domain_verification_sharp);
      resetForm();
    } catch (error) {
      showSnackBar('Booking failed', icon: Icons.error_outline_outlined);
    } finally {
      changeIsLoading(false);
    }
  }

  void navigateToServices() {
    Navigator.of(context).pushNamed(ServicesScreen.route, arguments: chosenServices);
  }

  Future<DateTime?> datePicker({required BuildContext? context}) async {
    final now = DateTime.now();
    return await showDatePicker(
      currentDate: chosenDate,
      firstDate: now,
      context: context!,
      helpText: 'you can book in the next 100 days',
      initialDate: chosenDate!,
      lastDate: DateTime.now().add(Duration(days: 100)),
    );
  }

  Future<TimeOfDay?> timePicker({required BuildContext? context}) {
    return showTimePicker(context: context!, initialTime: TimeOfDay.now());
  }

  void showSnackBar(String text, {IconData? icon}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Row(
          children: [
            if (icon != null) Icon(icon, color: Colors.white),
            if (icon != null) SizedBox(width: 10),
            Text(text),
          ],
        ),
      ),
    );
  }

  void resetForm() {
    firstName = '';
    lastName = '';
    age = 0;
    _formKey.currentState!.reset();
    chosenServices = {};
  }

  void changeIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}

class _DateOrTimeRow extends StatelessWidget {
  const _DateOrTimeRow({
    required this.text,
    required this.controller,
    required this.onPressed,
    required this.inputBorder,
  });
  final String? text;
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
            child: Text(text!),
          ),
        ),
        Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 15,
          child: SizedBox(
            height: 40,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) return 'Please choose a $text';
              },
              enabled: false,
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Chosen ${text!.toLowerCase()}',
                border: inputBorder,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
