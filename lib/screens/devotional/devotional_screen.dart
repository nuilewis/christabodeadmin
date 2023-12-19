import 'package:christabodeadmin/models/devotional_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/enum/app_state.dart';
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
  DateTime? startDate;
  DateTime? endDate;
  String year = DateTime.now().year.toString();
  bool isEditing = false;
  Devotional _oldDevotional = Devotional.empty;

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
                          Text("Devotional Messages",
                              style: Theme.of(context).textTheme.headlineSmall),
                          const Gap(24),
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: devotionalData.dataStream,
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                  List<Devotional> allDevotionals = [];

                                  ///Parsing data
                                  dynamic documentData = snapshot.data!.docs;
                                  for (var element in documentData) {
                                    Map<String, dynamic> data =
                                        element.data() as Map<String, dynamic>;
                                    List<dynamic> monthlyList =
                                        data["devotional"] as List<dynamic>;
                                    for (Map<String, dynamic> element
                                        in monthlyList) {
                                      allDevotionals.add(
                                          Devotional.fromMap(data: element));
                                    }
                                  }

                                  devotionalData
                                      .updateDevotionalList(allDevotionals);
                                }

                                return ListView.separated(
                                  shrinkWrap: true,
                                  itemCount:
                                      devotionalData.allDevotionals.length,
                                  itemBuilder: (context, index) {
                                    return ContentListViewItem(
                                        title: devotionalData
                                            .allDevotionals[index].title,
                                        onEditPressed: () {
                                          _oldDevotional = devotionalData
                                              .allDevotionals[index];

                                          ///Trigger devotional Edit
                                          ///
                                          titleController.text =
                                              _oldDevotional.title;
                                          scriptureController.text =
                                              _oldDevotional.scripture;
                                          scriptureRefController.text =
                                              _oldDevotional.scriptureReference;
                                          contentController.text =
                                              _oldDevotional.content;
                                          confessionController.text =
                                              _oldDevotional.confessionOfFaith;
                                          startDateController.text =
                                              _oldDevotional.startDate
                                                  .toString();
                                          endDateController.text =
                                              _oldDevotional.endDate.toString();

                                          if (_oldDevotional.author ==
                                              "Pst. Leonard") {
                                            author = DevotionalAuthor.brLeo;
                                          } else if (_oldDevotional.author ==
                                              "Pst. Belinda") {
                                            author =
                                                DevotionalAuthor.auntyBelinda;
                                          } else {
                                            author = DevotionalAuthor.drDivine;
                                          }

                                          setState(() {
                                            isEditing = true;
                                          });
                                        },
                                        onDeletePressed: () {
                                          devotionalData
                                              .deleteDevotionalMessage(
                                                  devotional: devotionalData
                                                      .allDevotionals[index]);
                                        },
                                        date: devotionalData
                                            .allDevotionals[index].startDate);
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
                                Text(
                                    isEditing
                                        ? "Edit Message"
                                        : "Add Devotional Messages",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                                const Spacer(),
                                Visibility(
                                  visible: isEditing,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                                    onPressed: () {
                                      setState(() {
                                        isEditing = false;
                                        titleController.text = '';
                                        scriptureController.text = '';
                                        scriptureRefController.text = '';
                                        contentController.text = '';
                                        confessionController.text = '';
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
                            const Text("Message Title"),
                            const Gap(8),
                            TextFormField(
                              key: titleKey,
                              controller: titleController,
                              decoration:
                                  AppInputDecoration.inputDecoration(context)
                                      .copyWith(
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
                            const Gap(16),
                            const Text("Scripture Reference"),
                            const Gap(8),
                            TextFormField(
                              key: scriptureRefKey,
                              controller: scriptureRefController,
                              decoration:
                                  AppInputDecoration.inputDecoration(context)
                                      .copyWith(
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
                            const Gap(16),
                            const Text("Scripture"),
                            const Gap(8),
                            TextFormField(
                              maxLines: 5,
                              key: scriptureKey,
                              controller: scriptureController,
                              decoration:
                                  AppInputDecoration.inputDecoration(context)
                                      .copyWith(
                                hintText: "Scripture",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The Scripture cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Gap(16),
                            const Text("Message Content"),
                            const Gap(8),
                            TextFormField(
                              maxLines: 15,
                              key: contentKey,
                              controller: contentController,
                              decoration:
                                  AppInputDecoration.inputDecoration(context)
                                      .copyWith(
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
                            const Gap(16),
                            const Text("Confession of Faith and Prayer"),
                            const Gap(8),
                            TextFormField(
                              maxLines: 5,
                              key: confessionKey,
                              controller: confessionController,
                              decoration:
                                  AppInputDecoration.inputDecoration(context)
                                      .copyWith(
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
                            const Gap(16),
                            const Text("Start Date"),
                            const Gap(8),
                            TextFormField(
                              key: startDateKey,
                              controller: startDateController,
                              keyboardType: TextInputType.datetime,
                              decoration:
                                  AppInputDecoration.inputDecoration(context)
                                      .copyWith(
                                hintText: "Start Date",
                              ),
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
                                      .copyWith(hintText: "End Date"),
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
                            const Gap(16),
                            const Text("Author"),
                            const Gap(8),
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
                                    author = selectedAuthor ??
                                        DevotionalAuthor.brLeo;
                                  });
                                }),
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
                                    Devotional newDevotional = Devotional(
                                        title: titleController.text,
                                        scripture: scriptureController.text,
                                        scriptureReference:
                                            scriptureRefController.text,
                                        confessionOfFaith:
                                            confessionController.text,
                                        author: getAuthor(author),
                                        content: contentController.text,
                                        startDate: startDate ??
                                            _oldDevotional.startDate,
                                        endDate:
                                            endDate ?? _oldDevotional.endDate);

                                    if (isEditing) {
                                      await devotionalData
                                          .editDevotionalMessage(
                                              oldDevotional: _oldDevotional,
                                              newDevotional: newDevotional);
                                    } else {
                                      await devotionalData
                                          .uploadDevotionalMessage(
                                              devotional: newDevotional);
                                    }

                                    if (devotionalData.state ==
                                        AppState.error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(devotionalData
                                                  .errorMessage)));
                                    }
                                    if (devotionalData.state ==
                                        AppState.submitting) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Submitting, please wait")));
                                    }
                                    if (devotionalData.state ==
                                        AppState.success) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Successfully submitted")));
                                    }
                                  } else {
                                    ///Todo: throw a snackbar or something
                                  }
                                },
                                child: Text(isEditing
                                    ? "Save"
                                    : "Add Devotional Message")),

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
