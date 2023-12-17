import 'package:flutter/material.dart';

///-------DateTime constants---------///
// Map<int, String> _daysOfWeek = {
//   1: "Monday",
//   2: "Tuesday",
//   3: "Wednesday",
//   4: "Thursday",
//   5: "Friday",
//   6: "Saturday",
//   7: "Sunday",
// };

Map<int, String> _daysOfWeekShortened = {
  1: "Mon",
  2: "Tues",
  3: "Wed",
  4: "Thurs",
  5: "Fri",
  6: "Sat",
  7: "Sun",
};
//
// Map<int, String> _monthsOfYear = {
//   1: "January",
//   2: "February",
//   3: "March",
//   4: "April",
//   5: "May",
//   6: "June",
//   7: "July",
//   8: "August",
//   9: "September",
//   10: "October",
//   11: "November",
//   12: "December",
// };
Map<int, String> _monthsOfYearShortened = {
  1: "Jan",
  2: "Feb",
  3: "Mar",
  4: "Apr",
  5: "May",
  6: "Jun",
  7: "Jul",
  8: "Aug",
  9: "Sept",
  10: "Oct",
  11: "Nov",
  12: "Dec",
};

String dateTimeFormatter(BuildContext context, DateTime dateTime) {
  //String formattedTime = TimeOfDay.fromDateTime(dateTime).format(context);

  ///Format the date time in day, month, year
  //
  // String fullyFormattedDate =
  //     "${_daysOfWeek[dateTime.weekday]}, ${dateTime.day} ${_monthsOfYear[dateTime.month]}, ${dateTime.year}  $formattedTime";

  String fullyFormattedDate =
      "${_daysOfWeekShortened[dateTime.weekday]}, ${dateTime.day} ${_monthsOfYearShortened[dateTime.month]}, ${dateTime.year} ";

  return fullyFormattedDate;
}
