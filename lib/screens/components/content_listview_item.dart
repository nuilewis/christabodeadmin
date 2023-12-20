import 'package:christabodeadmin/screens/components/custom_alert_dialog.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../core/date_time_formatter.dart';

class ContentListViewItem extends StatelessWidget {
  final String title;
  final DateTime date;
  final DateTime? endDate;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;
  final bool ishymn;

  const ContentListViewItem(
      {super.key,
      required this.title,
      required this.date,
      this.endDate,
      required this.onEditPressed,
      required this.onDeletePressed,
      this.ishymn = false,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Visibility(
                  visible:  !ishymn,
                  child: Row(
                    children: [
                      Text(
                        dateTimeFormatter(context, date),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Visibility(
                          visible: endDate != null,
                          child: Text(
                            " - ${dateTimeFormatter(context, endDate ?? DateTime.now())}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),

          IconButton(
              onPressed: onEditPressed,
              icon: const Icon(FluentIcons.edit_24_regular)),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CustomAlertDialog(action: onDeletePressed, text: "Are you sure you want to delete this\nDevotional Message? this action cannot be undone", actionLabel: "Yes, Delete")
              );
            },
            icon: const Icon(FluentIcons.delete_24_regular),
            color: Theme.of(context).colorScheme.error,
          ),
        ],
      ),
    );
  }
}

