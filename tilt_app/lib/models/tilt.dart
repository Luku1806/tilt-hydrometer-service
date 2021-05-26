import 'package:binary_music_tools/beer_calculator.dart';
import 'package:binary_music_tools/models/temperature.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tilt.g.dart';

@JsonSerializable()
class Tilt {
  final String color;
  final Temperature temperature;
  final DateTime lastUpdated;

  @JsonKey(name: "startingGravity")
  final double startingGravitySg;

  @JsonKey(name: "specificGravity")
  final double specificGravitySg;

  double get startingGravityPlato =>
      startingGravitySg; //BeerCalculator.sgToPlato(_startingGravity);

  double get specificGravityPlato => BeerCalculator.sgToPlato(specificGravitySg);

  Tilt({
    required this.color,
    required this.lastUpdated,
    required this.temperature,
    required this.startingGravitySg,
    required this.specificGravitySg,
  });

  factory Tilt.fromDto(
    String color,
    String timestamp,
    Map<String, dynamic> dto,
  ) =>
      Tilt(
        color: color,
        startingGravitySg: dto["startingGravity"] ?? dto["specificGravity"],
        specificGravitySg: dto["specificGravity"],
        temperature: Temperature.fromJson(dto["temperature"]),
        lastUpdated: DateTime.parse(timestamp),
      );

  factory Tilt.fromJson(Map<String, dynamic> json) => _$TiltFromJson(json);

  Map<String, dynamic> toJson() => _$TiltToJson(this);
}
