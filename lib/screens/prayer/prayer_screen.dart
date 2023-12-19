import 'package:christabodeadmin/providers/prayer_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/enum/app_state.dart';
import '../../models/prayer_model.dart';
import '../components/content_listview_item.dart';

class PrayerScreen extends StatefulWidget {
  static const id = "prayer_screen";
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController scriptureController = TextEditingController();
  final TextEditingController scriptureRefController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final Key titleKey = GlobalKey(debugLabel: "title prayer key");
  final Key scriptureKey = GlobalKey(debugLabel: "scripture prayer key");
  final Key scriptureRefKey =
      GlobalKey(debugLabel: "scripture reference prayer key");
  final Key contentKey = GlobalKey(debugLabel: "content prayer key");

  final Key dateKey = GlobalKey(debugLabel: "date prayer key");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? date;
  String year = DateTime.now().year.toString();
  bool isEditing = false;
  Prayer _oldPrayer = Prayer.empty;

  @override
  void dispose() {
    contentController.dispose();
    scriptureRefController.dispose();
    scriptureController.dispose();
    titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerProvider>(
      builder: (context, prayerData, child) {
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
                          Text("Prayers",
                              style: Theme.of(context).textTheme.headlineSmall),
                          const Gap(24),
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: prayerData.dataStream,
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
                                  List<Prayer> allPrayers = [];

                                  ///Parsing data
                                  dynamic documentData = snapshot.data!.docs;
                                  for (var element in documentData) {
                                    Map<String, dynamic> data =
                                        element.data() as Map<String, dynamic>;
                                    List<dynamic> monthlyList =
                                        data["prayer"] as List<dynamic>;
                                    for (Map<String, dynamic> element
                                        in monthlyList) {
                                      allPrayers
                                          .add(Prayer.fromMap(data: element));
                                    }
                                  }

                                  prayerData.updateDPrayerList(allPrayers);
                                }

                                return ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: prayerData.allPrayers.length,
                                  itemBuilder: (context, index) {
                                    return ContentListViewItem(
                                        title:
                                            prayerData.allPrayers[index].title,
                                        onEditPressed: () {
                                          _oldPrayer =
                                              prayerData.allPrayers[index];

                                          ///Trigger Prayer Edit
                                          ///
                                          titleController.text =
                                              _oldPrayer.title;
                                          scriptureController.text =
                                              _oldPrayer.scripture;
                                          scriptureRefController.text =
                                              _oldPrayer.scriptureReference;
                                          contentController.text =
                                              _oldPrayer.content;

                                          dateController.text =
                                              _oldPrayer.date.toString();

                                          setState(() {
                                            isEditing = true;
                                          });
                                        },
                                        onDeletePressed: () {
                                          prayerData.deletePrayer(
                                              prayer:
                                                  prayerData.allPrayers[index]);
                                        },
                                        date:
                                            prayerData.allPrayers[index].date);
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
                                Text(isEditing ? "Edit Prayer" : "Add Prayer",
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
                                        titleController.text = '';
                                        scriptureController.text = '';
                                        scriptureRefController.text = '';
                                        contentController.text = '';
                                        dateController.text = '';
                                      });
                                    },
                                    child: const Text("Cancel Edit"),
                                  ),
                                ),
                              ],
                            ),

                            const Gap(24),
                            const Text("Prayer Title"),
                            const Gap(8),
                            TextFormField(
                              key: titleKey,
                              controller: titleController,
                              decoration:
                                  AppInputDecoration.inputDecoration(context)
                                      .copyWith(hintText: "Prayer Title"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The prayer title cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Gap(16),
                            const Text("scripture reference"),
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
                                  return "The scripture Reference cannot be empty";
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
                                      .copyWith(hintText: "Scripture"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The scripture cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Gap(16),
                            const Text("Prayer Content"),
                            const Gap(8),
                            TextFormField(
                              maxLines: 15,
                              key: contentKey,
                              controller: contentController,
                              decoration:
                                  AppInputDecoration.inputDecoration(context)
                                      .copyWith(
                                hintText: "Prayer Content",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The Prayer content cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Gap(16),
                            const Text("Date"),
                            const Gap(8),

                            TextFormField(
                              key: dateKey,
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                              decoration:
                                  AppInputDecoration.inputDecoration(context)
                                      .copyWith(hintText: "Date"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The date cannot be blank";
                                } else {
                                  return null;
                                }
                              },
                              onTap: () async {
                                date = await showDatePicker(
                                    context: context,
                                    initialDate: date ?? DateTime.now(),
                                    firstDate: DateTime(2022),
                                    lastDate: DateTime(2030));

                                setState(() {
                                  dateController.text = date.toString();
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
                                    Prayer newPrayer = Prayer(
                                        title: titleController.text,
                                        scripture: scriptureController.text,
                                        scriptureReference:
                                            scriptureRefController.text,
                                        content: contentController.text,
                                        date: date ?? _oldPrayer.date);

                                    if (isEditing) {
                                      await prayerData.editPrayer(
                                          oldPrayer: _oldPrayer,
                                          newPrayer: newPrayer);
                                    } else {
                                      await prayerData.uploadPrayer(
                                          prayer: newPrayer);
                                    }

                                    if (prayerData.state == AppState.error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  prayerData.errorMessage)));
                                    }
                                    if (prayerData.state ==
                                        AppState.submitting) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Submitting, please wait")));
                                    }
                                    if (prayerData.state == AppState.success) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Successfully submitted")));
                                    }
                                  } else {
                                    ///Todo: throw a snackbar or something
                                  }
                                },
                                child: Text(isEditing ? "Save" : "Add Prayer")),
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
