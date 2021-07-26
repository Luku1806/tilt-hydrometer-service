// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tilt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tilt _$TiltFromJson(Map<String, dynamic> json) {
  return Tilt(
    color: json['color'] as String,
    lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    temperature:
        Temperature.fromJson(json['temperature'] as Map<String, dynamic>),
    startingGravitySg: (json['startingGravity'] as num).toDouble(),
    specificGravitySg: (json['specificGravity'] as num).toDouble(),
    history: (json['history'] as List<dynamic>)
        .map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$TiltToJson(Tilt instance) => <String, dynamic>{
      'color': instance.color,
      'temperature': instance.temperature,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'history': instance.history,
      'startingGravity': instance.startingGravitySg,
      'specificGravity': instance.specificGravitySg,
    };
