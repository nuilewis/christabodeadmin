import 'package:christabodeadmin/providers/event_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/enum/app_state.dart';
import '../../models/event_model.dart';
import '../components/content_listview_item.dart';

class EventScreen extends StatefulWidget {
  static const id = "events_screen";
  const EventScreen({super.key});

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

  DateTime? startDate;
  DateTime? endDate;
  String year = DateTime.now().year.toString();
  bool isEditing = false;
  Event _oldEvent = Event.empty;

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
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? AppColours.neutral95
              : Colors.black,
          body: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, top: 8, bottom: 8, right: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(8),
                          Text("Events",
                              style: Theme.of(context).textTheme.headlineSmall),
                          const Gap(24),
                          Expanded(
                            child: StreamBuilder<DocumentSnapshot>(
                              stream: eventData.dataStream,
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return const Center(
                                      child: Text("An error has occurred"));
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: Text("Loading, Please wait"));
                                }
                                if (snapshot.hasData) {
                                  List<Event> allEvents = [];

                                  ///Parsing data
                                  dynamic documentData = snapshot.data?.data();

                                  for (Map<String, dynamic> element
                                      in documentData["events"]) {
                                    allEvents.add(Event.fromMap(data: element));
                                  }

                                  eventData.updateEventsList(allEvents);
                                }

                                return ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: eventData.allEvents.length,
                                  itemBuilder: (context, index) {
                                    return ContentListViewItem(
                                      title: eventData.allEvents[index].name,
                                      onEditPressed: () {
                                        _oldEvent = eventData.allEvents[index];

                                        ///Trigger Event Edit
                                        ///
                                        nameController.text = _oldEvent.name;
                                        descriptionController.text =
                                            _oldEvent.description;
                                        startDateController.text =
                                            _oldEvent.startDate.toString();
                                        endDateController.text =
                                            _oldEvent.endDate.toString();

                                        setState(() {
                                          isEditing = true;
                                        });
                                      },
                                      onDeletePressed: () {
                                        eventData.deleteEvent(
                                            event: eventData.allEvents[index]);
                                      },
                                      date:
                                          eventData.allEvents[index].startDate,
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Gap(8);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 4, top: 8, bottom: 8, right: 8),
                  child: Container(

                    height: MediaQuery.sizeOf(context).height,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(24),
                            Row(
                              children: [
                                Text(isEditing ? "Edit Event" : "Add Event",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                                const Spacer(),
                                Visibility(
                                  visible: isEditing,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .error),
                                    onPressed: () {
                                      setState(() {
                                        isEditing = false;
                                        nameController.text = '';
                                        descriptionController.text = '';
                                        startDateController.text = '';
                                        endDateController.text = '';
                                      });
                                    },
                                    child: const Text("Cancel Edit"),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(24),
                            const Text("Event name"),
                            const Gap(8),
                            TextFormField(
                              key: nameKey,
                              controller: nameController,
                              decoration:
                                  AppInputDecoration.inputDecoration(context)
                                      .copyWith(hintText: "Event Name"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The event name cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Gap(16),
                            const Text("Event description"),
                            const Gap(8),
                            TextFormField(
                              maxLines: 15,
                              key: descriptionKey,
                              controller: descriptionController,
                              decoration:
                                  AppInputDecoration.inputDecoration(context)
                                      .copyWith(
                                hintText: "Event description",
                              ),
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return "The event description cannot be empty";
                              //   } else {
                              //     return null;
                              //   }
                              // },
                            ),
                            const Gap(16),
                            const Text("Start Date"),
                            const Gap(8),
                            TextFormField(
                              key: startDateKey,
                              controller: startDateController,
                              keyboardType: TextInputType.datetime,
                              decoration:
                                  AppInputDecoration.inputDecoration(context)
                                      .copyWith(hintText: "Start Date"),
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
                                    initialDate: startDate ?? DateTime.now(),
                                    firstDate: DateTime(2022),
                                    lastDate: DateTime(2030));

                                setState(() {
                                  startDateController.text =
                                      startDate.toString();
                                });
                              },
                            ),
                            const Gap(16),
                            const Text("end Date"),
                            const Gap(8),
                            TextFormField(
                              key: endDateKey,
                              controller: endDateController,
                              keyboardType: TextInputType.datetime,
                              decoration:
                                  AppInputDecoration.inputDecoration(context)
                                      .copyWith(
                                hintText: "End Date",
                              ),
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return "The end date cannot be blank";
                              //   } else {
                              //     return null;
                              //   }
                              // },
                              onTap: () async {
                                endDate = await showDatePicker(
                                    context: context,
                                    initialDate: startDate ?? DateTime.now(),
                                    firstDate: DateTime(2022),
                                    lastDate: DateTime(2030));

                                setState(() {
                                  endDateController.text = endDate.toString();
                                });
                              },
                            ),
                            const Gap(16),

                            ///---------Button-------///
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    foregroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    Event newEvent = Event(
                                        name: nameController.text,
                                        description: descriptionController.text,
                                        startDate: startDate ?? _oldEvent.startDate,
                                        endDate: endDate ?? _oldEvent.endDate);

                                    if (isEditing) {
                                      await eventData.editEvent(
                                          oldEvent: _oldEvent,
                                          newEvent: newEvent);
                                    } else {
                                      await eventData.uploadEvent(
                                          event: newEvent);
                                    }

                                    if (eventData.state == AppState.error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  eventData.errorMessage)));
                                    }
                                    if (eventData.state ==
                                        AppState.submitting) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Submitting please wait")));
                                    }
                                    if (eventData.state == AppState.success) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Successfully submitted")));
                                    }
                                  } else {
                                    ///Todo: throw a snackbar or something
                                  }
                                },
                                child: Text(isEditing ? "Save" : "Add Event")),
                            const Gap(48),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
