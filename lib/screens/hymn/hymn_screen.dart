import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../core/enum/app_state.dart';
import '../../../models/hymn_modell.dart';
import '../../core/constants.dart';
import '../../providers/hymn_provider.dart';
import '../components/content_listview_item.dart';

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

  bool isEditing = false;
  Hymn _oldHymn = Hymn.empty;

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
                          Text("Hymns",
                              style: Theme.of(context).textTheme.headlineSmall),
                          const Gap(24),
                          Expanded(
                            child: StreamBuilder<DocumentSnapshot>(
                              stream: hymnData.dataStream,
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
                                  List<Hymn> allHymns = [];

                                  ///Parsing data
                                  Map<String, dynamic> documentData = snapshot.data?.data() as Map<String, dynamic>;

                                  for (Map<String, dynamic> element
                                  in documentData["hymn"]) {
                                    allHymns.add(Hymn.fromMap(data: element));
                                  }
                                  hymnData.updateHymnList(allHymns);

                                }

                                return ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: hymnData.allHymns.length,
                                  itemBuilder: (context, index) {
                                    return ContentListViewItem(
                                      ishymn: true,
                                      
                                      title:hymnData.allHymns[index].title,
                                      
                                      onEditPressed: () {
                                        _oldHymn = hymnData.allHymns[index];
                                       

                                        ///Trigger Event Edit
                                        contentController.text = _oldHymn.content;
                                        titleController.text = _oldHymn.title;
                                        numberController.text = _oldHymn.number.toString();

                                        setState(() {
                                          isEditing = true;
                                        });
                                      },
                                      onDeletePressed: () {
                                        hymnData.deleteHymn(hymn: hymnData.allHymns[index]);

                                      },
                                      date: DateTime.now(),

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
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(24),
                            Row(
                              children: [
                                Text(isEditing ? "Edit Hymn" : "Add Hymn",
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
                                        contentController.text ='';
                                        numberController.text ='';
                                        contentController.text = '';
                                      });
                                    },
                                    child: const Text("Cancel Edit"),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(24),
                            const Text("Hymn Title"),
                            const Gap(8),
                            TextFormField(
                              controller: titleController,
                              decoration:  AppInputDecoration.inputDecoration(context)
                                      .copyWith(
                                  hintText: "Hymn Title"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The Hymn title cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Gap(16),          
                            const Text("Hymn Number"),
                            const Gap(8),
                            TextFormField(
                              controller: numberController,
                              keyboardType: TextInputType.number,
                              decoration:  AppInputDecoration.inputDecoration(context)
                                      .copyWith(
                                  hintText: "Hymn Number - Must be an integer",),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The Hymn number cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Gap(16),            
                            const Text("Hymn Content"),
                            const Gap(8),
                            TextFormField(
                              maxLines: 15,
                              controller: contentController,
                              decoration:  AppInputDecoration.inputDecoration(context)
                                      .copyWith(
                                  hintText: "Hymn Content"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The Hymn content cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                            ),
                                          
                            ///---------Button-------///
                            const Gap(16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                                  foregroundColor: Theme.of(context)
                                      .scaffoldBackgroundColor),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    Hymn newHymn = Hymn(
                                      title: titleController.text.trim(),
                                      content: contentController.text.trim(),
                                      number: int.parse(
                                        numberController.text.trim(),
                                      ),
                                    );
                                    if (isEditing) {
                                      await hymnData.editHymn(
                                          oldHymn: _oldHymn,
                                          newHymn: newHymn);
                                    } else {
                                      await hymnData.uploadHymn(hymn: newHymn);
                                    }


                                    
                                          
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
                                child: Text(isEditing
                                    ? "Save"
                                    : "Add  Hymn")),
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
