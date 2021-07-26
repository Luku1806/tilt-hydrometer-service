// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historyEntry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryEntry _$HistoryEntryFromJson(Map<String, dynamic> json) {
  return HistoryEntry(
    dateTime: DateTime.parse(json['date'] as String),
    value: HistoryEntryValue.fromJson(json['value'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$HistoryEntryToJson(HistoryEntry instance) =>
    <String, dynamic>{
      'date': instance.dateTime.toIso8601String(),
      'value': instance.value,
    };

HistoryEntryValue _$HistoryEntryValueFromJson(Map<String, dynamic> json) {
  return HistoryEntryValue(
    specificGravitySg: (json['specificGravity'] as num).toDouble(),
    temperatureFahrenheit: (json['temperature'] as num).toDouble(),
  );
}

Map<String, dynamic> _$HistoryEntryValueToJson(HistoryEntryValue instance) =>
    <String, dynamic>{
      'specificGravity': instance.specificGravitySg,
      'temperature': instance.temperatureFahrenheit,
    };
