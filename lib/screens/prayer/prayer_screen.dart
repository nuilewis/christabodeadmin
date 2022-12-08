import 'package:christabodeadmin/providers/prayer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/prayer_model.dart';

class PrayerScreen extends StatefulWidget {
  static const id = "prayer_screen";
  const PrayerScreen({Key? key}) : super(key: key);

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

  DateTime? date = DateTime.now();
  String year = DateTime.now().year.toString();

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
                      Text("Prayers",
                          style: Theme.of(context).textTheme.headline4),
                      const SizedBox(height: 40),
                      const Text("prayer Title"),
                      TextFormField(
                        key: titleKey,
                        controller: titleController,
                        decoration: const InputDecoration(
                            hintText: "prayer Title",
                            labelText: "prayer Title"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "The prayer title cannot be empty";
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
                            return "The scripture cannot be empty";
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
                      const Text("Prayer Content"),
                      TextFormField(
                        maxLines: 15,
                        key: contentKey,
                        controller: contentController,
                        decoration: const InputDecoration(
                            hintText: "Prayer Content",
                            labelText: "Prayer Content"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "The Prayer content cannot be empty";
                          } else {
                            return null;
                          }
                        },
                      ),

                      const Text("Date"),

                      TextFormField(
                        key: dateKey,
                        controller: dateController,
                        keyboardType: TextInputType.datetime,
                        decoration: const InputDecoration(
                            hintText: "Date", labelText: "Date"),
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
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2022),
                              lastDate: DateTime(2024));

                          setState(() {
                            dateController.text = date.toString();
                          });
                        },
                      ),

                      ///---------Button-------///
                      ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              Prayer prayerToAdd = Prayer(
                                  title: titleController.text,
                                  scripture: scriptureController.text,
                                  scriptureReference:
                                      scriptureRefController.text,
                                  content: contentController.text,
                                  date: date!);

                              await prayerData.uploadPrayer(
                                  prayer: prayerToAdd);

                              if (prayerData.state == PrayerState.error) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "An error has occurred: ${prayerData.errorMessage}")));
                              }
                              if (prayerData.state == PrayerState.submitting) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Submitting please wait")));
                              }
                              if (prayerData.state == PrayerState.success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Successfully submitted")));
                              }
                            } else {
                              ///Todo: throw a snackbar or something
                            }
                          },
                          child: const Text("Upload Prayer"))
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
}
