// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temperature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Temperature _$TemperatureFromJson(Map<String, dynamic> json) {
  return Temperature(
    celsius: (json['celsius'] as num).toDouble(),
    fahrenheit: (json['fahrenheit'] as num).toDouble(),
  );
}

Map<String, dynamic> _$TemperatureToJson(Temperature instance) =>
    <String, dynamic>{
      'fahrenheit': instance.fahrenheit,
      'celsius': instance.celsius,
    };
