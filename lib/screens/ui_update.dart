import 'package:christabodeadmin/core/constants.dart';
import 'package:flutter/material.dart';

class UiUpdateScreen extends StatelessWidget {
  const UiUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.neutral95,
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: AppColours.white),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: AppColours.white),
              child: SingleChildScrollView(
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
                    Text("Add Devotional Message",
                        style: Theme.of(context).textTheme.headlineSmall),

                    const SizedBox(height: 40),
                    const Text("Message Title"),
                    TextFormField(
                     decoration: AppInputDecoration.inputDecoration(context).copyWith(hintText: "Message Title"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "The message title cannot be empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const Text("scripture reference"),
                    TextFormField(
                      decoration:  AppInputDecoration.inputDecoration(context).copyWith(
                          labelText: "Scripture Reference"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "The scripture Ref cannot be empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const Text("Scripture"),
                    TextFormField(
                      maxLines: 5,
                      decoration:  AppInputDecoration.inputDecoration(context).copyWith(
                          hintText: "Scripture", labelText: "Scripture"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "The Scripture cannot be empty";
                        } else {
                          return null;
                        }
                      },
                    ),

                    const Text("Message Content"),
                    TextFormField(
                      maxLines: 15,
                      decoration:  AppInputDecoration.inputDecoration(context).copyWith(
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
                      maxLines: 5,
                     decoration:  AppInputDecoration.inputDecoration(context).copyWith(
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
                      keyboardType: TextInputType.datetime,
                      decoration:  AppInputDecoration.inputDecoration(context).copyWith(
                          hintText: "Start Date", labelText: "Start Date"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "The start date cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      onTap: () async {}
                    ),

                    const Text("end Date"),

                    TextFormField(
                      keyboardType: TextInputType.datetime,
                      decoration:  AppInputDecoration.inputDecoration(context).copyWith(
                          hintText: "End Date", labelText: "Start Date"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "The end date cannot be blank";
                        } else {
                          return null;
                        }
                      },
                      onTap: () async {},

                    ),

                    const Text("Author"),


                    ///---------Button-------///

                  ],
                ),
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DataListViewItems extends StatelessWidget {
  const DataListViewItems({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

