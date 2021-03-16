import 'dart:convert';

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    this.dateAndTime,
    this.steps,
  });

  String name;
  DateTime dateAndTime;
  int steps;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        dateAndTime: DateTime.parse(json["DateAndTime"]),
        steps: json["Steps"],
      );

  Map<String, dynamic> toJson() => {
        "DateAndTime": dateAndTime.toIso8601String(),
        "Steps": steps,
      };
}
