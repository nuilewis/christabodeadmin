import 'package:christabodeadmin/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/event_model.dart';

class EventScreen extends StatefulWidget {
  static const id = "events_screen";
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  final Key nameKey = GlobalKey(debugLabel: "event name key");

  final Key descriptionKey = GlobalKey(debugLabel: "event description key");

  final Key startDateKey = GlobalKey(debugLabel: "event start date key");
  final Key endDateKey = GlobalKey(debugLabel: "event end date key");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  String year = DateTime.now().year.toString();

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    descriptionController.dispose();
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventData, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.chevron_left_rounded)),
                    const SizedBox(height: 10),
                    Text("Events",
                        style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 40),
                    const Text("Event name"),
                    TextFormField(
                      key: nameKey,
                      controller: nameController,
                      decoration: const InputDecoration(
                          hintText: "Event Name", labelText: "Event Name"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "The event name cannot be empty";
                        } else {
                          return null;
                        }
                      },
                    ),

                    const Text("Event description"),
                    TextFormField(
                      maxLines: 15,
                      key: descriptionKey,
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          hintText: "Event description",
                          labelText: "Event description"),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return "The event description cannot be empty";
                      //   } else {
                      //     return null;
                      //   }
                      // },
                    ),

                    const Text("Start Date"),
                    TextFormField(
                      key: startDateKey,
                      controller: startDateController,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                          hintText: "Start Date", labelText: "Start Date"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "The start date cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      onTap: () async {
                        startDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2030));

                        setState(() {
                          startDateController.text = startDate.toString();
                        });
                      },
                    ),

                    const Text("end Date"),

                    TextFormField(
                      key: endDateKey,
                      controller: endDateController,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                          hintText: "Start Date", labelText: "Start Date"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "The end date cannot be blank";
                        } else {
                          return null;
                        }
                      },
                      onTap: () async {
                        endDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2024));

                        setState(() {
                          endDateController.text = endDate.toString();
                        });
                      },
                    ),

                    ///---------Button-------///
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            Event eventToAdd = Event(
                                name: nameController.text,
                                description: descriptionController.text,
                                startDate: startDate!,
                                endDate: endDate!);

                            await eventData.uploadEvent(event: eventToAdd);

                            if (eventData.state == EventState.error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(eventData.errorMessage)));
                            }
                            if (eventData.state == EventState.submitting) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Submitting please wait")));
                            }
                            if (eventData.state == EventState.success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Successfully submitted")));
                            }
                          } else {
                            ///Todo: throw a snackbar or something
                          }
                        },
                        child: const Text("upload Event"))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
