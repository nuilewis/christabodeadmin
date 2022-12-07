import 'package:christabodeadmin/models/devotional_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/devotional_provider.dart';

class DevotionalScreen extends StatefulWidget {
  static const id = "devotional_screen";
  const DevotionalScreen({Key? key}) : super(key: key);

  @override
  State<DevotionalScreen> createState() => _DevotionalScreenState();
}

//Todo: move this somewhere
enum DevotionalAuthor { auntyBelinda, brLeo, drDivine }

class _DevotionalScreenState extends State<DevotionalScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController scriptureController = TextEditingController();
  final TextEditingController scriptureRefController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController confessionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  final Key titleKey = GlobalKey(debugLabel: "devotional title key");
  final Key scriptureKey =
      GlobalKey(debugLabel: "scripture devotional title key");
  final Key scriptureRefKey =
      GlobalKey(debugLabel: "scripture reference devotional title key");
  final Key contentKey = GlobalKey(debugLabel: "content devotional title key");
  final Key confessionKey =
      GlobalKey(debugLabel: "confession devotional title key");
  final Key startDateKey =
      GlobalKey(debugLabel: "confession devotional title key");
  final Key endDateKey =
      GlobalKey(debugLabel: "confession devotional title key");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DevotionalAuthor author = DevotionalAuthor.brLeo;
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  String year = DateTime.now().year.toString();
  @override
  Widget build(BuildContext context) {
    return Consumer<DevotionalProvider>(
      builder: (context, devotionalData, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Form(
                key: _formKey,
                child: Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Message Title"),
                      TextFormField(
                        key: titleKey,
                        controller: titleController,
                        decoration: const InputDecoration(
                            hintText: "Message Title",
                            labelText: "Message Title"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "The message title cannot be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const Text("Scripture"),
                      TextFormField(
                        key: scriptureKey,
                        controller: scriptureController,
                        decoration: const InputDecoration(
                            hintText: "Scripture", labelText: "Scripture"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "The Scripture cannot be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const Text("scripture reference"),
                      TextFormField(
                        key: scriptureRefKey,
                        controller: scriptureRefController,
                        decoration: const InputDecoration(
                            hintText: "Scripture Reference",
                            labelText: "Scripture Reference"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "The scripture Ref cannot be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const Text("Message Content"),
                      TextFormField(
                        key: contentKey,
                        controller: contentController,
                        decoration: const InputDecoration(
                            hintText: "Message Content",
                            labelText: "Message Content"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "The message content cannot be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const Text("Confession of Faith and Prayer"),
                      TextFormField(
                        key: confessionKey,
                        controller: confessionController,
                        decoration: const InputDecoration(
                            hintText: "Confession of Faith",
                            labelText: "Confession of Faith"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "The confession of Faith & prayer cannot be empty";
                          } else {
                            return null;
                          }
                        },
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
                              initialDate: DateTime(2022),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030));
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
                              initialDate: DateTime(2022),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030));
                        },
                      ),

                      const Text("End date Date"),
                      ElevatedButton(
                          onPressed: () async {
                            endDate = (await showDatePicker(
                                context: context,
                                initialDate: DateTime(2022),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2030)))!;
                          },
                          child: const Text("end Date")),

                      ///---------Button-------///
                      ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              Devotional devotionalToAdd = Devotional(
                                  title: titleController.text,
                                  scripture: scriptureController.text,
                                  scriptureReference:
                                      scriptureRefController.text,
                                  confessionOfFaith: confessionController.text,
                                  author: getAuthor(author),
                                  content: contentController.text,
                                  startDate: startDate!,
                                  endDate: endDate!);

                              await devotionalData.uploadDevotionalMessage(
                                  devotional: devotionalToAdd, year: year);

                              if (devotionalData.state ==
                                  DevotionalState.error) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "an error has occurred ${devotionalData.errorMessage}")));
                              }
                              if (devotionalData.state ==
                                  DevotionalState.submitting) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Submitting please wait")));
                              }
                              if (devotionalData.state ==
                                  DevotionalState.success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Successfully submitted")));
                              }
                            } else {
                              ///Todo: throw a snackbar or something
                            }
                          },
                          child: const Text("Add Devotional Message"))
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ///Todo: move this method somewher else
  String getAuthor(devotionalAuthor) {
    if (devotionalAuthor == DevotionalAuthor.brLeo) {
      return "Leonard";
    } else if (devotionalAuthor == DevotionalAuthor.auntyBelinda) {
      return "Belinda";
    } else {
      return "Dr. Divine";
    }
  }
}
