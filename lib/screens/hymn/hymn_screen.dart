import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/enum/app_state.dart';
import '../../../models/hymn_modell.dart';
import '../../providers/hymn_provider.dart';

class HymnScreen extends StatefulWidget {
  static const id = "hymn_screen";
  const HymnScreen({super.key});

  @override
  State<HymnScreen> createState() => _HymnScreenState();
}

class _HymnScreenState extends State<HymnScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    contentController.dispose();
    titleController.dispose();
    numberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HymnnProvider>(
      builder: (context, hymnData, child) {
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
                    Text("Hymns",
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 40),
                    const Text("Hymn Title"),
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          hintText: "Hymn Title", labelText: "HymnTitle"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "The Hymn title cannot be empty";
                        } else {
                          return null;
                        }
                      },
                    ),

                    const Text("Hymn Number"),
                    TextFormField(
                      controller: numberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: "Hymn Title", labelText: "HymnTitle"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "The Hymn number cannot be empty";
                        } else {
                          return null;
                        }
                      },
                    ),

                    const Text("Hymn Content"),
                    TextFormField(
                      maxLines: 15,
                      controller: contentController,
                      decoration: const InputDecoration(
                          hintText: "Hymn Content", labelText: "Hymn Content"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "The Hymn content cannot be empty";
                        } else {
                          return null;
                        }
                      },
                    ),

                    ///---------Button-------///
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            Hymn hymnToAdd = Hymn(
                              title: titleController.text.trim(),
                              content: contentController.text.trim(),
                              number: int.parse(
                                numberController.text.trim(),
                              ),
                            );

                            await hymnData.uploadHymn(hymn: hymnToAdd);

                            if (hymnData.state == AppState.error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(hymnData.errorMessage)));
                            }
                            if (hymnData.state == AppState.submitting) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Submitting, please wait")));
                            }
                            if (hymnData.state == AppState.success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Successfully submitted")));
                            }
                          } else {
                            ///Todo: throw a snackbar or something
                          }
                        },
                        child: const Text("Upload Hymn"))
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
