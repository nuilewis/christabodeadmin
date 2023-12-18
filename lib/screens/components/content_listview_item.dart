import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../core/date_time_formatter.dart';

class ContentListViewItem extends StatelessWidget {
  final String title;
  final DateTime date;
  final DateTime? endDate;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const ContentListViewItem({super.key, required this.title, required this.date, this.endDate, required this.onEditPressed, required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return    Container(
      padding: EdgeInsets.all(8),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),),
              Row(
                children: [
                  Text(dateTimeFormatter(context, date), style: Theme.of(context).textTheme.bodyMedium,),
                  Visibility(
                      visible: endDate !=null,
                      child: Text(" - ${dateTimeFormatter(context, endDate??DateTime.now())}", style: Theme.of(context).textTheme.bodyMedium,)),
                ],
              )

            ],),
          Spacer(),
          IconButton(onPressed: onEditPressed, icon: Icon(FluentIcons.edit_24_regular)),
          IconButton(onPressed: onDeletePressed, icon: Icon(FluentIcons.delete_24_regular),),
        ],
      ),
    );
  }
}

