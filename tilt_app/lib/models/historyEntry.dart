import 'package:json_annotation/json_annotation.dart';

part 'historyEntry.g.dart';

@JsonSerializable()
class HistoryEntry {
  @JsonKey(name: "date")
  final DateTime dateTime;
  final HistoryEntryValue value;

  HistoryEntry({required this.dateTime, required this.value});

  factory HistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$HistoryEntryFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryEntryToJson(this);
}

@JsonSerializable()
class HistoryEntryValue {
  @JsonKey(name: "specificGravity")
  final double specificGravitySg;

  @JsonKey(name: "temperature")
  final double temperatureFahrenheit;

  HistoryEntryValue({
    required this.specificGravitySg,
    required this.temperatureFahrenheit,
  });

  factory HistoryEntryValue.fromJson(Map<String, dynamic> json) =>
      _$HistoryEntryValueFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryEntryValueToJson(this);
}
