import 'package:flutter/material.dart';
import '../../core/constants.dart';

class CustomAlertDialog extends StatelessWidget {
  final VoidCallback action;
  final String text;
  final String actionLabel;
  final Color? actionColor;
  final Color? actionLabelColor;
  const CustomAlertDialog(
      {super.key,
      required this.action,
      required this.text,
      required this.actionLabel,
      this.actionColor,
      this.actionLabelColor});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actionsPadding: const EdgeInsets.all(16),
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(48)),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
        const SizedBox(width: 16),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    actionColor ?? Theme.of(context).colorScheme.error),
            onPressed: () {
              action.call();
              Navigator.pop(context);
            },
            child: Text(
              actionLabel,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: actionLabelColor ?? AppColours.white),
            ))
      ],
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
