import 'package:binary_music_tools/models/temperature.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tilt.g.dart';

@JsonSerializable()
class Tilt {
  final String color;
  final Temperature temperature;
  final double startingGravity;
  final double specificGravity;
  final DateTime lastUpdated;

  Tilt({
    required this.color,
    required this.temperature,
    required this.startingGravity,
    required this.specificGravity,
    required this.lastUpdated,
  });

  factory Tilt.fromDto(
    String color,
    String timestamp,
    Map<String, dynamic> dto,
  ) =>
      Tilt(
        color: color,
        startingGravity: dto["startingGravity"] ?? dto["specificGravity"],
        specificGravity: dto["specificGravity"],
        temperature: Temperature.fromJson(dto["temperature"]),
        lastUpdated: DateTime.parse(timestamp),
      );

  factory Tilt.fromJson(Map<String, dynamic> json) => _$TiltFromJson(json);

  Map<String, dynamic> toJson() => _$TiltToJson(this);
}
