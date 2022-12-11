import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';

class Info {
  String name;
  String details;
  TimeOfDay time;
  DateTime date;

  Info(this.name, this.details, this.time, this.date);

  String getname() {
    return name;
  }

  String getdetails() {
    return details;
  }

  TimeOfDay gettime() {
    return time;
  }

  DateTime getdate() {
    return date;
  }
}
