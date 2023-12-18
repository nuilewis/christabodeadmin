import 'dart:io';

import 'package:christabodeadmin/core/date_time_formatter.dart';
import 'package:christabodeadmin/core/enum/content_type.dart';
import 'package:christabodeadmin/models/devotional_model.dart';
import 'package:christabodeadmin/models/event_model.dart';
import 'package:christabodeadmin/models/prayer_model.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/enum/app_state.dart';
import '../../models/hymn_modell.dart';
import '../../providers/devotional_provider.dart';
import '../components/content_listview_item.dart';

class DevotionalScreen extends StatefulWidget {
  static const id = "devotional_screen";
  const DevotionalScreen({super.key});

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
  List<String> authorNames = ["Leonard, Belinda, Dr. Divine"];
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  String year = DateTime.now().year.toString();

  @override
  void dispose() {
    confessionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    contentController.dispose();
    scriptureRefController.dispose();
    scriptureController.dispose();
    titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DevotionalProvider>(
      builder: (context, devotionalData, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.light? AppColours.neutral95: Colors.black,
          body: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 4),
                  child: Container(
                    decoration:  BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Gap(32),
                          Text("Devotional Messages",
                              style: Theme.of(context).textTheme.headlineSmall),
                      Gap(24),
                      ContentListViewItem( title: "Devotional Title", onEditPressed: () {  }, onDeletePressed: () {  }, date: DateTime.now(),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, top: 8, bottom: 8, right: 8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
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
                            const Gap( 16),
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.chevron_left_rounded)),
                           Gap(16),
                            Text("Add Devotional Messages",
                                style: Theme.of(context).textTheme.headlineSmall),

                            Gap(48),
                            const Text("Message Title"),
                            Gap(8),
                            TextFormField(
                              key: titleKey,
                              controller: titleController,
                              decoration: AppInputDecoration.inputDecoration(context).copyWith(
                                  hintText: "Message Title",
                             ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The message title cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            Gap(16),
                            const Text("Scripture Reference"),
                            Gap(8),
                            TextFormField(
                              key: scriptureRefKey,
                              controller: scriptureRefController,
                              decoration: AppInputDecoration.inputDecoration(context).copyWith(
                                  hintText: "Scripture Reference",
                             ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The scripture Ref cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            Gap(16),
                            const Text("Scripture"),
                            Gap(8),
                            TextFormField(
                              maxLines: 5,
                              key: scriptureKey,
                              controller: scriptureController,
                              decoration: AppInputDecoration.inputDecoration(context).copyWith(
                                  hintText: "Scripture",),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The Scripture cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            Gap(16),
                            const Text("Message Content"),
                            Gap(8),
                            TextFormField(
                              maxLines: 15,
                              key: contentKey,
                              controller: contentController,
                              decoration: AppInputDecoration.inputDecoration(context).copyWith(
                                  hintText: "Message Content",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The message content cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            Gap(16),
                            const Text("Confession of Faith and Prayer"),
                            Gap(8),
                            TextFormField(
                              maxLines: 5,
                              key: confessionKey,
                              controller: confessionController,
                              decoration: AppInputDecoration.inputDecoration(context).copyWith(
                                  hintText: "Confession of Faith",
                   ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The confession of Faith & prayer cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            Gap(16),
                            const Text("Start Date"),
                            Gap(8),
                            TextFormField(
                              key: startDateKey,
                              controller: startDateController,
                              keyboardType: TextInputType.datetime,
                              decoration: AppInputDecoration.inputDecoration(context).copyWith(
                                  hintText: "Start Date",),
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
                                  startDateController.text = startDate.toString();
                                });
                              },
                            ),
                            Gap(16),
                            const Text("end Date"),
                            Gap(8),
                            TextFormField(
                              key: endDateKey,
                              controller: endDateController,
                              keyboardType: TextInputType.datetime,
                              decoration: AppInputDecoration.inputDecoration(context).copyWith(
                                  hintText: "End Date"),
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
                                    initialDate: startDate ?? DateTime.now(),
                                    firstDate: DateTime(2022),
                                    lastDate: DateTime(2030),
                                );

                                setState(() {
                                  endDateController.text = endDate.toString();
                                });
                              },
                            ),
                            Gap(16),
                            const Text("Author"),
                            Gap(8),
                            DropdownButton<DevotionalAuthor>(
                                value: author,
                                hint: const Text("Select Author"),
                                items: const [
                                  DropdownMenuItem<DevotionalAuthor>(
                                      value: DevotionalAuthor.brLeo,
                                      child: Text("Pst. Leo")),
                                  DropdownMenuItem<DevotionalAuthor>(
                                      value: DevotionalAuthor.auntyBelinda,
                                      child: Text("Pst. Belinda")),
                                  DropdownMenuItem<DevotionalAuthor>(
                                      value: DevotionalAuthor.drDivine,
                                      child: Text("Pst. Dr. Divine")),
                                ],
                                onChanged: (DevotionalAuthor? selectedAuthor) {
                                  setState(() {
                                    author = selectedAuthor ?? DevotionalAuthor.brLeo;
                                  });
                                }),
                            Gap(16),

                            ///---------Button-------///
                            ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    Devotional devotionalToAdd = Devotional(
                                        title: titleController.text,
                                        scripture: scriptureController.text,
                                        scriptureReference: scriptureRefController.text,
                                        confessionOfFaith: confessionController.text,
                                        author: getAuthor(author),
                                        content: contentController.text,
                                        startDate: startDate!,
                                        endDate: endDate!);

                                    await devotionalData.uploadDevotionalMessage(
                                        devotional: devotionalToAdd);

                                    if (devotionalData.state == AppState.error) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text(devotionalData.errorMessage)));
                                    }
                                    if (devotionalData.state ==
                                        AppState.submitting) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text("Submitting, please wait")));
                                    }
                                    if (devotionalData.state ==
                                        AppState.success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text("Successfully submitted")));
                                    }
                                  } else {
                                    ///Todo: throw a snackbar or something
                                  }
                                },
                                child: const Text("Add Devotional Message")),

                            Gap(48),
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

  ///Todo: move this method somewher else
  String getAuthor(devotionalAuthor) {
    if (devotionalAuthor == DevotionalAuthor.brLeo) {
      return "Pst. Leonard";
    } else if (devotionalAuthor == DevotionalAuthor.auntyBelinda) {
      return "Pst. Belinda";
    } else {
      return "Pst. Dr. Divine";
    }
  }
}

